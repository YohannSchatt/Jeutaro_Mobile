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
        
        // Si le type T est Void, on ne tente pas de décoder
        if T.self == Data.self {
            // Si tu n'as pas besoin de décoder, tu retournes simplement le tuple sans décodage
            return (data as! T, httpResponse, data) // Forcer la conversion car T est Void
        }
        
        let decoder = JSONDecoder()
        let decoded = try decoder.decode(T.self, from: data)
        return (decoded, httpResponse, data)
    }
}
