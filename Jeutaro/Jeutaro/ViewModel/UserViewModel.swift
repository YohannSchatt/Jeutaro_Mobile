//
//  ConnexionViewModel.swift
//  Jeutaro
//
//  Created by etud on 17/03/2025.
//

import Foundation
import SwiftUI

@MainActor
class UserViewModel: ObservableObject {
    
    private let routeur: Routeur
    private var user: User? = nil
    
    @Published var message: String = ""
    @Published var nom: String = ""
    @Published var prenom: String = ""
    @Published var email: String = ""
    
    let userService : UtilisateurService = UtilisateurService()
    
    public init(routeur: Routeur) {
        self.routeur = routeur
    }

    func login(email: String, password: String) async {
        self.message = ""
        do {
            self.user = try await AuthService.shared.login(email: email, password: password)
            
            if let user = self.user {
                self.nom = user.getNom()
                self.prenom = user.getPrenom()
                self.email = user.getEmail()
            }
            
            message = "Connexion réussie"
            routeur.setRoute(route: AnyView(ConnexionSucessView()))
        } catch {
            message = "Échec de connexion"
        }
    }

    func updateUser() {
        guard var currentUser = self.user else { return }
        currentUser.setNom(nom: self.nom)
        currentUser.setPrenom(prenom: self.prenom)
        currentUser.setEmail(email: self.email)
        self.user = currentUser
    }
    
    func modifPassword(oldPassword : String, newPassword : String, confirmation : String) async -> Bool {
        
        var result : Bool = false
        
        do {
            
            if (newPassword == confirmation) {
                let dto : UpdatePasswordDto = UpdatePasswordDto(oldMdp: oldPassword, newMdp: newPassword)
                result = try await userService.modifPassword(updatePasswordDto: dto)
            }
            
        } catch let err as JeuUnitaireError {
            print(err)
        } catch {
            print(error)
        }
        return result
    }
    
    func modifInfo() async -> Bool {
        
        var result : Bool = false
        
        do {
            
            let dto : UpdateUserDto = UpdateUserDto(prenom: self.prenom, nom: self.nom, email: self.email)
            result = try await userService.modifInfo(updateUserDto: dto)
            
            if(result) {
                self.updateUser()
            }
            
        } catch let err as JeuUnitaireError {
            print(err)
        } catch {
            print(error)
        }
        return result
    }
    
    func getUser() -> User? {
        return user
    }
    
    func setUser(user : User?) {
        self.user = user
    }
}
