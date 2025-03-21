//
//  UpdateVendeurDto.swift
//  Jeutaro
//
//  Created by etud on 21/03/2025.
//

import Foundation

struct UpdateVendeurDto : Codable {
    let idVendeur : Int
    let prenom : String?
    let nom : String?
    let numero : String?
    let email : String?
    
}
