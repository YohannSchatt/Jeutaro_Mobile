//
//  UtilisateurService.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import Foundation

struct UtilisateurService {
    
    let apiUrl: String
    
    let session = CookieManager.shared.session
    
    init() {
        self.apiUrl = "https://backjeutaro-e8bf61eb52f5.herokuapp.com" + "/user"
    }
    
    func modifInfo(updateUserDto : UpdateUserDto) async throws -> Bool {
        let url = URL(string: "\(apiUrl)/UpdateInfoPerso")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.httpBody = try JSONEncoder().encode(updateUserDto)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        
        let (_, httpResponse, _) : (Data, HTTPURLResponse, Data) = try await session.getJson(from: request)
        
        print(httpResponse.statusCode)
        
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
    
    func modifPassword(updatePasswordDto : UpdatePasswordDto) async throws -> Bool {
        let url = URL(string: "\(apiUrl)/UpdatePassword")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "PUT"
        request.httpBody = try JSONEncoder().encode(updatePasswordDto)
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
}
