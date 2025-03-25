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
            // Fond avec dégradé
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Titre et barre de recherche
                VStack(spacing: 12) {
                    Text("Catalogue de jeux")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                    
                    // Barre de recherche
                    HStack {
                        // Champ de recherche
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                            
                            TextField("Rechercher un jeu...", text: $viewModel.searchText)
                                .autocapitalization(.none)
                                .padding(.vertical, 12)
                            
                            if !viewModel.searchText.isEmpty {
                                Button(action: {
                                    viewModel.searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                }
                            }
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        )
                        
                        // Bouton filtre
                        Button(action: {
                            viewModel.showFilterPanel = true
                        }) {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(viewModel.hasActiveFilters ? .white : .blue)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 15)
                                .background(
                                    Group {
                                        if viewModel.hasActiveFilters {
                                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                                         startPoint: .leading, endPoint: .trailing)
                                        } else {
                                            Color(.systemGray6)
                                        }
                                    }
                                )
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }  // <- Accolade fermante ajoutée ici pour le HStack
                    .padding(.horizontal)
                }
                .padding(.bottom, 8)
                
                // Badge des filtres actifs
                if viewModel.hasActiveFilters {
                    HStack {
                        Text("Filtres actifs")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.blue)
                                    .shadow(color: Color.blue.opacity(0.3), radius: 2, x: 0, y: 1)
                            )
                        
                        Spacer()
                        
                        Button(action: {
                            viewModel.resetFilters()
                        }) {
                            Text("Effacer tout")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .padding(.top, 5)
                }
                
                if viewModel.items.isEmpty && !viewModel.isLoading && viewModel.error == nil {
                    // État initial avant chargement
                    Spacer()
                    VStack(spacing: 25) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(.blue.opacity(0.7))
                        
                        Text("Bienvenue dans le catalogue")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Cliquez pour découvrir les jeux disponibles")
                            .foregroundColor(.secondary)
                            .padding(.bottom, 10)
                        
                        Button(action: {
                            viewModel.loadFirstPage()
                        }) {
                            Text("Charger le catalogue")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 50)
                                .frame(width: 220)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                                 startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(10)
                                .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 5)
                        }
                    }
                    .padding(.vertical, 40)
                    Spacer()
                } else if viewModel.isLoading && viewModel.items.isEmpty {
                    // État de chargement initial
                    Spacer()
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        
                        Text("Chargement du catalogue...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    Spacer()
                } else if let error = viewModel.error {
                    // Affichage des erreurs
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text("Erreur de chargement")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(error.description)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        
                        Button(action: {
                            viewModel.loadFirstPage()
                        }) {
                            Text("Réessayer")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(
                                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                                 startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(10)
                                .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 5)
                        }
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
                            VStack(spacing: 10) {
                                ProgressView()
                                Text("Chargement...")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                    }
                    
                    // Aucun résultat
                    if viewModel.items.isEmpty && !viewModel.isLoading {
                        VStack(spacing: 20) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                                .padding()
                            
                            Text("Aucun jeu ne correspond à votre recherche")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                            
                            Button(action: {
                                viewModel.resetFilters()
                            }) {
                                Text("Réinitialiser les filtres")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 25)
                                    .padding(.vertical, 12)
                                    .background(
                                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                                     startPoint: .leading, endPoint: .trailing)
                                    )
                                    .cornerRadius(10)
                                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 5)
                            }
                            .padding(.top, 10)
                        }
                        .padding(.vertical, 40)
                    }
                    
                    // Contrôles de pagination
                    HStack(spacing: 20) {
                        Button(action: {
                            viewModel.previousPage()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Précédent")
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(
                                viewModel.currentPage > 1 ?
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                             startPoint: .leading, endPoint: .trailing) :
                                LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray.opacity(0.8)]),
                                             startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: viewModel.currentPage > 1 ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2), radius: 3, x: 0, y: 3)
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
                            .padding(.vertical, 10)
                            .background(
                                viewModel.currentPage < viewModel.totalPages ?
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                             startPoint: .leading, endPoint: .trailing) :
                                LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray.opacity(0.8)]),
                                             startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: viewModel.currentPage < viewModel.totalPages ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2), radius: 3, x: 0, y: 3)
                        }
                        .disabled(viewModel.currentPage >= viewModel.totalPages || viewModel.isLoading || viewModel.totalPages <= 1)
                    }
                    .padding(.vertical, 15)
                    .padding(.horizontal)
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