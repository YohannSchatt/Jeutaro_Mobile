//
//  VendeurService.swift
//  Jeutaro
//
//  Created by etud on 20/03/2025.
//

import Foundation

struct VendeurService {
    
    let apiUrl: String
    
    let session = CookieManager.shared.session
    
    init() {
        guard let apiUrl = ProcessInfo.processInfo.environment["API_URL"] else {
            fatalError("API_URL not set in Config file")
        }
        self.apiUrl = apiUrl + "/vendeur"
    }
    
    func getListVendeur(prenom : String?, nom : String?, email : String?, numero : String?) async throws -> [Vendeur] {
        let url = URL(string: "\(apiUrl)/getListVendeur")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let vendeurRequest = SearchVendeurDto(prenom: prenom, nom: nom, email: email, numero: numero)
        request.httpBody = try JSONEncoder().encode(vendeurRequest)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        
        let (resultDto, httpResponse, _) : ([GetVendeurDto], HTTPURLResponse, Data) = try await session.getJson(from: request)
        
        if httpResponse.statusCode == 201 {
            let vendeurs = resultDto.map { dto in
                Vendeur(
                    idVendeur: dto.idVendeur,
                    prenom: dto.prenom,
                    nom: dto.nom,
                    email: dto.email,
                    numero: dto.numero,
                    sommeTotale: Int(dto.sommeTotale)!,
                    sommeDue: Int(dto.sommeDue)!,
                    sommeRetire: Int(dto.sommeRetire)!
                )
            }
            return vendeurs
        }
        else if httpResponse.statusCode == 401 {
            throw VendeurError.Unauthorized
        }
        else if httpResponse.statusCode == 500  {
            throw VendeurError.ServerError
        }
        return []
    }
    
    func createVendeur(nom : String, prenom : String, email : String, numero : String) async throws -> Vendeur? {
        let url = URL(string: "\(apiUrl)/createVendeur")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let vendeurRequest = CreateVendeurDto(prenom: prenom, nom: nom, email: email, numero: numero)
        request.httpBody = try JSONEncoder().encode(vendeurRequest)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        
        let (resultDto, httpResponse, _) : (GetVendeurDto, HTTPURLResponse, Data) = try await session.getJson(from: request)
        
        if httpResponse.statusCode == 201 {
            return Vendeur(
                idVendeur: resultDto.idVendeur,
                prenom: resultDto.prenom,
                nom: resultDto.nom,
                email: resultDto.email,
                numero: resultDto.numero,
                sommeTotale: Int(resultDto.sommeTotale)!,
                sommeDue: Int(resultDto.sommeDue)!,
                sommeRetire: Int(resultDto.sommeRetire)!
            )
        }
        else if httpResponse.statusCode == 401 {
            throw VendeurError.Unauthorized
        }
        else if httpResponse.statusCode == 500  {
            throw VendeurError.ServerError
        }
        return nil
    }
    
    func updateVendeur(idVendeur : Int, nom : String?, prenom : String?, email : String?, numero : String?) async throws -> Vendeur? {
        let url = URL(string: "\(apiUrl)/updateVendeur")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        let vendeurRequest = UpdateVendeurDto(idVendeur : idVendeur, prenom: prenom, nom: nom, numero: numero, email: email)
        request.httpBody = try JSONEncoder().encode(vendeurRequest)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        
        let (resultDto, httpResponse, _) : (GetVendeurDto, HTTPURLResponse, Data) = try await session.getJson(from: request)
        
        if httpResponse.statusCode == 201 {
            return Vendeur(
                idVendeur: resultDto.idVendeur,
                prenom: resultDto.prenom,
                nom: resultDto.nom,
                email: resultDto.email,
                numero: resultDto.numero,
                sommeTotale: Int(resultDto.sommeTotale)!,
                sommeDue: Int(resultDto.sommeDue)!,
                sommeRetire: Int(resultDto.sommeRetire)!
            )
        }
        else if httpResponse.statusCode == 401 {
            throw VendeurError.Unauthorized
        }
        else if httpResponse.statusCode == 500  {
            throw VendeurError.ServerError
        }
        return nil
    }
}
