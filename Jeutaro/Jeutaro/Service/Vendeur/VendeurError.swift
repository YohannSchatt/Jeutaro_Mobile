//
//  VendeurError.swift
//  Jeutaro
//
//  Created by etud on 21/03/2025.
//

import Foundation

enum VendeurError : Error {
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
