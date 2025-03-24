//
//  UpdatePasswordDto.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import Foundation

struct UpdatePasswordDto : Codable {
    let oldMdp : String
    let newMdp : String
}
