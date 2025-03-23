//
//  SessionEditViewModel.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 23/03/2025.
//

import Foundation
import SwiftUI

class SessionEditViewModel: ObservableObject {
    @Published var sessions: [Session] = []
    @Published var error: SessionError? = nil
    @Published var message: String = ""
    @Published var idSessionSelected: Int = -1
    @Published var isLoading: Bool = false
    
    private let sessionService = SessionService()
    
    // Date formatter for UI display
    private let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    // Date formatter for API requests
    private let apiDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
    
    init() {
        Task {
            await loadSessions()
        }
    }
    
    func loadSessions() async {
        isLoading = true
        
        do {
            sessions = try await sessionService.getListSession()
            
            DispatchQueue.main.async {
                self.isLoading = false
                self.error = nil
            }
        } catch let err as SessionError {
            DispatchQueue.main.async {
                self.isLoading = false
                self.error = err
                self.message = err.description
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.error = SessionError.ServerError
                self.message = "Erreur inattendue"
            }
        }
    }
    
    func setIdSessionSelected(index: Int) {
        DispatchQueue.main.async {
            self.message = ""
            self.idSessionSelected = index
        }
    }
        func saveSession(titre: String, lieu: String, dateDebut: Date, dateFin: Date, description: String, comission: String) async {
        guard !titre.isEmpty, !lieu.isEmpty, !description.isEmpty, !comission.isEmpty else {
            DispatchQueue.main.async {
                self.message = "Tous les champs doivent être remplis"
            }
            return
        }
        
        let formattedDateDebut = apiDateFormatter.string(from: dateDebut)
        let formattedDateFin = apiDateFormatter.string(from: dateFin)
        
        isLoading = true
        
        do {
            let selectedId = idSessionSelected
            
            // Create a local reference to avoid the concurrency issue
            let session: Session?
            
            if selectedId == -1 {
                session = try await sessionService.createSession(
                    titre: titre,
                    lieu: lieu,
                    dateDebut: formattedDateDebut,
                    dateFin: formattedDateFin,
                    description: description,
                    comission: comission
                )
            } else {
                let sessionId = sessions[selectedId].id
                session = try await sessionService.updateSession(
                    id: sessionId,
                    titre: titre,
                    lieu: lieu,
                    dateDebut: formattedDateDebut,
                    dateFin: formattedDateFin,
                    description: description,
                    comission: comission
                )
            }
            
            // Capture all values needed for the main thread before context switch
            let capturedSession = session
            let capturedSelectedId = selectedId
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let sessionData = capturedSession {
                    if capturedSelectedId != -1 {
                        self.sessions[capturedSelectedId] = sessionData
                        self.message = "Session mise à jour avec succès"
                    } else {
                        self.sessions.append(sessionData)
                        self.message = "Session créée avec succès"
                    }
                } else {
                    self.message = "Aucune donnée de session reçue"
                }
            }
            
        } catch let err as SessionError {
            DispatchQueue.main.async {
                self.isLoading = false
                self.error = err
                self.message = err.description
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.message = "Erreur inattendue"
            }
        }
    }
    func deleteSession() async {
        guard idSessionSelected != -1 else {
            DispatchQueue.main.async {
                self.message = "Aucune session sélectionnée"
            }
            return
        }
        
        let sessionId = sessions[idSessionSelected].id
        isLoading = true
        
        do {
            let success = try await sessionService.deleteSession(id: sessionId)
            
            DispatchQueue.main.async {
                self.isLoading = false
                if success {
                    self.sessions.remove(at: self.idSessionSelected)
                    self.idSessionSelected = -1
                    self.message = "Session supprimée avec succès"
                } else {
                    self.message = "Échec de la suppression"
                }
            }
            
        } catch let err as SessionError {
            DispatchQueue.main.async {
                self.isLoading = false
                self.error = err
                self.message = err.description
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.message = "Erreur inattendue"
            }
        }
    }
    
    // Format a Date for UI display
    func formatDateForDisplay(_ date: Date) -> String {
        return displayDateFormatter.string(from: date)
    }
}