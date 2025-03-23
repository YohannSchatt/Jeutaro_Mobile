//
//  JeuUnitaireService.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import Foundation

struct JeuUnitaireService {
    
    let apiUrl: String
    
    let session = CookieManager.shared.session
    
    init() {
        guard let apiUrl = ProcessInfo.processInfo.environment["API_URL"] else {
            fatalError("API_URL not set in Config file")
        }
        self.apiUrl = apiUrl + "/jeu"
    }
    
    public func createJeuUnitaire(createJeuUnitaireDto : CreateJeuUnitaireDto) async throws -> Bool {
        let url = URL(string: "\(apiUrl)/creerJeuUnitaire")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(createJeuUnitaireDto)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        
        let (_, httpResponse, _) : (Data, HTTPURLResponse, Data) = try await session.getJson(from: request)
        
        if httpResponse.statusCode == 201 {
            return true
        }
        else if httpResponse.statusCode == 401 {
            throw JeuUnitaireError.Unauthorized
        }
        else if httpResponse.statusCode == 500  {
            throw JeuUnitaireError.ServerError
        }
        return false
    }
    
    public func getJeuUnitaireDisponible() async throws -> [InfoJeuUnitaireDisponibleDto]  {
        let url = URL(string: "\(apiUrl)/listInfoAchatJeuUnitaireDisponible")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = true
        
        let (resultDto, httpResponse, _) : ([InfoJeuUnitaireDisponibleDto], HTTPURLResponse, Data) = try await session.getJson(from: request)
        
        if httpResponse.statusCode == 200 {
            return resultDto
        }
        else if httpResponse.statusCode == 401 {
            throw JeuUnitaireError.Unauthorized
        }
        else if httpResponse.statusCode == 500  {
            throw JeuUnitaireError.ServerError
        }
        return []
    }
    
    public func enregistrerAchat(enregistrerAchatDto : EnregistrerAchatDto) async throws -> Bool {
        let url = URL(string: "\(apiUrl)/achat")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(enregistrerAchatDto)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        
        let (_, httpResponse, _) : (Data, HTTPURLResponse, Data) = try await session.getJson(from: request)
        
        if httpResponse.statusCode == 201 {
            return true
        }
        else if httpResponse.statusCode == 401 {
            throw JeuUnitaireError.Unauthorized
        }
        else if httpResponse.statusCode == 500  {
            throw JeuUnitaireError.ServerError
        }
        return false
    }
    
    func jeuxDisponibleByVendeur(vendeurId : Int) async throws -> [InfoJeuUnitaireDisponibleDto]  {
        let url = URL(string: "\(apiUrl)/jeuxDisponibleByVendeur/" + String(vendeurId))!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = true
        
        let (resultDto, httpResponse, _) : ([InfoJeuUnitaireDisponibleDto], HTTPURLResponse, Data) = try await session.getJson(from: request)
        
        if httpResponse.statusCode == 200 {
            return resultDto
        }
        else if httpResponse.statusCode == 401 {
            throw JeuUnitaireError.Unauthorized
        }
        else if httpResponse.statusCode == 500  {
            throw JeuUnitaireError.ServerError
        }
        return []
    }
}
