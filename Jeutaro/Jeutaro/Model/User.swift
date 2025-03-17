//
//  User.swift
//  Jeutaro
//
//  Created by etud on 17/03/2025.
//

import Foundation

enum Role : String, Codable {
    case GESTIONNAIRE
    case ADMIN
}

struct User {
    
    private var prenom, nom, email : String;
    private let role : Role;
    
    public init(nom : String, prenom : String, email : String, role : Role) {
        self.prenom = prenom;
        self.nom = nom;
        self.email = email;
        self.role = role;
    }

    public func getPrenom() -> String {
        return self.prenom;
    }

    public func getNom() -> String {
        return self.nom;
    }

    public func getEmail() -> String {
        return self.email;
    }

    public func getRole() -> Role {
        return self.role;
    }

    public mutating func setPrenom(prenom : String) {
        self.prenom = prenom;
    }

    public mutating func setNom(nom : String) {
        self.nom = nom;
    }

    public mutating func setEmail(email : String) {
        self.email = email;
    }
}
