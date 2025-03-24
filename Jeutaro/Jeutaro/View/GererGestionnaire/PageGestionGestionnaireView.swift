//
//  PageGestionGestionnaire.swift
//  Jeutaro
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

struct PageGestionGestionnaireView: View {
    
    let gestionnaireViewModel: GestionnaireViewModel = GestionnaireViewModel()
    
    var body: some View {
        ZStack {
            // Fond avec dégradé
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // En-tête
                Text("Gestion des Gestionnaires")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Section de création
                        CreationGestionnaireView(gestionnaireViewModel: gestionnaireViewModel)
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
                            
                            Text("Recherche et Suppression")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 10)
                            
                            Color.gray.opacity(0.3)
                                .frame(height: 1)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        
                        // Section de suppression
                        DeleteGestionnaireView(gestionnaireViewModel: gestionnaireViewModel)
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

struct PageGestionGestionnaire_Previews: PreviewProvider {
    static var previews: some View {
        PageGestionGestionnaireView()
    }
}