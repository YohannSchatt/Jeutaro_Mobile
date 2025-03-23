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
    
    @Published var currentSession: LoadingState<Session?> = .idle
    @Published var upcomingSessions: LoadingState<[Session]> = .idle
    
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
}