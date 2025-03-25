//
//  SessionViewModel.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 23/03/2025.
//

import Foundation
import SwiftUI

enum LoadingState<T> {
    case idle
    case loading
    case loaded(T)
    case error(String)
}

class SessionViewModel: ObservableObject {
    private let service = SessionService()
    
    // États de chargement existants
    @Published var currentSession: LoadingState<Session?> = .idle
    @Published var upcomingSessions: LoadingState<[Session]> = .idle
    
    // États pour la création de session
    @Published var showCreatePanel: Bool = false
    @Published var isCreating: Bool = false
    @Published var createError: String? = nil
    @Published var createSuccess: Bool = false
    
    // Champs du formulaire
    @Published var titre: String = ""
    @Published var lieu: String = ""
    @Published var dateDebut: Date = Date().addingTimeInterval(24 * 60 * 60) // Demain
    @Published var dateFin: Date = Date().addingTimeInterval(7 * 24 * 60 * 60) // Une semaine après
    @Published var description: String = ""
    @Published var comission: String = "5" // Valeur par défaut
    
    // Formatter pour les dates
    private let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    // Fonctions existantes
    func loadData() {
        loadCurrentSession()
        loadNextSessions()
    }
    
    func loadCurrentSession() {
        currentSession = .loading
        print("Loading current session...")
        
        Task {
            do {
                let session = try await service.getActualSession()
                print("Current session loaded: \(session != nil ? "found" : "not found")")
                
                DispatchQueue.main.async {
                    self.currentSession = .loaded(session)
                }
            } catch let error as SessionError {
                print("Current session error: \(error)")
                DispatchQueue.main.async {
                    self.currentSession = .error(error.description)
                }
            } catch {
                print("Current session unexpected error: \(error)")
                DispatchQueue.main.async {
                    self.currentSession = .error("Erreur inattendue")
                }
            }
        }
    }
    
    func loadNextSessions() {
        upcomingSessions = .loading
        print("Loading upcoming sessions...")
        
        Task {
            do {
                let sessions = try await service.getNextSessions()
                print("Upcoming sessions loaded: \(sessions.count) sessions")
                
                DispatchQueue.main.async {
                    self.upcomingSessions = .loaded(sessions)
                }
            } catch let error as SessionError {
                print("Upcoming sessions error: \(error)")
                DispatchQueue.main.async {
                    self.upcomingSessions = .error(error.description)
                }
            } catch {
                print("Upcoming sessions unexpected error: \(error)")
                DispatchQueue.main.async {
                    self.upcomingSessions = .error("Erreur inattendue")
                }
            }
        }
    }
    
    // Nouvelle fonction pour créer une session
    func createSession() async {
        guard validateForm() else { return }
        
        DispatchQueue.main.async {
            self.isCreating = true
            self.createError = nil
            self.createSuccess = false
        }
        
        let formattedDateDebut = apiDateFormatter.string(from: dateDebut)
        let formattedDateFin = apiDateFormatter.string(from: dateFin)
        
        do {
            let session = try await service.createSession(
                titre: titre,
                lieu: lieu,
                dateDebut: formattedDateDebut,
                dateFin: formattedDateFin,
                description: description,
                comission: comission
            )
            
            DispatchQueue.main.async {
                self.isCreating = false
                
                if session != nil {
                    // Réinitialisation du formulaire en cas de succès
                    self.createSuccess = true
                    self.resetForm()
                    
                    // Recharger les données après 1 seconde pour voir les changements
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.loadData()
                        self.showCreatePanel = false
                        self.createSuccess = false
                    }
                } else {
                    self.createError = "Échec de création de la session"
                }
            }
        } catch let error as SessionError {
            DispatchQueue.main.async {
                self.isCreating = false
                self.createError = error.description
            }
        } catch {
            DispatchQueue.main.async {
                self.isCreating = false
                self.createError = "Erreur inattendue"
            }
        }
    }
    
    private func validateForm() -> Bool {
        if titre.isEmpty || lieu.isEmpty || description.isEmpty {
            DispatchQueue.main.async {
                self.createError = "Tous les champs doivent être remplis"
            }
            return false
        }
        
        if dateDebut >= dateFin {
            DispatchQueue.main.async {
                self.createError = "La date de fin doit être postérieure à la date de début"
            }
            return false
        }
        
        if Float(comission) == nil {
            DispatchQueue.main.async {
                self.createError = "La commission doit être un nombre valide"
            }
            return false
        }
        
        return true
    }
    
    private func resetForm() {
        titre = ""
        lieu = ""
        dateDebut = Date().addingTimeInterval(24 * 60 * 60)
        dateFin = Date().addingTimeInterval(7 * 24 * 60 * 60)
        description = ""
        comission = "5"
    }
}