//
//  JeuUnitaireViewModel.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import Foundation

class JeuUnitaireViewModel : ObservableObject {
    
    let jeuUnitaireService : JeuUnitaireService = JeuUnitaireService()
    
    @Published var listJeuUnitaire : [JeuUnitaire] = []
    
    init() {
        Task {
            await self.getJeuxUnitaireDisponible()
        }
    }
    
    //enregistre un achat
    func enregistrerAchat(listIdJeu : [Int]) async -> Bool {
        var result : Bool = false
        do {
            result = try await self.jeuUnitaireService.enregistrerAchat(enregistrerAchatDto: EnregistrerAchatDto(idsJeuUnitaire: listIdJeu))
        } catch let err as JeuUnitaireError {
            print(err)
        } catch {
            print(error)
        }
        return result
    }
    
    //récupère la liste des jeux unitaires disponibles
    func getJeuxUnitaireDisponible() async {
        do {
            
            let result = try await jeuUnitaireService.getJeuUnitaireDisponible()
            
            self.listJeuUnitaire = result.map({ elt in
                JeuUnitaire(idJeuUnitaire: elt.idJeuUnitaire,
                            prix: elt.prix,
                            statut: .DISPONIBLE,
                            dateAchat: nil,
                            etat: elt.etat,
                            jeu: Jeux(idJeu: -1, nom: elt.nom, editeur: elt.editeur, description: ""))
            })
            
        } catch let err as JeuUnitaireError {
            print(err)
        } catch {
            print(error)
        }
    }
    
}
