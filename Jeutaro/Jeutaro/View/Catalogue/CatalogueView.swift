//
//  CatalogueView.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 25/03/2025.
//

import SwiftUI

struct CatalogueView: View {
    @StateObject private var viewModel = CatalogueViewModel()
    @EnvironmentObject var routeur: Routeur
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Titre et barre de recherche
                VStack(spacing: 8) {
                    Text("Catalogue de jeux")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // Barre de recherche
                    HStack {
                        // Champ de recherche
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            
                            TextField("Rechercher un jeu...", text: $viewModel.searchText)
                                .autocapitalization(.none)
                            
                            if !viewModel.searchText.isEmpty {
                                Button(action: {
                                    viewModel.searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        
                        // Bouton filtre
                        Button(action: {
                            viewModel.showFilterPanel = true
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(.blue)
                                .padding(8)
                                .background(viewModel.hasActiveFilters ? Color.blue.opacity(0.2) : Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
                
                // Badge des filtres actifs
                if viewModel.hasActiveFilters {
                    HStack {
                        Text("Filtres actifs")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue)
                            .cornerRadius(12)
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.resetFilters()
                        }) {
                            Text("Effacer tout")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
                
                if viewModel.items.isEmpty && !viewModel.isLoading && viewModel.error == nil {
                    // État initial avant chargement
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        
                        Text("Bienvenue dans le catalogue")
                            .font(.headline)
                        
                        Text("Cliquez pour charger les jeux")
                            .foregroundColor(.secondary)
                        
                        Button(action: {
                            viewModel.loadFirstPage()
                        }) {
                            Text("Charger le catalogue")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 40)
                    Spacer()
                } else if viewModel.isLoading && viewModel.items.isEmpty {
                    // État de chargement initial
                    Spacer()
                    ProgressView("Chargement du catalogue...")
                        .padding()
                    Spacer()
                } else if let error = viewModel.error {
                    // Affichage des erreurs
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        
                        Text("Erreur de chargement")
                            .font(.headline)
                        
                        Text(error.description)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        Button(action: {
                            viewModel.loadFirstPage()
                        }) {
                            Text("Réessayer")
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        .padding(.top, 8)
                    }
                    Spacer()
                } else {
                    // Liste de jeux
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                            ForEach(viewModel.items) { item in
                                CatalogueItemView(item: item)
                                    .onTapGesture {
                                        viewModel.selectItem(item)
                                    }
                            }
                        }
                        .padding(.horizontal)
                        
                        if viewModel.isLoading {
                            ProgressView("Chargement...")
                                .padding()
                        }
                    }
                    
                    // Aucun résultat
                    if viewModel.items.isEmpty && !viewModel.isLoading {
                        VStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                                .padding()
                            
                            Text("Aucun jeu ne correspond à votre recherche")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                            
                            Button(action: {
                                viewModel.resetFilters()
                            }) {
                                Text("Réinitialiser les filtres")
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.top, 16)
                        }
                        .padding(.vertical, 40)
                    }
                    
                    // Contrôles de pagination - TOUJOURS VISIBLES
                    HStack(spacing: 20) {
                        Button(action: {
                            viewModel.previousPage()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Précédent")
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.currentPage > 1 ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                        .disabled(viewModel.currentPage <= 1 || viewModel.isLoading || viewModel.totalPages <= 1)
                        
                        Text("Page \(viewModel.currentPage) / \(max(viewModel.totalPages, 1))")
                            .fontWeight(.medium)
                        
                        Button(action: {
                            viewModel.nextPage()
                        }) {
                            HStack {
                                Text("Suivant")
                                Image(systemName: "chevron.right")
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(viewModel.currentPage < viewModel.totalPages ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                        }
                        .disabled(viewModel.currentPage >= viewModel.totalPages || viewModel.isLoading || viewModel.totalPages <= 1)
                    }
                    .padding(.vertical, 10)
                }
            }
            .onAppear {
                // Chargement explicite de la première page lors de l'apparition
                if viewModel.items.isEmpty && !viewModel.isLoading && viewModel.error == nil {
                    viewModel.loadFirstPage()
                }
            }
            
            // Panneau de filtres
            if viewModel.showFilterPanel {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        viewModel.showFilterPanel = false
                    }
                
                FilterPanelView(viewModel: viewModel)
                    .frame(maxWidth: 500)
            }
        }
        .sheet(isPresented: $viewModel.showDetailView) {
            if let selectedItem = viewModel.selectedItem {
                CatalogueDetailView(item: selectedItem)
            }
        }
    }
}