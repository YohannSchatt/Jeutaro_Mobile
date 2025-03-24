//
//  AdminError.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import Foundation

enum AdminError : Error {
    case ServerError
    case Unauthorized
    
    var description : String {
        switch self {
        case .ServerError:
            return "Erreur du serveur"
        case .Unauthorized:
            return "Vous n'êtes pas administrateur"
        }
    }
}
