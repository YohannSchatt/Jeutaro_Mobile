//
//  Etat.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import Foundation

enum Etat : String, CaseIterable, Identifiable, Codable {
    case NEUF = "NEUF"
    case BONNE_ETAT = "BONNE_ETAT"
    case PIECE_MANQUANTES = "PIECE_MANQUANTES"

    var id: String { self.rawValue }
}
