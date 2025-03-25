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
                    .font(.headline)
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
                VStack(spacing: 16) {
                    // Filtre par nom
                    VStack(alignment: .leading) {
                        Text("Nom du jeu")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Nom...", text: $viewModel.filterName)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Filtre par éditeur
                    VStack(alignment: .leading) {
                        Text("Éditeur")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Éditeur...", text: $viewModel.filterPublisher)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Filtre par prix
                    VStack(alignment: .leading) {
                        Text("Prix (€)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            TextField("Min", text: $viewModel.filterMinPrice)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            
                            Text("à")
                                .foregroundColor(.secondary)
                            
                            TextField("Max", text: $viewModel.filterMaxPrice)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                    
                    // Boutons d'action
                    HStack {
                        // Bouton pour réinitialiser les filtres
                        Button(action: {
                            viewModel.resetFilters()
                            viewModel.showFilterPanel = false
                        }) {
                            Text("Réinitialiser")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(8)
                        
                        // Bouton pour appliquer les filtres
                        Button(action: {
                            viewModel.applyFilters()
                        }) {
                            Text("Appliquer")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding(20)
    }
}
