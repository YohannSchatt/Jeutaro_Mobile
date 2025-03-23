//
//  JeuxUnitaireError.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import Foundation

enum JeuUnitaireError : Error {
    case ServerError
    case Unauthorized
    case EncodingError
    
    var description : String {
        switch self {
        case .ServerError:
            return "Erreur du serveur"
        case .Unauthorized:
            return "Veuillez vous connecter"
        case .EncodingError:
            return"Error d'encoding"
        }
    }
}
