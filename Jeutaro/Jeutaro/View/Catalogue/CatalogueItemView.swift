//
//  CatalogueItemView.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 25/03/2025.
//

import SwiftUI

struct CatalogueItemView: View {
    let item: CatalogueItem
    
    var body: some View {
        VStack {
            // Utiliser CachedImage pour l'affichage optimisé
            CachedImage(id: item.id, imageData: item.image)
                .frame(width: 150, height: 150)
                .cornerRadius(8)
            
            // Nom du jeu
            Text(item.nom)
                .font(.headline)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(height: 50)
            
            // Prix
            Text(String(format: "%.2f €", item.prix))
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
