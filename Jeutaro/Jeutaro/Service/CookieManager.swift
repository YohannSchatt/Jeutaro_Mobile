//
//  CookiesManager.swift
//  Jeutaro
//
//  Created by etud on 21/03/2025.
//

import Foundation

import Foundation

class CookieManager {
    static let shared = CookieManager()

    // Crée un URLSession avec un HTTPCookieStorage partagé
    var session: URLSession

    private init() {
        // Utilise un cookie storage par défaut
        let cookieStorage = HTTPCookieStorage.shared
        let configuration = URLSessionConfiguration.default
        configuration.httpCookieStorage = cookieStorage

        // Crée un URLSession avec cette configuration
        session = URLSession(configuration: configuration)
    }
    
    // Utilisation de la session pour faire une requête GET
    func fetchData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = session.dataTask(with: url, completionHandler: completion)
        task.resume()
    }

    // Utilisation de la session pour faire une requête POST
    func postData(url: URL, body: Data, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        
        let task = session.dataTask(with: request, completionHandler: completion)
        task.resume()
    }
    
    // Pour voir les cookies stockés dans le stockage partagé
    func printCookies() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                print("Cookie name: \(cookie.name), value: \(cookie.value)")
            }
        }
    }
}
