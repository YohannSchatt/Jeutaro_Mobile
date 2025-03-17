//
//  AuthService.swift
//  Jeutaro
//
//  Created by etud on 17/03/2025.
//

import Foundation

extension URLSession {
    func getJson<T: Decodable>(from request: URLRequest) async throws -> (T, HTTPURLResponse, Data) {
        let (data, response) = try await data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: data)
        return (decoded, httpResponse, data)
    }
}

struct AuthService {
    
    static let shared = AuthService()
    
    let apiUrl: String
    
    private var session: URLSession

    init() {
        guard let apiUrl = ProcessInfo.processInfo.environment["API_URL"] else {
            fatalError("API_URL not set in Config file")
        }
        self.apiUrl = apiUrl + "/auth"

        let config = URLSessionConfiguration.default
        config.httpCookieStorage = HTTPCookieStorage.shared
        config.httpCookieAcceptPolicy = .always
        session = URLSession(configuration: config)
    }

    func login(email: String, password: String) async throws -> User {
        let url = URL(string: "\(apiUrl)/login")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let authRequest = SignIn(email: email, password: password)
        request.httpBody = try JSONEncoder().encode(authRequest)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        
        let (result, httpResponse, _) : (UserLogin, HTTPURLResponse, Data) = try await session.getJson(from: request)
        
        if httpResponse.statusCode != 200 {
            throw AuthError.Unauthorized
        }
        
        if let headers = httpResponse.allHeaderFields as? [String: String],
           let responseURL = httpResponse.url {
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: headers, for: responseURL)
            HTTPCookieStorage.shared.setCookies(cookies, for: responseURL, mainDocumentURL: nil)
        }
        
        // Construction de l'objet User à partir de la réponse
        let user = User(nom: result.nom, prenom: result.prenom, email: result.email, role: result.Role)
        return user
    }

}
