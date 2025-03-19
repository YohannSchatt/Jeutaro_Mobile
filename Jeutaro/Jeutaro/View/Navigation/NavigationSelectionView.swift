//
//  NavigationView.swift
//  Jeutaro
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct NavigationSelectionView: View {

    @EnvironmentObject var routeur : Routeur

    var user : User? = nil

    var body: some View {
        NavigationStack {
            HStack {
                VStack {
                    Spacer().frame(maxHeight: 17)
                    HStack {
                        Spacer().frame(maxWidth: 10)
                        Text("Navigation").font(.system(size: 30))
                        Spacer()
                    }
                    Spacer().frame(maxHeight: 40)
                    if(user == nil) {
                        ButtonNavigation(text: "Connexion", view: ConnexionView())
                    }
                    ButtonNavigation(text: "Catalogue", view: CatalogueView())
                    ButtonNavigation(text: "Session", view: SessionView())
                    Spacer()
                }
                Spacer()
            }.background(DefineColor.color2.color)
        }
    }
}

struct NavigationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSelectionView()
    }
}
