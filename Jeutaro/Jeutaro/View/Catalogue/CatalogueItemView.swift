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
        VStack(alignment: .leading, spacing: 8) {
            // Utiliser CachedImage pour l'affichage optimisé
            CachedImage(id: item.id, imageData: item.image)
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // Nom du jeu
            Text(item.nom)
                .font(.system(size: 16, weight: .semibold))
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(height: 44, alignment: .topLeading)
            
            // Éditeur
            Text(item.editeur)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .lineLimit(1)
            
            // Prix
            HStack {
                Text(String(format: "%.2f €", item.prix))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text(item.etat)
                    .font(.system(size: 11, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.green.opacity(0.2))
                    )
            }
            .padding(.top, 4)
        }
        .padding(12)
        .background(Color.white.opacity(0.8))
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}