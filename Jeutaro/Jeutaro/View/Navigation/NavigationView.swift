//
//  NavigationView.swift
//  Jeutaro
//
//  Created by etud on 13/03/2025.
//

import SwiftUI

struct NavigationView: View {

    @EnvironmentObject var routeur: Routeur

    var user: User? = nil

    var body: some View {
        routeur.getRoute()
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView()
            .environmentObject(Routeur())
    }
}
