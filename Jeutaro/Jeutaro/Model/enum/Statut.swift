//
//  Statut.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import Foundation

enum Statut : String, CaseIterable, Identifiable, Codable {
    case DEPOSE = "DEPOSE"
    case DISPONIBLE = "DISPONIBLE"
    case VENDU = "VENDU"
    case RECUPERER = "RECUPERER"

    var id: String { self.rawValue }
}
