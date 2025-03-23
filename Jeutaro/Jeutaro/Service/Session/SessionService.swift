//
//  SessionService.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 23/03/2025.
//
    
import Foundation

struct SessionService {
    
    let apiUrl: String
    
    let session = CookieManager.shared.session
    
    init() {
        guard let apiUrl = ProcessInfo.processInfo.environment["API_URL"] else {
            fatalError("API_URL not set in Config file")
        }
        self.apiUrl = apiUrl + "/session"
    }
    
    func getActualSession() async throws -> Session? {
        let url = URL(string: "\(apiUrl)/ActualSession")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = true
        
        do {
            let (resultDto, httpResponse, data): (GetSessionDto, HTTPURLResponse, Data) = try await session.getJson(from: request)
            
            print("ActualSession response: \(String(data: data, encoding: .utf8) ?? "no data")")
            
            if httpResponse.statusCode == 200 {
                let session = Session.fromDto(resultDto)
                
                if session == nil {
                    print("⚠️ Failed to convert ActualSession DTO to Session model")
                }
                
                return session
            } else if httpResponse.statusCode == 401 {
                throw SessionError.Unauthorized
            } else {
                throw SessionError.ServerError
            }
        } catch is DecodingError {
            // If decoding fails, there might not be a current session
            print("⚠️ Decoding error for ActualSession")
            return nil
        } catch let error as SessionError {
            throw error
        } catch {
            print("⚠️ Unexpected error: \(error)")
            throw SessionError.ServerError
        }
    }
    
    func getNextSessions() async throws -> [Session] {
        let url = URL(string: "\(apiUrl)/NextSession")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = true
        
        do {
            let (resultDto, httpResponse, data): ([GetSessionDto], HTTPURLResponse, Data) = try await session.getJson(from: request)
            
            print("NextSession response: \(String(data: data, encoding: .utf8) ?? "no data")")
            
            if httpResponse.statusCode == 200 {
                let sessions = resultDto.compactMap { Session.fromDto($0) }
                
                if sessions.isEmpty && !resultDto.isEmpty {
                    print("⚠️ Failed to convert any NextSession DTO to Session model")
                }
                
                return sessions
            } else if httpResponse.statusCode == 401 {
                throw SessionError.Unauthorized
            } else {
                throw SessionError.ServerError
            }
        } catch is DecodingError {
            print("⚠️ Decoding error for NextSession")
            return []
        } catch let error as SessionError {
            throw error
        } catch {
            print("⚠️ Unexpected error: \(error)")
            throw SessionError.ServerError
        }
    }

        // Add these methods to your existing SessionService.swift
    func createSession(titre: String, lieu: String, dateDebut: String, dateFin: String, description: String, comission: String) async throws -> Session? {
        let url = URL(string: "\(apiUrl)/CreateSession")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpShouldHandleCookies = true
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let comissionValue = Float(comission) ?? 0.0
        
        let createSessionDto = [
            "titre": titre,
            "lieu": lieu,
            "dateDebut": dateDebut,
            "dateFin": dateFin,
            "description": description,
            "comission": comissionValue
        ] as [String : Any]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: createSessionDto)
        
        do {
            let (resultDto, httpResponse, data): (GetSessionDto, HTTPURLResponse, Data) = try await session.getJson(from: request)
            
            print("CreateSession response: \(String(data: data, encoding: .utf8) ?? "no data")")
            
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                return Session.fromDto(resultDto)
            } else if httpResponse.statusCode == 401 {
                throw SessionError.Unauthorized
            } else {
                throw SessionError.ServerError
            }
        } catch is DecodingError {
            print("⚠️ Decoding error for CreateSession")
            return nil
        } catch let error as SessionError {
            throw error
        } catch {
            print("⚠️ Unexpected error: \(error)")
            throw SessionError.ServerError
        }
    }
    
    func updateSession(id: Int, titre: String, lieu: String, dateDebut: String, dateFin: String, description: String, comission: String) async throws -> Session? {
        let url = URL(string: "\(apiUrl)/UpdateSession")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.httpShouldHandleCookies = true
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let comissionValue = Float(comission) ?? 0.0
        
        let updateSessionDto = [
            "id": id,
            "titre": titre,
            "lieu": lieu,
            "dateDebut": dateDebut,
            "dateFin": dateFin,
            "description": description,
            "comission": comissionValue
        ] as [String : Any]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: updateSessionDto)
        
        do {
            let (resultDto, httpResponse, data): (GetSessionDto, HTTPURLResponse, Data) = try await session.getJson(from: request)
            
            print("UpdateSession response: \(String(data: data, encoding: .utf8) ?? "no data")")
            
            if httpResponse.statusCode == 200 {
                return Session.fromDto(resultDto)
            } else if httpResponse.statusCode == 401 {
                throw SessionError.Unauthorized
            } else {
                throw SessionError.ServerError
            }
        } catch is DecodingError {
            print("⚠️ Decoding error for UpdateSession")
            return nil
        } catch let error as SessionError {
            throw error
        } catch {
            print("⚠️ Unexpected error: \(error)")
            throw SessionError.ServerError
        }
    }
        func deleteSession(id: Int) async throws -> Bool {
        let url = URL(string: "\(apiUrl)/DeleteSession")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpShouldHandleCookies = true
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let deleteSessionDto = ["id": id]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: deleteSessionDto)
        
        do {
            // Use a direct URLSession call instead of getJson for operations that don't return a Decodable response
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw SessionError.ServerError
            }
            
            print("DeleteSession response: \(String(data: data, encoding: .utf8) ?? "no data")")
            
            if httpResponse.statusCode == 200 {
                return true
            } else if httpResponse.statusCode == 401 {
                throw SessionError.Unauthorized
            } else {
                throw SessionError.ServerError
            }
        } catch let error as SessionError {
            throw error
        } catch {
            print("⚠️ Unexpected error: \(error)")
            throw SessionError.ServerError
        }
    }
    
    func getListSession(titre: String? = nil, lieu: String? = nil, dateDebut: String? = nil, dateFin: String? = nil) async throws -> [Session] {
        let url = URL(string: "\(apiUrl)/GetListSession")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpShouldHandleCookies = true
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var searchSessionDto: [String: Any?] = [:]
        if let titre = titre { searchSessionDto["titre"] = titre }
        if let lieu = lieu { searchSessionDto["lieu"] = lieu }
        if let dateDebut = dateDebut { searchSessionDto["dateDebut"] = dateDebut }
        if let dateFin = dateFin { searchSessionDto["dateFin"] = dateFin }
        
        request.httpBody = try JSONSerialization.data(withJSONObject: searchSessionDto.compactMapValues { $0 })
        
        do {
            let (resultDto, httpResponse, data): ([GetSessionDto], HTTPURLResponse, Data) = try await session.getJson(from: request)
            
            print("GetListSession response: \(String(data: data, encoding: .utf8) ?? "no data")")
            
            if httpResponse.statusCode == 200 {
                let sessions = resultDto.compactMap { Session.fromDto($0) }
                return sessions
            } else if httpResponse.statusCode == 401 {
                throw SessionError.Unauthorized
            } else {
                throw SessionError.ServerError
            }
        } catch is DecodingError {
            print("⚠️ Decoding error for GetListSession")
            return []
        } catch let error as SessionError {
            throw error
        } catch {
            print("⚠️ Unexpected error: \(error)")
            throw SessionError.ServerError
        }
    }
}