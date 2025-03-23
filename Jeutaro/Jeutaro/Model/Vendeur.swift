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
    
    var sommeTotale : Float = 0.0
    
    var sommeDue : Float = 0.0
    
    var sommeRetire : Float = 0.0

    init(idVendeur: Int, prenom: String, nom: String, email: String, numero: String) {
        self.idVendeur = idVendeur
        self.prenom = prenom
        self.nom = nom
        self.email = email
        self.numero = numero
    }
    
    init(idVendeur: Int, prenom: String, nom: String, email: String, numero: String, sommeTotale: Float, sommeDue: Float, sommeRetire: Float) {
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

    func getSommeTotale() -> Float {
        return self.sommeTotale
    }

    func getSommeDue() -> Float {
        return self.sommeDue
    }

    func getSommeRetire() -> Float {
        return self.sommeRetire
    }

    mutating func setSommeTotale(sommeTotale: Float) {
        self.sommeTotale = sommeTotale
    }

    mutating func setSommeDue(sommeDue: Float) {
        self.sommeDue = sommeDue
    }

    mutating func setSommeRetire(sommeRetire: Float) {
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
