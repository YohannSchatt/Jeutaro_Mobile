//
//  CatalogueItem.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 25/03/2025.
//
import Foundation
import UIKit

struct CatalogueItem: Identifiable {
    let id: Int
    let nom: String
    let description: String
    let editeur: String
    let prix: Float
    let prenomVendeur: String
    let nomVendeur: String
    let image: Data?
    let etat: String
    
    init(from dto: CatalogueItemDto) {
        self.id = dto.id
        self.nom = dto.nom
        self.description = dto.description
        self.editeur = dto.editeur
        self.prix = dto.prix
        self.prenomVendeur = dto.prenomVendeur
        self.nomVendeur = dto.nomVendeur
        self.etat = dto.etat
        
        // Convertir l'image base64 en Data
        if dto.image != "notfound" {
            self.image = Data(base64Encoded: dto.image)
        } else {
            self.image = nil
        }
    }
}
