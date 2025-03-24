//
//  PageMonCompteView.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

struct PageMonCompteView: View {
    var body: some View {
        ZStack {
            // Fond avec dégradé
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // En-tête
                Text("Mon Compte")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Section de modification des informations
                        ModifInfoView()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.5))
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                            .padding(.horizontal)
                            .padding(.top, 10)
                        
                        // Diviseur décoratif
                        HStack {
                            Color.gray.opacity(0.3)
                                .frame(height: 1)
                            
                            Text("Sécurité")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 10)
                            
                            Color.gray.opacity(0.3)
                                .frame(height: 1)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        
                        // Section de modification du mot de passe
                        ModifMotDePasseView()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white.opacity(0.5))
                                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                            )
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct PageMonCompteView_Previews: PreviewProvider {
    static var previews: some View {
        PageMonCompteView()
            .environmentObject(UserViewModel(routeur: Routeur()))
    }
}