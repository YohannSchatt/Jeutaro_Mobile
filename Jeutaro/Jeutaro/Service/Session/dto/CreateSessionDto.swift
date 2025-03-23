//
//  CreateSessionDto.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 23/03/2025.
//

import Foundation

struct CreateSessionDto : Codable {
    let titre : String ;
    
    let lieu: String;

    let dateDebut: String ;

    let dateFin: String ;

    let description: String ;

    let comission: Double ;

}
