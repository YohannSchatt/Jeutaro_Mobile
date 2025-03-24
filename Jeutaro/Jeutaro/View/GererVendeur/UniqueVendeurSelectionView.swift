//
//  UniqueVendeurSelectionView.swift
//  Jeutaro
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct UniqueVendeurSelectionView: View {
    
    let vendeur: Vendeur
    let idListVendeur: Int
    let vendeurViewModel: VendeurViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // Infos vendeur
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 5) {
                    Text(vendeur.nom)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text(vendeur.prenom)
                        .font(.system(size: 16, weight: .semibold))
                }
                
                Text(vendeur.numero)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                
                Text(vendeur.email)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 15)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Bouton de sélection
            Button(action: {
                Task {
                    vendeurViewModel.setIdVendeurSelected(index: self.idListVendeur)
                }
            }) {
                Text("Sélectionner")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(8)
                    .shadow(color: Color.blue.opacity(0.3), radius: 3, x: 0, y: 2)
            }
            .padding(.trailing, 15)
        }
        .frame(maxWidth: .infinity)
        .background(idListVendeur % 2 == 0 ? Color(.systemGray6).opacity(0.5) : Color.white)
        .cornerRadius(0)
    }
}

struct UniqueVendeurSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        UniqueVendeurSelectionView(vendeur: Vendeur(idVendeur: 1, prenom: "Paul", nom: "Merle", email: "paul@example.com", numero: "0606060606"), idListVendeur: 0, vendeurViewModel: VendeurViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}