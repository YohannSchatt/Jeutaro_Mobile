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
    
    // Nouveaux états pour le filtrage
    @Published var searchText: String = ""
    @Published var showFilterPanel: Bool = false
    
    // Filtres avancés
    @Published var filterName: String = ""
    @Published var filterPublisher: String = ""
    @Published var filterMinPrice: String = ""
    @Published var filterMaxPrice: String = ""
    
    // Valeurs de filtres actuellement appliquées
    private var appliedName: String? = nil
    private var appliedPublisher: String? = nil
    private var appliedMinPrice: Double? = nil
    private var appliedMaxPrice: Double? = nil
    
    private let service = CatalogueService()
    
    // Debouncer pour la recherche par nom
    private var searchDebounce: AnyCancellable?
    
    init() {
        // Ajouter un debouncer pour la recherche
        searchDebounce = $searchText
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else { return }
                
                if text.isEmpty && self.appliedName != nil {
                    // Si le texte est vide et qu'un filtre était appliqué
                    self.appliedName = nil
                    self.loadFirstPage()
                } else if !text.isEmpty && (self.appliedName != text) {
                    // Si le texte a changé et n'est pas vide
                    self.appliedName = text
                    self.loadFirstPage()
                }
            }
    }
    
    // Fonction pour charger la première page (avec filtres)
    func loadFirstPage() {
        if !isLoading {
            Task {
                await loadPage(page: 1)
            }
        }
    }
    
    // Fonction pour appliquer les filtres avancés
    func applyFilters() {
        // Mettre à jour les filtres appliqués à partir des valeurs actuelles
        appliedName = filterName.isEmpty ? nil : filterName
        appliedPublisher = filterPublisher.isEmpty ? nil : filterPublisher
        appliedMinPrice = filterMinPrice.isEmpty ? nil : Double(filterMinPrice)
        appliedMaxPrice = filterMaxPrice.isEmpty ? nil : Double(filterMaxPrice)
        
        // Fermer le panneau de filtres
        showFilterPanel = false
        
        // Recharger la première page avec les nouveaux filtres
        loadFirstPage()
    }
    
    // Fonction pour réinitialiser tous les filtres
    func resetFilters() {
        searchText = ""
        filterName = ""
        filterPublisher = ""
        filterMinPrice = ""
        filterMaxPrice = ""
        
        appliedName = nil
        appliedPublisher = nil
        appliedMinPrice = nil
        appliedMaxPrice = nil
        
        loadFirstPage()
    }
    
    // Fonction mise à jour pour inclure les filtres
    func loadPage(page: Int) async {
        guard !isLoading else { return }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.error = nil
        }
        
        do {
            print("Chargement de la page \(page) du catalogue avec filtres")
            
            // Appliquer le filtre de texte rapide si nécessaire
            let nameFilter = !searchText.isEmpty ? searchText : appliedName
            
            let response = try await service.getCatalogue(
                page: page,
                nom: nameFilter,
                editeur: appliedPublisher,
                prixMin: appliedMinPrice,
                prixMax: appliedMaxPrice
            )
            
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
    
    // Fonctions existantes de pagination
    func nextPage() {
        if currentPage < totalPages && !isLoading {
            Task {
                await loadPage(page: currentPage + 1)
            }
        }
    }
    
    func previousPage() {
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
    
    // Fonction pratique pour vérifier si des filtres sont appliqués
    var hasActiveFilters: Bool {
        return appliedName != nil || 
               appliedPublisher != nil || 
               appliedMinPrice != nil || 
               appliedMaxPrice != nil
    }
}