//
//  CatalogueViewModel.swift
//  Jeutaro
//
//  Created by Shane Donnelly on 25/03/2025.
//

import Foundation
import SwiftUI
import Combine

class CatalogueViewModel: ObservableObject {
    @Published var items: [CatalogueItem] = []
    @Published var isLoading: Bool = false
    @Published var error: CatalogueError? = nil
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 1
    @Published var totalItems: Int = 0
    @Published var selectedItem: CatalogueItem? = nil
    @Published var showDetailView: Bool = false
    
    private let service = CatalogueService()
    
    // IMPORTANT: Ne pas charger automatiquement dans l'init
    init() {
        // Ne rien charger automatiquement à l'initialisation
        // L'utilisateur devra appuyer sur un bouton pour charger la première page
    }
    
    // Fonction explicite pour charger la première page
    func loadFirstPage() {
        // Ne charger que si ce n'est pas déjà en cours de chargement
        if !isLoading {
            Task {
                await loadPage(page: 1)
            }
        }
    }
    
    func loadPage(page: Int) async {
        // Protection contre les chargements multiples
        guard !isLoading else { return }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }
        
        do {
            print("Chargement de la page \(page) du catalogue")
            
            let response = try await service.getCatalogue(page: page)
            
            print("Reçu \(response.items.count) jeux sur un total de \(response.nbJeux)")
            
            let catalogueItems = response.items.map { CatalogueItem(from: $0) }
            
            DispatchQueue.main.async {
                self.items = catalogueItems
                self.totalPages = response.totalPages
                self.totalItems = response.nbJeux
                self.currentPage = page
                self.isLoading = false
                print("Page \(page)/\(self.totalPages) chargée avec succès")
            }
        } catch let err as CatalogueError {
            DispatchQueue.main.async {
                print("Erreur catalogue: \(err)")
                self.error = err
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                print("Erreur inattendue: \(error)")
                self.error = .NetworkError(error)
                self.isLoading = false
            }
        }
    }
    
    func nextPage() {
        // Vérifier si nous sommes déjà à la dernière page
        if currentPage < totalPages && !isLoading {
            Task {
                await loadPage(page: currentPage + 1)
            }
        }
    }
    
    func previousPage() {
        // Vérifier si nous sommes déjà à la première page
        if currentPage > 1 && !isLoading {
            Task {
                await loadPage(page: currentPage - 1)
            }
        }
    }
    
    func selectItem(_ item: CatalogueItem) {
        selectedItem = item
        showDetailView = true
    }
}
