//
//  Vendeur.swift
//  Jeutaro
//
//  Created by etud on 20/03/2025.
//

import Foundation

struct Vendeur {
    
    let idVendeur : Int
    
    var prenom : String
    
    var nom : String
    
    var email : String
    
    var numero : String
    
    var sommeTotale : Int = 0
    
    var sommeDue : Int = 0
    
    var sommeRetire : Int = 0

    init(idVendeur: Int, prenom: String, nom: String, email: String, numero: String) {
        self.idVendeur = idVendeur
        self.prenom = prenom
        self.nom = nom
        self.email = email
        self.numero = numero
    }
    
    init(idVendeur: Int, prenom: String, nom: String, email: String, numero: String, sommeTotale: Int, sommeDue: Int, sommeRetire: Int) {
        self.idVendeur = idVendeur
        self.prenom = prenom
        self.nom = nom
        self.email = email
        self.numero = numero
        self.sommeTotale = sommeTotale
        self.sommeDue = sommeDue
        self.sommeRetire = sommeRetire
    }

    func getIdVendeur() -> Int {
        return self.idVendeur
    }

    func getPrenom() -> String {
        return self.prenom
    }

    func getNom() -> String {
        return self.nom
    }

    func getEmail() -> String {
        return self.email
    }

    func getNumero() -> String {
        return self.numero
    }

    func getSommeTotale() -> Int {
        return self.sommeTotale
    }

    func getSommeDue() -> Int {
        return self.sommeDue
    }

    func getSommeRetire() -> Int {
        return self.sommeRetire
    }

    mutating func setSommeTotale(sommeTotale: Int) {
        self.sommeTotale = sommeTotale
    }

    mutating func setSommeDue(sommeDue: Int) {
        self.sommeDue = sommeDue
    }

    mutating func setSommeRetire(sommeRetire: Int) {
        self.sommeRetire = sommeRetire
    }

    mutating func setNom(nom: String) {
        self.nom = nom
    }
    
    mutating func setPrenom(prenom: String) {
        self.prenom = prenom
    }

    mutating func setEmail(email: String) {
        self.email = email
    }

    mutating func setNumero(numero: String) {
        self.numero = numero
    }
}
