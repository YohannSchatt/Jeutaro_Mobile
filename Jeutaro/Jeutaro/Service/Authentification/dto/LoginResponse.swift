//
//  LoginResponse.swift
//  Jeutaro
//
//  Created by etud on 20/03/2025.
//

import Foundation

struct LoginResponse: Codable {
    let statusCode: Int
    let message: String
    let user: UserLogin
}
