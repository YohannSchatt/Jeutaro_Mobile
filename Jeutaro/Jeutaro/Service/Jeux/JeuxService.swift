//
//  JeuxService.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import Foundation

struct JeuxService {
    
    let apiUrl: String
    
    let session = CookieManager.shared.session
    
    init() {
        self.apiUrl = "https://backjeutaro-e8bf61eb52f5.herokuapp.com" + "/jeu"
    }
    
    //obtient les jeux unitaires de la DB
    func getJeux() async throws -> [InfoJeuDBDto] {
        let url = URL(string: "\(apiUrl)/DBJeu")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.httpShouldHandleCookies = true
        
        let (resultDto, httpResponse, _) : ([InfoJeuDBDto], HTTPURLResponse, Data) = try await session.getJson(from: request)
        
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
