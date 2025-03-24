//
//  CatalogueService.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 25/03/2025.
//

import Foundation

struct CatalogueService {
    let apiUrl: String
    let session = CookieManager.shared.session
    
    init() {
        guard let apiUrl = ProcessInfo.processInfo.environment["API_URL"] else {
            fatalError("API_URL not set in Config file")
        }
        self.apiUrl = apiUrl + "/jeu"
    }
    
    func getCatalogue(page: Int) async throws -> CatalogueResponseDto {
        let url = URL(string: "\(apiUrl)/catalogue")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        // Créer le DTO de requête exactement comme le backend l'attend
        let catalogueRequest: [String: Any] = [
            "page": page,
            "nom": nil as String?,
            "editeur": nil as String?,
            "prixMin": nil as Double?,
            "prixMax": nil as Double?
        ]
        
        // Convertir en JSON en filtrant les valeurs nil
        let jsonData = try JSONSerialization.data(
            withJSONObject: catalogueRequest.compactMapValues { $0 },
            options: []
        )
        
        // Configurer la requête
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        
        // Pour debug - afficher le JSON envoyé
        if let requestStr = String(data: jsonData, encoding: .utf8) {
            print("Catalogue request: \(requestStr)")
        }
        
        do {
            // Utiliser URLSession directement pour plus de contrôle
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Log de la réponse brute
            print("Response data: \(String(data: data, encoding: .utf8) ?? "no data")")
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw CatalogueError.NetworkError(NSError(domain: "HTTP", code: 0))
            }
            
            print("HTTP Status: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(CatalogueResponseDto.self, from: data)
                    return result
                } catch {
                    print("Decoding error: \(error)")
                    throw CatalogueError.InvalidData
                }
            } else if httpResponse.statusCode == 401 {
                throw CatalogueError.Unauthorized
            } else {
                throw CatalogueError.ServerError
            }
        } catch is DecodingError {
            throw CatalogueError.InvalidData
        } catch let error as CatalogueError {
            throw error
        } catch {
            print("Network error: \(error)")
            throw CatalogueError.NetworkError(error)
        }
    }
}
