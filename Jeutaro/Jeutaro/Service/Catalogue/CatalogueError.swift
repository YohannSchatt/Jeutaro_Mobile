//
//  CatalogueError.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 25/03/2025.
//

import Foundation

enum CatalogueError: Error {
    case Unauthorized
    case ServerError
    case InvalidData
    case NetworkError(Error)
    
    var description: String {
        switch self {
        case .Unauthorized:
            return "Non autorisé, veuillez vous reconnecter"
        case .ServerError:
            return "Erreur serveur"
        case .InvalidData:
            return "Données invalides"
        case .NetworkError(let error):
            return "Erreur réseau: \(error.localizedDescription)"
        }
    }
}
