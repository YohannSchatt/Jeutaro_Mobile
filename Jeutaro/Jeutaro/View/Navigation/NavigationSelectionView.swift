//
//  NavigationView.swift
//  Jeutaro
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct NavigationSelectionView: View {

    @ObservedObject var selection: routeur

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
                    ButtonNavigation(selection: selection, text: "Connexion", view: ConnexionView())
                    ButtonNavigation(selection: selection, text: "Catalogue", view: CatalogueView())
                    ButtonNavigation(selection: selection, text: "Session", view: SessionView())
                    Spacer()
                }
                Spacer()
            }.background(DefineColor.color2.color)
        }
    }
}

struct NavigationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSelectionView(selection: routeur())
    }
}
