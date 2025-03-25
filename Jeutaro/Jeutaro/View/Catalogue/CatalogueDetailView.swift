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
        ZStack {
            // Fond avec dégradé
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Custom header
                HStack {
                    Text("Détails du jeu")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Fermer")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Image avec cache
                        CachedImage(id: item.id, imageData: item.image)
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity)
                            .frame(height: 300)
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                        
                        // Informations principales
                        VStack(alignment: .leading, spacing: 12) {
                            Text(item.nom)
                                .font(.system(size: 28, weight: .bold))
                            
                            HStack {
                                Text(String(format: "%.2f €", item.prix))
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.blue)
                                
                                Spacer()
                                
                                Text("État: \(item.etat)")
                                    .font(.system(size: 15, weight: .medium))
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.green.opacity(0.2))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Détails
                        VStack(alignment: .leading, spacing: 20) {
                            // Éditeur
                            DetailRowImproved(
                                title: "Éditeur",
                                value: item.editeur, 
                                icon: "building.2"
                            )
                            
                            // Vendeur
                            DetailRowImproved(
                                title: "Vendeur", 
                                value: "\(item.prenomVendeur) \(item.nomVendeur)",
                                icon: "person"
                            )
                            
                            // Description
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "text.alignleft")
                                        .foregroundColor(.blue.opacity(0.7))
                                    
                                    Text("Description")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                }
                                
                                Text(item.description.isEmpty ? "Aucune description disponible" : item.description)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding()
                                    .background(Color.white.opacity(0.5))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // Bouton d'action (vide pour le moment, peut être utilisé plus tard)
                        Button(action: {
                            // Action future potentielle
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Retour au catalogue")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 50)
                                .frame(maxWidth: .infinity)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                                  startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(12)
                                .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 5)
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
    }
}

struct DetailRowImproved: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue.opacity(0.7))
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.body)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.5))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}