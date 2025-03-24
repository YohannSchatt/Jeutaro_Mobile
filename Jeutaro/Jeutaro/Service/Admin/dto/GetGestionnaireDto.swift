//
//  getGestionnaireDto.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import Foundation

struct GetGestionnaireDto : Codable {
    let idUtilisateur : Int
    let prenom : String
    let nom : String
    let email : String
    let role : Role
}
