//
//  CatalogueRequestDto.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 25/03/2025.
//

import Foundation

struct CatalogueRequestDto: Codable {
    let page: Int
    let nom: String?
    let editeur: String?
    let prixMin: Double?
    let prixMax: Double?
    
    init(page: Int, nom: String? = nil, editeur: String? = nil, prixMin: Double? = nil, prixMax: Double? = nil) {
        self.page = page
        self.nom = nom
        self.editeur = editeur
        self.prixMin = prixMin
        self.prixMax = prixMax
    }
    
    // Cette fonction encoder contourne le problème des valeurs nil
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(page, forKey: .page)
        
        // Encode optionals only if they are not nil
        if let nom = nom {
            try container.encode(nom, forKey: .nom)
        }
        
        if let editeur = editeur {
            try container.encode(editeur, forKey: .editeur)
        }
        
        if let prixMin = prixMin {
            try container.encode(prixMin, forKey: .prixMin)
        }
        
        if let prixMax = prixMax {
            try container.encode(prixMax, forKey: .prixMax)
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case page
        case nom
        case editeur
        case prixMin
        case prixMax
    }
}
