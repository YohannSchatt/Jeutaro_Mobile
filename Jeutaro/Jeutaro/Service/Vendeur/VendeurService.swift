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
                    sommeTotale: Float(dto.sommeTotale) ?? 0.0,
                    sommeDue: Float(dto.sommeDue) ?? 0.0,
                    sommeRetire: Float(dto.sommeRetire) ?? 0.0
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
                sommeTotale: Float(resultDto.sommeTotale) ?? 0.0,
                sommeDue: Float(resultDto.sommeDue) ?? 0.0,
                sommeRetire: Float(resultDto.sommeRetire) ?? 0.0
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
                sommeTotale: Float(resultDto.sommeTotale) ?? 0.0,
                sommeDue: Float(resultDto.sommeDue) ?? 0.0,
                sommeRetire: Float(resultDto.sommeRetire) ?? 0.0
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
    
    func retraitJeuArgent(enregistrerRetraitJeuArgentDto : EnregistrerRetraitJeuArgentDto) async throws -> Bool {
        let url = URL(string: "\(apiUrl)/enregistrerRetraitJeuArgent")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(enregistrerRetraitJeuArgentDto)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpShouldHandleCookies = true
        
        let (_, httpResponse, _) : (Data, HTTPURLResponse, Data) = try await session.getJson(from: request)
            
        if httpResponse.statusCode == 200 {
            return true
        }
        else if httpResponse.statusCode == 401 {
            throw JeuUnitaireError.Unauthorized
        }
        else if httpResponse.statusCode == 500  {
            throw JeuUnitaireError.ServerError
        }
        return false
    }
}
