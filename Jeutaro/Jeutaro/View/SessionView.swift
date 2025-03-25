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
            // Fond avec dégradé
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            // Contenu principal
            ScrollView {
                VStack(spacing: 20) {
                    // En-tête
                    Text("Sessions")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                    
                    // Bouton Créer Session (visible uniquement pour les admins)
                    if userViewModel.getUser()?.getRole() == .ADMIN {
                        createSessionButton
                    }
                    
                    // Current session section
                    currentSessionSection
                    
                    // Diviseur décoratif
                    HStack {
                        Color.gray.opacity(0.3)
                            .frame(height: 1)
                        
                        Text("À venir")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 10)
                        
                        Color.gray.opacity(0.3)
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    
                    // Upcoming sessions section
                    upcomingSessionsSection
                }
                .padding(.vertical)
            }
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
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                               startPoint: .leading, endPoint: .trailing)
            )
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 5)
        }
        .padding(.horizontal)
        .padding(.top, 5)
        .padding(.bottom, 10)
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
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                    
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
                    VStack(spacing: 20) {
                        // Titre
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Titre")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            TextField("Titre de la session", text: $viewModel.titre)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Lieu
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Lieu")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            TextField("Lieu de la session", text: $viewModel.lieu)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Dates
                        HStack(spacing: 15) {
                            // Date de début
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date de début")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                DatePicker("", selection: $viewModel.dateDebut, displayedComponents: [.date])
                                    .labelsHidden()
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .frame(maxWidth: .infinity)
                            
                            // Date de fin
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Date de fin")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                DatePicker("", selection: $viewModel.dateFin, displayedComponents: [.date])
                                    .labelsHidden()
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            TextEditor(text: $viewModel.description)
                                .padding(8)
                                .frame(height: 100)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Commission
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Commission (%)")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            TextField("Commission", text: $viewModel.comission)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        // Messages d'erreur ou de succès
                        VStack(spacing: 5) {
                            if let error = viewModel.createError {
                                Text(error)
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                            
                            if viewModel.createSuccess {
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                    Text("Session créée avec succès !")
                                        .font(.subheadline)
                                        .foregroundColor(.green)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .frame(height: 40)
                        
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
                                    .font(.headline)
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                         startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 5)
                        .disabled(viewModel.isCreating)
                    }
                    .padding()
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            .padding(20)
            .frame(maxWidth: 500)
        }
    }
    
    // MARK: - Current Session Section
    
    private var currentSessionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Session en cours")
                .font(.headline)
                .foregroundColor(.primary)
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
        .padding(.top, 5)
    }
    
    // MARK: - Upcoming Sessions Section
    
    private var upcomingSessionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sessions à venir")
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal)
            
            switch viewModel.upcomingSessions {
            case .idle, .loading:
                loadingView
                
            case .loaded(let sessions):
                if sessions.isEmpty {
                    noUpcomingSessionsView
                } else {
                    VStack(spacing: 15) {
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
        VStack(alignment: .leading, spacing: 12) {
            // En-tête
            HStack {
                Text(session.titre)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                if isCurrent {
                    Text("En cours")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.green)
                                .shadow(color: Color.green.opacity(0.3), radius: 2, x: 0, y: 1)
                        )
                }
            }
            
            // Informations
            VStack(alignment: .leading, spacing: 8) {
                // Lieu
                HStack(spacing: 8) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red.opacity(0.7))
                        .font(.system(size: 16))
                    
                    Text(session.lieu)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Dates
                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue.opacity(0.7))
                        .font(.system(size: 16))
                    
                    Text(session.formattedDateRange)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Commission
                HStack(spacing: 8) {
                    Image(systemName: "percent")
                        .foregroundColor(.green.opacity(0.7))
                        .font(.system(size: 16))
                    
                    Text("Commission: \(session.comission, specifier: "%.1f")%")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // Description
            Text(session.description)
                .font(.body)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
                .lineLimit(3)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white.opacity(0.7))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private var loadingView: some View {
        HStack {
            Spacer()
            VStack(spacing: 15) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.3)
                
                Text("Chargement...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 30)
            Spacer()
        }
    }
    
    private var noCurrentSessionView: some View {
        HStack {
            Spacer()
            VStack(spacing: 12) {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 40))
                    .foregroundColor(.gray.opacity(0.5))
                
                Text("Aucune session en cours")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 30)
            Spacer()
        }
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private var noUpcomingSessionsView: some View {
        HStack {
            Spacer()
            VStack(spacing: 12) {
                Image(systemName: "calendar.badge.plus")
                    .font(.system(size: 40))
                    .foregroundColor(.gray.opacity(0.5))
                
                Text("Aucune session à venir")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 30)
            Spacer()
        }
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(15)
        .padding(.horizontal)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.orange)
                .padding(.bottom, 4)
            
            Text("Erreur de chargement")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(message)
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button(action: {
                viewModel.loadData()
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Réessayer")
                        .fontWeight(.medium)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.blue.opacity(0.15))
                .foregroundColor(.blue)
                .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
            .environmentObject(Routeur())
            .environmentObject(UserViewModel(routeur: Routeur()))
    }
}