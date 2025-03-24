//
//  CatalogueResponseDto.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 25/03/2025.
//

import Foundation

struct CatalogueResponseDto: Decodable {
    let totalPages: Int
    let nbJeux: Int
    let items: [CatalogueItemDto]
}

struct CatalogueItemDto: Decodable {
    let id: Int
    let nom: String
    let description: String
    let editeur: String
    let prix: Float
    let prenomVendeur: String
    let nomVendeur: String
    let image: String  // Contient soit l'image en base64, soit "notfound"
    let etat: String
}
