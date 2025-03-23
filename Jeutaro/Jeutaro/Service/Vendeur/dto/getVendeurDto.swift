//
//  getVendeurDto.swift
//  Jeutaro
//
//  Created by etud on 21/03/2025.
//

import Foundation

struct GetVendeurDto : Codable {
    let idVendeur : Int
    
    var prenom : String
    
    var nom : String
    
    var email : String
    
    var numero : String
    
    var sommeTotale : String

    var sommeDue : String
    
    var sommeRetire : String
}
