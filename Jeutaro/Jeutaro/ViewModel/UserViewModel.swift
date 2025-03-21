//
//  ConnexionViewModel.swift
//  Jeutaro
//
//  Created by etud on 17/03/2025.
//

import Foundation
import SwiftUI

@MainActor
class UserViewModel : ObservableObject {
    
    let routeur : Routeur
    
    var user : User? = nil
    
    @Published var message : String = ""
    
    public init(routeur : Routeur) {
        self.routeur = routeur
    }

    func login(email: String, password: String) async {
        self.message = ""
        do {
            self.user = try await AuthService.shared.login(email: email, password: password)
            message = "Connexion réussie"
            routeur.setRoute(route: AnyView(ConnexionSucessView()))
        } catch {
            message = "Échec de connexion"
        }
    }
}
