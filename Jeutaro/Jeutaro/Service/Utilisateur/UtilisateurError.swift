//
//  UtilisateurError.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import Foundation

enum UtilisateurError : Error {
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
