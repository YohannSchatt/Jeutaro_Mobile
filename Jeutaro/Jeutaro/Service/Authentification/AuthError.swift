//
//  AuthError.swift
//  Jeutaro
//
//  Created by etud on 17/03/2025.
//

import Foundation

enum AuthError : Error {
    case InvalidCredentials
    case Unauthorized
    
    var description : String {
        switch self {
        case .InvalidCredentials:
            return "remplissez correctement les cases"
        case .Unauthorized:
            return "Mot de passe ou email invalide"
        }
    }
}
