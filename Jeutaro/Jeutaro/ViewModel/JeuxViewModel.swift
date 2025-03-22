//
//  JeuxViewModel.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import Foundation

class JeuxViewModel : ObservableObject {
    
    let jeuxService : JeuxService = JeuxService()
    
    let jeuUnitaireService : JeuUnitaireService = JeuUnitaireService()
    
    let vendeurService : VendeurService = VendeurService()
    
    @Published var jeuxDB : [Jeux] = []
    
    @Published var vendeurDB : [Vendeur] = []
    
    @Published var indexJeuxSelected : Int = -1
    
    @Published var indexVendeurSelected : Int = -1
    
    @Published var error : String? = ""
    
    init() {
        Task {
            await self.getVendeurDB()
            await self.getJeuxDB()
        }
    }
    
    func getJeuxDB() async {
        
        do{
            let resultat : [InfoJeuDBDto] = try await jeuxService.getJeux()
            
            self.jeuxDB = resultat.map { elt in
                Jeux(idJeu: elt.idJeu,
                     nom: elt.nom,
                     editeur: elt.editeur,
                     description: elt.description)
            }
        } catch let err as JeuxError {
            print(err)
        } catch {
            print(error)
        }
    }
    
    func getVendeurDB() async {
        DispatchQueue.main.async {
            self.indexVendeurSelected = -1
        }
        
        do {
            let vendeurs = try await vendeurService.getListVendeur(prenom: nil, nom: nil, email: nil, numero: nil)
            DispatchQueue.main.async {
                self.vendeurDB = vendeurs
                print("vendeur : ", self.vendeurDB)
                self.error = nil
            }
        } catch let err as VendeurError {
            print(err)
        } catch {
            print(error)
        }
    }
    
    func createJeuUnitaire(idJeu : Int, idVendeur : Int, etat : Etat, prix : Float) async -> Bool {
        do {
            let createJeuUnitaireDto : CreateJeuUnitaireDto = CreateJeuUnitaireDto(prix: prix, statut: .DISPONIBLE, etat: etat, idVendeur: idVendeur, idJeu: idJeu)
            
            return try await self.jeuUnitaireService.createJeuUnitaire(createJeuUnitaireDto: createJeuUnitaireDto)
        } catch let err as VendeurError {
            print(err)
        } catch {
            print(error)
        }
        return false
    }
    
}
