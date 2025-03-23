//
//  VendeurViewModel.swift
//  Jeutaro
//
//  Created by etud on 20/03/2025.
//

import Foundation

class VendeurViewModel : ObservableObject {
    
    @Published var vendeur : [Vendeur] = []
    
    @Published var error : VendeurError? = nil
    
    @Published var message : String = ""
    
    @Published var idVendeurSelected : Int = -1
    
    let vendeurService : VendeurService = VendeurService()
    
    init() {
        Task {
            await self.searchVendeur(prenom: "", nom: "", email: "", numero: "")
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
    
    func searchVendeur(prenom: String, nom: String, email: String, numero: String) async {
        let emailToSend = isValidEmail(email) ? email : nil
        
        DispatchQueue.main.async {
            self.idVendeurSelected = -1
        }
        
        do {
            let vendeurs = try await vendeurService.getListVendeur(prenom: prenom, nom: nom, email: emailToSend, numero: numero)
            DispatchQueue.main.async {
                self.vendeur = vendeurs
                self.error = nil
            }
            
        } catch let err as VendeurError {
            DispatchQueue.main.async {
                self.error = err
            }
            print(err)
        } catch {
            print(error)
        }
    }

    func setIdVendeurSelected(index : Int) -> Void {
        DispatchQueue.main.async {
            self.message = ""
        }
        if (index != self.idVendeurSelected) {
            self.idVendeurSelected = index
        }
        else {
            self.idVendeurSelected = -1
        }
    }
    
    func createOrUpdateVendeur(nom : String?, prenom : String?, email : String?, numero : String?) async {
        
        let selectedId : Int = self.idVendeurSelected
        
        var vendeurInfo : Vendeur?;
        
        do {
            if (self.idVendeurSelected == -1) {
                guard let nom = nom?.trimmingCharacters(in: .whitespacesAndNewlines), !nom.isEmpty,
                      let prenom = prenom?.trimmingCharacters(in: .whitespacesAndNewlines), !prenom.isEmpty,
                      let email = email?.trimmingCharacters(in: .whitespacesAndNewlines), !email.isEmpty,
                      let numero = numero?.trimmingCharacters(in: .whitespacesAndNewlines), !numero.isEmpty else {
                    DispatchQueue.main.async {
                        self.message = "Tout les champs doit etre remplis"
                    }
                    return
                }
                vendeurInfo = try await vendeurService.createVendeur(nom: nom, prenom: prenom, email: email, numero: numero)
            } else {
                vendeurInfo = try await vendeurService.updateVendeur(idVendeur: self.idVendeurSelected, nom: nom, prenom: prenom, email: email, numero: numero)
            }
            
            if (vendeurInfo != nil) {
                if (selectedId != -1) {
                    self.vendeur[selectedId] = vendeurInfo!
                }
                else {
                    self.vendeur.append(vendeurInfo!)
                }
            }
            
        } catch let err as VendeurError {
            DispatchQueue.main.async {
                self.error = err
            }
            print(err)
        } catch {
            print(error)
        }
    }
}
