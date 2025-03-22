//
//  JeuxError.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import Foundation

enum JeuxError : Error {
    case ServerError
    case Unauthorized
    
    var description : String {
        switch self {
        case .ServerError:
            return "Erreur du serveur"
        case .Unauthorized:
            return "Veuillez vous connecter"
        }
    }
}
