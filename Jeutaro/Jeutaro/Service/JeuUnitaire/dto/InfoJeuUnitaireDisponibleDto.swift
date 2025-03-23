//
//  InfoJeuUnitaireDisponibleDto.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import Foundation

struct InfoJeuUnitaireDisponibleDto : Codable {
    let idJeuUnitaire : Int
    let prix : Float
    let nom : String
    let editeur : String
    let etat : Etat
}
