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
        var catalogueRequest: [String: Any] = ["page": page]
        
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
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("✅ Réponse reçue: \(data.count) bytes")
            
            // Afficher uniquement le début de la réponse pour éviter de surcharger la console
            if let responseStr = String(data: data, encoding: .utf8)?.prefix(200) {
                print("📝 Début de la réponse: \(responseStr)...")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw CatalogueError.NetworkError(NSError(domain: "HTTP", code: 0))
            }
            
            print("HTTP Status: \(httpResponse.statusCode)")
            
            // Dans CatalogueService.swift
            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {  // Ajouter 201 ici
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
