//
//  FilterPanelView.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 25/03/2025.
//

import SwiftUI

struct FilterPanelView: View {
    @ObservedObject var viewModel: CatalogueViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // En-tête du panneau
            HStack {
                Text("Filtres")
                    .font(.system(size: 22, weight: .bold))
                    .padding()
                
                Spacer()
                
                Button(action: {
                    viewModel.showFilterPanel = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .background(Color(.systemBackground))
            
            Divider()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Filtre par nom
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Nom du jeu")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField("Nom...", text: $viewModel.filterName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Filtre par éditeur
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Éditeur")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField("Éditeur...", text: $viewModel.filterPublisher)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Filtre par prix
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Prix (€)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Min")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                TextField("Min", text: $viewModel.filterMinPrice)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Max")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                TextField("Max", text: $viewModel.filterMaxPrice)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 30)
                    
                    // Boutons d'action
                    HStack(spacing: 15) {
                        // Bouton pour réinitialiser les filtres
                        Button(action: {
                            viewModel.resetFilters()
                            viewModel.showFilterPanel = false
                        }) {
                            Text("Réinitialiser")
                                .font(.headline)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                        
                        // Bouton pour appliquer les filtres
                        Button(action: {
                            viewModel.applyFilters()
                        }) {
                            Text("Appliquer")
                                .font(.headline)
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                          startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: Color.blue.opacity(0.3), radius: 3, x: 0, y: 3)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
        .padding(20)
    }
}