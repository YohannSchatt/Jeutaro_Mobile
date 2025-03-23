//
//  NavigationView.swift
//  Jeutaro
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct NavigationSelectionView: View {

    @EnvironmentObject var routeur : Routeur

    @EnvironmentObject var userViewModel : UserViewModel

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
                    VStack(spacing:0) {
                        Spacer().frame(maxHeight: 40)
                        if(userViewModel.user == nil) {
                            ButtonNavigation(text: "Connexion", view: ConnexionView())
                        }
                        else {
                            if (userViewModel.user!.getRole() == .ADMIN) {
                                ButtonNavigation(text: "Gérer gestionnaire", view: PageGestionGestionnaireView())
                            }
                            ButtonNavigation(text: "Gérer vendeur", view: PageVendeurView())
                            ButtonNavigation(text: "Enregistrer un dépot", view: EnregistrerDepotView())
                            ButtonNavigation(text: "Enregistrer un achat", view: EnregistrerAchatView())
                            ButtonNavigation(text: "Enregistrer un retrait", view: EnregistrerRetraitView())
                        }
                        ButtonNavigation(text: "Catalogue", view: CatalogueView())
                        ButtonNavigation(text: "Session", view: SessionView())
                        if(userViewModel.user != nil) {
                            HStack {
                                Button(action: {
                                    routeur.setRoute(route: AnyView(ConnexionView()))
                                    userViewModel.user = nil
                                }) {
                                    Text("Déconnexion")
                                        .font(.system(size: 20))
                                        .padding()
                                        .foregroundColor(.red)
                                }
                                Spacer()
                            }.border(Color.black, width: 2)
                            .background(DefineColor.color5.color)
                        }
                    }
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
