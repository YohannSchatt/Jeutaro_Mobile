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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Current session section
                currentSessionSection
                
                Divider()
                    .padding(.horizontal)
                
                // Upcoming sessions section
                upcomingSessionsSection
                
                // Admin button for session management
                adminSection
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
    
    // MARK: - Admin Section
        // Replace only the adminSection part:
    private var adminSection: some View {
        Button(action: {
            // Use your custom router pattern
            routeur.setRoute(route: AnyView(SessionManagementView().environmentObject(routeur)))
        }) {
            HStack {
                Image(systemName: "gearshape.fill")
                Text("Gérer les sessions")
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 20)
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
    }
}