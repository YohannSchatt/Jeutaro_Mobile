//
//  JeuUnitaire.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import Foundation

struct JeuUnitaire {
    
    let idJeuUnitaire : Int
    
    var prix : Float
    
    var statut : Statut
    
    var dateAchat : Date?
    
    var etat : Etat
    
    let idVendeur : Int?
    
    let idJeu : Int?
    
    let jeu : Jeux?

    init(idJeuUnitaire : Int, prix : Float, statut : Statut, dateAchat : Date?, etat : Etat, idVendeur : Int, idJeu : Int) {
        self.idJeuUnitaire = idJeuUnitaire
        self.prix = prix
        self.statut = statut
        self.dateAchat = dateAchat
        self.etat = etat
        self.idVendeur = idVendeur
        self.idJeu = idJeu
        self.jeu = nil
    }
    
    init(idJeuUnitaire : Int, prix : Float, statut : Statut, dateAchat : Date?, etat : Etat, jeu : Jeux) {
        self.idJeuUnitaire = idJeuUnitaire
        self.prix = prix
        self.statut = statut
        self.dateAchat = dateAchat
        self.etat = etat
        self.idVendeur = nil
        self.idJeu = nil
        self.jeu = jeu
    }

    func getIdJeuUnitaire() -> Int {
        return self.idJeuUnitaire
    }

    func getPrix() -> Float {
        return self.prix
    }

    func getStatut() -> Statut {
        return self.statut
    }

    func getDateAchat() -> Date? {
        return self.dateAchat
    }

    func getEtat() -> Etat {
        return self.etat
    }

    func getIdVendeur() -> Int? {
        return self.idVendeur
    }

    func getIdJeu() -> Int? {
        return self.idJeu
    }

    mutating func setPrix(prix : Float) {
        self.prix = prix
    }

    mutating func setStatut(statut : Statut) {
        self.statut = statut
    }

    mutating func setDateAchat(dateAchat : Date?) {
        self.dateAchat = dateAchat
    }

    mutating func setEtat(etat : Etat) {
        self.etat = etat
    }


}
