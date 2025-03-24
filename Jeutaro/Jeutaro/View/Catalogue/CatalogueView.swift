import SwiftUI

struct CatalogueView: View {
    @StateObject private var viewModel = CatalogueViewModel()
    @EnvironmentObject var routeur: Routeur
    
    var body: some View {
        VStack {
            // Titre
            Text("Catalogue de jeux")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top)
            
            if viewModel.items.isEmpty && !viewModel.isLoading && viewModel.error == nil {
                // État initial avant chargement
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
                            CatalogueDetailView(item: item)
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
                        .padding(.vertical, 8)
                        .background(viewModel.currentPage > 1 ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                    }
                    .disabled(viewModel.currentPage <= 1 || viewModel.isLoading)
                    
                    Text("Page \(viewModel.currentPage) / \(viewModel.totalPages)")
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
                    .disabled(viewModel.currentPage >= viewModel.totalPages || viewModel.isLoading)
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
        .sheet(isPresented: $viewModel.showDetailView) {
            if let selectedItem = viewModel.selectedItem {
                CatalogueDetailView(item: selectedItem)
            }
        }
    }
}
