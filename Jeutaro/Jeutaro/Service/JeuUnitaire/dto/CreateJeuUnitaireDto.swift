//
//  CreateJeuUnitaireDto.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import Foundation

struct CreateJeuUnitaireDto : Codable {
    
    let prix : Float
    let statut : Statut
    let etat : Etat
    let idVendeur : Int
    let idJeu : Int
}
