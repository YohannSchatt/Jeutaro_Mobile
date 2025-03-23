//
//  SessionError.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 23/03/2025.
//

import Foundation

enum SessionError : Error {
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
