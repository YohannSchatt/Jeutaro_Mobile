//
//  AuthService.swift
//  Jeutaro
//
//  Created by etud on 17/03/2025.
//

import Foundation

struct AuthService {
    
    static let shared = AuthService()
    
    let apiUrl: String
    
    let session = CookieManager.shared.session
    
    init() {
        guard let apiUrl = ProcessInfo.processInfo.environment["API_URL"] else {
            fatalError("API_URL not set in Config file")
        }
        self.apiUrl = apiUrl + "/auth"
    }

    func login(email: String, password: String) async throws -> User {
        let url = URL(string: "\(apiUrl)/login")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let authRequest = SignIn(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(authRequest)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        
        let (result, httpResponse, _) : (LoginResponse, HTTPURLResponse, Data) = try await session.getJson(from: request)
        
        if httpResponse.statusCode != 200 {
            throw AuthError.Unauthorized
        }
        
        if let headers = httpResponse.allHeaderFields as? [String: String],
           let responseURL = httpResponse.url {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: responseURL)
            HTTPCookieStorage.shared.setCookies(cookies, for: responseURL, mainDocumentURL: nil)
        }
        
        // Construction de l'objet User à partir de la réponse
        let user = User(nom: result.user.nom, prenom: result.user.prenom, email: result.user.email, role: result.user.role)
        return user
    }
}
