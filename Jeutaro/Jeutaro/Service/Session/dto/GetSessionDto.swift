//
//  GetSessionDto.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 23/03/2025.
//

import Foundation

struct GetSessionDto: Decodable {
    let idSession: Int
    let titre: String
    let lieu: String
    let dateDebut: String
    let dateFin: String
    let description: String
    let comission: String
    
    enum CodingKeys: String, CodingKey {
        case idSession
        case titre
        case lieu
        case dateDebut
        case dateFin
        case description
        case comission
    }
}