//
//  Jeux.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import Foundation

struct Jeux {
    
    let idJeu : Int
    
    var nom : String
    
    var editeur : String
    
    var description : String
    
    init(idJeu : Int, nom : String, editeur : String, description : String) {
        self.idJeu = idJeu
        self.nom = nom
        self.editeur = editeur
        self.description = description
    }

    func getIdJeu() -> Int {
        return self.idJeu
    }

    func getNom() -> String {
        return self.nom
    }

    func getEditeur() -> String {
        return self.editeur
    }

    func getDescription() -> String {
        return self.description
    }

    mutating func setNom(nom : String) {
        self.nom = nom
    }

    mutating func setEditeur(editeur : String) {
        self.editeur = editeur
    }

    mutating func setDescription(description : String) {
        self.description = description
    }
}
