//
//  NavigationView.swift
//  Jeutaro
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct NavigationSelectionView: View {
    
    @EnvironmentObject var routeur: Routeur
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // En-tête
            HStack {
                Text("Navigation")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.leading, 16)
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.bottom, 8)
            
            Divider()
                .background(Color.blue.opacity(0.2))
                .padding(.horizontal, 8)
            
            // Liste des options de navigation
            ScrollView {
                VStack(spacing: 0) {
                    // Verifier statut connexion
                    if userViewModel.getUser() == nil {
                        ButtonNavigation(text: "Connexion", view: ConnexionView())
                    } else {
                        // Option admin
                        if userViewModel.getUser()!.getRole() == .ADMIN {
                            ButtonNavigation(text: "Gérer gestionnaire", view: PageGestionGestionnaireView())
                        }
                        // Options utilisateur connecté
                        ButtonNavigation(text: "Mon compte", view: PageMonCompteView())
                        ButtonNavigation(text: "Gérer vendeur", view: PageVendeurView())
                        ButtonNavigation(text: "Enregistrer un dépôt", view: EnregistrerDepotView())
                        ButtonNavigation(text: "Enregistrer un achat", view: EnregistrerAchatView())
                        ButtonNavigation(text: "Enregistrer un retrait", view: EnregistrerRetraitView())
                    }
                    
                    // Options pour tous
                    ButtonNavigation(text: "Catalogue", view: CatalogueView())
                    ButtonNavigation(text: "Session", view: SessionView())
                    
                    // Bouton de déconnexion
                    if userViewModel.getUser() != nil {
                        Button(action: {
                            routeur.setRoute(route: AnyView(ConnexionView()))
                            userViewModel.setUser(user: nil)
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.square")
                                    .font(.system(size: 18))
                                    .foregroundColor(.red)
                                
                                Text("Déconnexion")
                                    .font(.system(size: 17, weight: .medium))
                                    .foregroundColor(.red)
                                
                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.red.opacity(0.05))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red.opacity(0.2), lineWidth: 1)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal, 8)
                        .padding(.top, 16)
                        .padding(.bottom, 4)
                    }
                }
                .padding(.top, 8)
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
        )
    }
}

struct NavigationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationSelectionView()
            .environmentObject(Routeur())
            .environmentObject(UserViewModel(routeur: Routeur()))
    }
}
