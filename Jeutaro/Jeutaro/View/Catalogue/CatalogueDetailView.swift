//
//  CatalogueDetailView.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 25/03/2025.
//
import SwiftUI

struct CatalogueDetailView: View {
    let item: CatalogueItem
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // Remove the NavigationView wrapper
        VStack {
            // Custom header
            HStack {
                Text("Détails du jeu")
                    .font(.headline)
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Fermer")
                }
            }
            .padding()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Image
                    ZStack {
                        if let imageData = item.image, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .frame(height: 300)
                        } else {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 300)
                            
                            Image(systemName: "gamecontroller")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                        }
                    }
                    .cornerRadius(12)
                    
                    // Informations principales
                    VStack(alignment: .leading, spacing: 12) {
                        Text(item.nom)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text(String(format: "%.2f €", item.prix))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            
                            Spacer()
                            
                            Text("État: \(item.etat)")
                                .font(.subheadline)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.green.opacity(0.2))
                                )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Détails
                    VStack(alignment: .leading, spacing: 16) {
                        DetailRow(title: "Éditeur", value: item.editeur)
                        
                        DetailRow(title: "Vendeur", value: "\(item.prenomVendeur) \(item.nomVendeur)")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Text(item.description)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.body)
        }
    }
}