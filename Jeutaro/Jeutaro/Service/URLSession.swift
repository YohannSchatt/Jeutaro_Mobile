//
//  URLSession.swift
//  Jeutaro
//
//  Created by etud on 21/03/2025.
//

import Foundation

extension URLSession {
    func getJson<T: Decodable>(from request: URLRequest) async throws -> (T, HTTPURLResponse, Data) {
        let (data, response) = try await data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("JSON reçu : \(jsonString)")
        } else {
            print("Impossible de convertir les données en chaîne")
        }

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: data)
        return (decoded, httpResponse, data)
    }
}
