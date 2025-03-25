//
//  SessionView.swift
//  Jeutaro
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct SessionView: View {
    @StateObject private var viewModel = SessionViewModel()
    @EnvironmentObject var routeur: Routeur
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        ZStack {
            // Contenu principal
            ScrollView {
                VStack(spacing: 16) {
                    // Bouton Créer Session (visible uniquement pour les admins)
                    if userViewModel.getUser()?.getRole() == .ADMIN {
                        createSessionButton
                    }
                    
                    // Current session section
                    currentSessionSection
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Upcoming sessions section
                    upcomingSessionsSection
                }
                .padding(.vertical)
            }
            .navigationTitle("Sessions")
            .onAppear {
                viewModel.loadData()
            }
            .refreshable {
                viewModel.loadData()
            }
            
            // Panneau de création de session
            if viewModel.showCreatePanel {
                createSessionPanel
            }
        }
    }
    
    // MARK: - Create Session Button & Panel
    
    private var createSessionButton: some View {
        Button(action: {
            viewModel.showCreatePanel = true
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 16))
                Text("Créer une session")
                    .fontWeight(.medium)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    private var createSessionPanel: some View {
        ZStack {
            // Overlay semi-transparent
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    // Fermer le panneau si on tape en dehors
                    if !viewModel.isCreating {
                        viewModel.showCreatePanel = false
                    }
                }
            
            // Panneau de création
            VStack(spacing: 0) {
                // Barre de titre
                HStack {
                    Text("Créer une nouvelle session")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.showCreatePanel = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(.gray)
                    }
                    .disabled(viewModel.isCreating)
                }
                .padding()
                .background(Color(.systemBackground))
                
                Divider()
                
                // Formulaire
                ScrollView {
                    VStack(spacing: 16) {
                        // Titre
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Titre")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextField("Titre de la session", text: $viewModel.titre)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        // Lieu
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Lieu")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextField("Lieu de la session", text: $viewModel.lieu)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        // Dates
                        HStack {
                            // Date de début
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Date de début")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                DatePicker("", selection: $viewModel.dateDebut, displayedComponents: [.date])
                                    .labelsHidden()
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            
                            // Date de fin
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Date de fin")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                DatePicker("", selection: $viewModel.dateFin, displayedComponents: [.date])
                                    .labelsHidden()
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Description")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextEditor(text: $viewModel.description)
                                .padding(4)
                                .frame(height: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        // Commission
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Commission (%)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextField("Commission", text: $viewModel.comission)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        // Messages d'erreur ou de succès
                        if let error = viewModel.createError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding()
                        }
                        
                        if viewModel.createSuccess {
                            Text("Session créée avec succès !")
                                .font(.caption)
                                .foregroundColor(.green)
                                .padding()
                        }
                        
                        // Bouton Créer
                        Button(action: {
                            Task {
                                await viewModel.createSession()
                            }
                        }) {
                            if viewModel.isCreating {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Créer la session")
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .disabled(viewModel.isCreating)
                    }
                    .padding()
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 20)
            .padding(20)
            .frame(maxWidth: 500)
        }
    }
    
    // MARK: - Current Session Section
    
    private var currentSessionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session en cours")
                .font(.headline)
                .padding(.horizontal)
            
            switch viewModel.currentSession {
            case .idle, .loading:
                loadingView
                
            case .loaded(let session):
                if let currentSession = session {
                    sessionCard(session: currentSession, isCurrent: true)
                } else {
                    noCurrentSessionView
                }
                
            case .error(let message):
                errorView(message: message)
            }
        }
    }
    
    // MARK: - Upcoming Sessions Section
    
    private var upcomingSessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sessions à venir")
                .font(.headline)
                .padding(.horizontal)
            
            switch viewModel.upcomingSessions {
            case .idle, .loading:
                loadingView
                
            case .loaded(let sessions):
                if sessions.isEmpty {
                    Text("Aucune session à venir")
                        .italic()
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    VStack(spacing: 12) {
                        ForEach(sessions) { session in
                            sessionCard(session: session, isCurrent: false)
                        }
                    }
                }
                
            case .error(let message):
                errorView(message: message)
            }
        }
    }
    
    // MARK: - Supporting Views
    
    private func sessionCard(session: Session, isCurrent: Bool) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(session.titre)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                if isCurrent {
                    Text("En cours")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green)
                        .cornerRadius(8)
                }
            }
            
            Text(session.lieu)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(session.formattedDateRange)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text(session.description)
                .padding(.top, 4)
                .lineLimit(3)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
                .padding()
            Spacer()
        }
    }
    
    private var noCurrentSessionView: some View {
        Text("Aucune session en cours")
            .italic()
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
    }
    
    private func errorView(message: String) -> some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .padding(.bottom, 4)
            
            Text("Erreur de chargement")
                .font(.headline)
            
            Text(message)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Réessayer") {
                viewModel.loadData()
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
            .environmentObject(Routeur())
            .environmentObject(UserViewModel(routeur: Routeur()))
    }
}