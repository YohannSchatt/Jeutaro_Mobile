//
//  ConnexionSucessView.swift
//  Jeutaro
//
//  Created by etud on 19/03/2025.
//

import SwiftUI

struct ConnexionSucessView: View {
    
    @EnvironmentObject var routeur: Routeur
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        ZStack {
            // Fond avec dégradé
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                // En-tête
                VStack(spacing: 5) {
                    Text("Félicitations")
                        .font(.system(size: 26, weight: .light))
                        .foregroundColor(.secondary)
                    
                    Text("Connexion Réussie")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                
                // Icône de succès
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.green.opacity(0.7), Color.green.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: Color.green.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 60, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
                
                // Message de bienvenue
                VStack(spacing: 15) {
                    Text("Bienvenue \(userViewModel.getUser()?.getPrenom() ?? "") !")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Vous êtes maintenant connecté au système Jeutaro avec le rôle \(userViewModel.getUser()?.getRole().rawValue ?? "").")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 30)
                
                Spacer()
                
                // Bouton pour continuer
                Button(action: {
                    routeur.setRoute(route: AnyView(NavigationSelectionView()))
                }) {
                    Text("Continuer")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                           startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(10)
                        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 10)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 40)
            }
        }
    }
}
