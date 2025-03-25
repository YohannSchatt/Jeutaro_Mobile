//
//  CookiesManager.swift
//  Jeutaro
//
//  Created by etud on 21/03/2025.
//

import Foundation

import Foundation

// Gestionnaire de cookies partagé
class CookieManager {
    static let shared = CookieManager()

    // Crée un URLSession avec un HTTPCookieStorage partagé
    var session: URLSession

    private init() {
        // Utilise un cookie storage par défaut
        let cookieStorage = HTTPCookieStorage.shared
        let configuration = URLSessionConfiguration.default
        configuration.httpCookieStorage = cookieStorage

        session = URLSession(configuration: configuration)
    }
    
    func printCookies() {
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                print("Cookie name: \(cookie.name), value: \(cookie.value)")
            }
        }
    }
}
