//
//  JeutaroApp.swift
//  Jeutaro
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

@main
struct JeutaroApp: App {

    @StateObject var routeur : Routeur
    
    @StateObject var userViewModel : UserViewModel

    init() {
        let router = Routeur()
        _routeur = StateObject(wrappedValue: router)
        _userViewModel = StateObject(wrappedValue: UserViewModel(routeur: router))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
            .environmentObject(routeur)
            .environmentObject(userViewModel)
        }
    }
}
