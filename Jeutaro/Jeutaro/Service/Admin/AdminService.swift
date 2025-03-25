//
//  AdminService.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import Foundation

struct AdminService {
    
    let apiUrl: String
    
    let session = CookieManager.shared.session
    
    init() {
        self.apiUrl = "https://backjeutaro-e8bf61eb52f5.herokuapp.com" + "/admin"
    }
    
    // créé un gestionnaire
    func createGestionnaire(createGestionnaireDto : CreateGestionnaireDto) async throws -> Bool {
        let url = URL(string: "\(apiUrl)/createGestionnaire")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(createGestionnaireDto)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        
        let (_, httpResponse, _) : (Data, HTTPURLResponse, Data) = try await session.getJson(from: request)
            
        if httpResponse.statusCode == 201 {
            return true
        }
        else if httpResponse.statusCode == 401 {
            throw AdminError.Unauthorized
        }
        else if httpResponse.statusCode == 500  {
            throw AdminError.ServerError
        }
        return false
    }
    
    // supprime un gestionnaire
    func deleteGestionnaire(deleteGestionnaireDto : DeleteGestionnaireDto) async throws -> Bool {
        let url = URL(string: "\(apiUrl)/deleteGestionnaire")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(deleteGestionnaireDto)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        
        let (_, httpResponse, _) : (Data, HTTPURLResponse, Data) = try await session.getJson(from: request)
            
        if httpResponse.statusCode == 200 {
            return true
        }
        else if httpResponse.statusCode == 401 {
            throw AdminError.Unauthorized
        }
        else if httpResponse.statusCode == 500  {
            throw AdminError.ServerError
        }
        return false
    }
    
    // récupère la liste des gestionnaires
    func getGestionnaire() async throws -> [GetGestionnaireDto] {
        let url = URL(string: "\(apiUrl)/getGestionnaire")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = true
        
        let (resultDto, httpResponse, _) : ([GetGestionnaireDto], HTTPURLResponse, Data) = try await session.getJson(from: request)
        
        if httpResponse.statusCode == 200 {
            return resultDto
        }
        else if httpResponse.statusCode == 401 {
            throw AdminError.Unauthorized
        }
        else if httpResponse.statusCode == 500  {
            throw AdminError.ServerError
        }
        return []
    }
    
}
