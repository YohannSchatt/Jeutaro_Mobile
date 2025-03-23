//
//  EnregistrerRetraitJeuArgentDto.swift
//  Jeutaro
//
//  Created by etud on 23/03/2025.
//

import Foundation

struct EnregistrerRetraitJeuArgentDto : Codable {
    let idVendeur : Int
    let idJeu : [Int]
    let argent : Bool
}
