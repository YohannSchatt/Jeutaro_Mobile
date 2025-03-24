//
//  gestionnaireViewModel.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import Foundation

class GestionnaireViewModel : ObservableObject {
    
    @Published private var listGestionnaire : [User] = []
    
    @Published var listfilterGestionnaire : [User] = []
    
    private let adminService : AdminService = AdminService()
    
    init() {}
    
    func getGestionnaire() async {
        do {
            
            let result : [GetGestionnaireDto] = try await adminService.getGestionnaire()
            DispatchQueue.main.async {
                self.listGestionnaire = result.map({elt in
                                                   User(nom: elt.nom,
                                                        prenom: elt.prenom,
                                                        email: elt.email,
                                                        role: elt.role)
                }) 
            }
        } catch let err as JeuUnitaireError {
            print(err)
        } catch {
            print(error)
        }
    } 
    
    func createGestionnaire(nom : String, prenom : String, email : String) async -> Bool {
        
        var result : Bool = false
        
        do {
            
            let dto : CreateGestionnaireDto = CreateGestionnaireDto(nom: nom, prenom: prenom, email: email)
            result = try await adminService.createGestionnaire(createGestionnaireDto: dto)
            
            if(result) {
                let user = User(nom: nom, prenom: prenom, email: email, role: .GESTIONNAIRE)
                DispatchQueue.main.async {
                    self.listGestionnaire.append(user)
                    self.listfilterGestionnaire.append(user)
                }

            }
            
        } catch let err as JeuUnitaireError {
            print(err)
        } catch {
            print(error)
        }
        return result
    }
    
    func deleteGestionnaire(email : String) async -> Bool {
        
        var result : Bool = false
        
        do {
            
            let dto : DeleteGestionnaireDto = DeleteGestionnaireDto(email: email)
            result = try await adminService.deleteGestionnaire(deleteGestionnaireDto: dto)
            
            print(result)
            
            if(result) {
                DispatchQueue.main.async {
                    var found : Bool = false
                    var i = 0
                    while(!found && i < self.listGestionnaire.count) {
                        if (self.listGestionnaire[i].getEmail() == email){
                            found = true
                            self.listGestionnaire.remove(at: i)
                        }
                        i += 1
                    }
                    while(!found && i < self.listfilterGestionnaire.count) {
                        if (self.listfilterGestionnaire[i].getEmail() == email){
                            found = true
                            self.listfilterGestionnaire.remove(at: i)
                        }
                        i += 1
                    }
                }
            }
            
        } catch let err as JeuUnitaireError {
            print(err)
        } catch {
            print(error)
        }
        return result
    }
    
    func filterGestionnaire(nom: String, prenom: String, email: String) {
        self.listfilterGestionnaire = listGestionnaire.filter { user in
            (user.getNom().lowercased().contains(nom.lowercased()) || nom.isEmpty) &&
            (user.getPrenom().lowercased().contains(prenom.lowercased()) || prenom.isEmpty) &&
            (user.getEmail().lowercased().contains(email.lowercased()) || email.isEmpty)
        }
    }
}
