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
        guard let apiUrl = ProcessInfo.processInfo.environment["API_URL"] else {
            fatalError("API_URL not set in Config file")
        }
        self.apiUrl = apiUrl + "/admin"
    }
    
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
            throw VendeurError.Unauthorized
        }
        else if httpResponse.statusCode == 500  {
            throw VendeurError.ServerError
        }
        return []
    }
    
}
