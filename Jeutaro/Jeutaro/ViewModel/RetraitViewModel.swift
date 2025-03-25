//
//  RetraitViewModel.swift
//  Jeutaro
//
//  Created by etud on 23/03/2025.
//

import Foundation

class RetraitViewModel : ObservableObject {
    
    private let jeuUnitaireService : JeuUnitaireService = JeuUnitaireService()
    
    private let vendeurService : VendeurService = VendeurService()
    
    @Published var listJeuUnitaire : [JeuUnitaire] = []
    
    @Published var numeroArticle: String = ""
    @Published var email: String = ""
    
    init() {}
    
    func getJeuVendeur(vendeur : Vendeur) async {
        do {
            let result : [InfoJeuUnitaireDisponibleDto] = try await jeuUnitaireService.jeuxDisponibleByVendeur(vendeurId : vendeur.idVendeur)
            
            DispatchQueue.main.async {
                self.listJeuUnitaire = result.map({ elt in
                    JeuUnitaire(idJeuUnitaire: elt.idJeuUnitaire,
                                prix: elt.prix,
                                statut: .DISPONIBLE,
                                dateAchat: nil,
                                etat: elt.etat,
                                jeu: Jeux(idJeu: -1, nom: elt.nom, editeur: elt.editeur, description: ""))
                })
            }
        } catch let err as JeuUnitaireError {
            print(err)
        } catch {
            print(error)
        }
    }
    
    func retraitJeuArgent(vendeur : Vendeur, listJeu : [Int], getArgent : Bool) async -> Bool {
        
        var result : Bool = false
        let dto = EnregistrerRetraitJeuArgentDto(idVendeur: vendeur.idVendeur, idJeu: listJeu, argent: getArgent)
        
        do {
            
            result = try await vendeurService.retraitJeuArgent(enregistrerRetraitJeuArgentDto: dto)
            
        } catch let err as JeuUnitaireError {
            print(err)
        } catch {
            print(error)
        }
        return result
    }
    
}
