//
//  UniqueGestionnaireView.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

struct UniqueGestionnaireView: View {
    
    let user: User
    let idListGestionnaire: Int
    let gestionnaireViewModel: GestionnaireViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Infos utilisateur
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 5) {
                    Text(user.getNom())
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(user.getPrenom())
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(user.getEmail())
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 15)
            
            // Bouton supprimer
            Button(action: {
                Task {
                    let result: Bool = await gestionnaireViewModel.deleteGestionnaire(email: user.getEmail())
                    if (result) {
                        gestionnaireViewModel.filterGestionnaire(nom: user.getNom(), prenom: user.getPrenom(), email: user.getEmail())
                    }
                }
            }) {
                HStack {
                    Image(systemName: "trash")
                        .font(.system(size: 14))
                    
                    Text("Supprimer")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.red, Color.red.opacity(0.8)]),
                                   startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(8)
                .shadow(color: Color.red.opacity(0.3), radius: 3, x: 0, y: 2)
            }
            .padding(.trailing, 15)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(idListGestionnaire % 2 == 0 ? Color(.systemGray6).opacity(0.5) : Color.white)
    }
}

struct UniqueGestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        UniqueGestionnaireView(user: User(nom: "Test", prenom: "Test2", email: "Test@example.co", role: .GESTIONNAIRE), idListGestionnaire: 0, gestionnaireViewModel: GestionnaireViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}