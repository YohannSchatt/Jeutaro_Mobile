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
        self.apiUrl = "https://backjeutaro-e8bf61eb52f5.herokuapp.com" + "/jeu"
    }
    
    // créé un jeu unitaire
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
    
    // donne les jeux unitaires disponible a la vente
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
    
    // enregistre l'achat d'un utilisateur
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
    
    // donne les jeux unitaires par vendeur
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
