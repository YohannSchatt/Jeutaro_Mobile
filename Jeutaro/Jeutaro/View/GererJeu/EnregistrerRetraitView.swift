//
//  EnregistrerRetraitView.swift
//  Jeutaro
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

struct EnregistrerRetraitView: View {
    
    @State private var emailSuggestions: [String] = []
    @State private var ArticleSuggestions: [String] = []
    
    @State private var selectedEmailIndex: Int? = nil
    @State private var ArticlesSelected: [JeuUnitaire] = []
    
    @State private var getArgent: Bool = false
    @State private var getJeux: Bool = false
    
    @State private var message: String = ""
    
    // Variables pour le message de confirmation
    @State private var successMessageVisible: Bool = false
    @State private var successMessage: String = ""
    
    @ObservedObject var retraitViewModel: RetraitViewModel = RetraitViewModel()
    @ObservedObject var vendeurViewModel: VendeurViewModel = VendeurViewModel()
    
    var body: some View {
        ZStack {
            // Fond avec dégradé
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // En-tête
                    Text("Enregistrer un retrait")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    // Section principale
                    VStack(spacing: 20) {
                        // Section sélection vendeur
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Vendeur")
                                .font(.headline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                            
                            // Message de confirmation visible après un retrait réussi
                            if successMessageVisible {
                                VStack(alignment: .leading, spacing: 5) {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                            .font(.system(size: 18))
                                        
                                        Text(successMessage)
                                            .font(.subheadline)
                                            .foregroundColor(.green)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            successMessageVisible = false
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 16))
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.green.opacity(0.1))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.horizontal)
                                .padding(.bottom, 5)
                                .transition(.opacity)
                                .animation(.easeInOut, value: successMessageVisible)
                            }
                            
                            HStack {
                                if selectedEmailIndex == nil {
                                    TextField("Email du vendeur...", text: $retraitViewModel.email)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                        )
                                        .onChange(of: retraitViewModel.email) { newValue in
                                            if selectedEmailIndex == nil {
                                                updateEmailSuggestions(with: newValue)
                                            }
                                        }
                                }
                                else {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack {
                                            Text("Email vendeur:")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            
                                            Text(vendeurViewModel.getEmail(index: self.selectedEmailIndex!))
                                                .font(.headline)
                                        }
                                        
                                        HStack {
                                            Text("Nom:")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            
                                            Text(vendeurViewModel.getNom(index: self.selectedEmailIndex!))
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                            
                                            Spacer()
                                            
                                            Text("Prénom:")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                            
                                            Text(vendeurViewModel.getPrenom(index: self.selectedEmailIndex!))
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                        }
                                        
                                        Text("Somme due: \(String(format: "%.2f", vendeurViewModel.vendeur[selectedEmailIndex!].sommeDue)) €")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.blue)
                                            .padding(.top, 2)
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.white.opacity(0.5))
                                    .cornerRadius(10)
                                    
                                    if selectedEmailIndex != nil {
                                        Button(action: {
                                            retraitViewModel.email = ""
                                            selectedEmailIndex = nil
                                            emailSuggestions = []
                                            ArticlesSelected = []
                                            retraitViewModel.numeroArticle = ""
                                            successMessageVisible = false
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.system(size: 20))
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.trailing, 5)
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Suggestions d'email
                            if !emailSuggestions.isEmpty {
                                ScrollView {
                                    VStack(spacing: 0) {
                                        ForEach(emailSuggestions, id: \.self) { suggestion in
                                            HStack {
                                                Text(suggestion)
                                                    .padding(.vertical, 12)
                                                    .padding(.horizontal, 15)
                                                Spacer()
                                            }
                                            .contentShape(Rectangle())
                                            .background(Color.white)
                                            .onTapGesture {
                                                retraitViewModel.email = suggestion
                                                selectedEmailIndex = emailSuggestions.firstIndex(of: suggestion)
                                                emailSuggestions = []
                                                successMessageVisible = false
                                                Task {
                                                    await retraitViewModel.getJeuVendeur(vendeur: vendeurViewModel.getVendeur(index: selectedEmailIndex!))
                                                }
                                            }
                                            Divider()
                                        }
                                    }
                                    .background(Color(.systemGray6).opacity(0.5))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                                    )
                                }
                                .frame(height: min(CGFloat(emailSuggestions.count) * 44, 150))
                                .padding(.horizontal)
                            }
                        }
                        
                        // Section recherche d'articles
                        if selectedEmailIndex != nil {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Numéro de l'article")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                
                                TextField("Numéro de l'article...", text: $retraitViewModel.numeroArticle)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                                    .padding(.horizontal)
                                    .onChange(of: String(retraitViewModel.numeroArticle)) { newValue in
                                        updateArticleSuggestions(with: newValue)
                                    }
                                
                                // Suggestions d'articles
                                if !ArticleSuggestions.isEmpty {
                                    ScrollView {
                                        VStack(spacing: 0) {
                                            ForEach(ArticleSuggestions, id: \.self) { suggestion in
                                                HStack {
                                                    Text(suggestion)
                                                        .padding(.vertical, 12)
                                                        .padding(.horizontal, 15)
                                                    Spacer()
                                                }
                                                .contentShape(Rectangle())
                                                .background(Color.white)
                                                .onTapGesture {
                                                    let suggestionParts = suggestion.split(separator: "|")
                                                    let suggestionIdString = suggestionParts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                                                    if let suggestionId = Int(suggestionIdString) {
                                                        if let selectedJeu = retraitViewModel.listJeuUnitaire.first(where: { $0.idJeuUnitaire == suggestionId }) {
                                                            ArticlesSelected.append(selectedJeu)
                                                            retraitViewModel.numeroArticle = ""
                                                            updateArticleSuggestions(with: retraitViewModel.numeroArticle)
                                                            getJeux = true
                                                        }
                                                    }
                                                }
                                                Divider()
                                            }
                                        }
                                        .background(Color(.systemGray6).opacity(0.5))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                                        )
                                    }
                                    .frame(height: min(CGFloat(ArticleSuggestions.count) * 44, 150))
                                    .padding(.horizontal)
                                }
                                
                                // Liste des articles sélectionnés
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Jeux à retirer")
                                        .font(.headline)
                                        .foregroundColor(.secondary)
                                        .padding(.top, 10)
                                        .padding(.horizontal)
                                    
                                    if ArticlesSelected.isEmpty {
                                        HStack {
                                            Spacer()
                                            VStack(spacing: 10) {
                                                Image(systemName: "cube.box")
                                                    .font(.system(size: 40))
                                                    .foregroundColor(.gray.opacity(0.5))
                                                
                                                Text("Aucun jeu sélectionné")
                                                    .foregroundColor(.gray)
                                            }
                                            .padding(.vertical, 30)
                                            Spacer()
                                        }
                                        .background(Color(.systemGray6).opacity(0.3))
                                        .cornerRadius(10)
                                        .padding(.horizontal)
                                    } else {
                                        ScrollView {
                                            VStack(spacing: 1) {
                                                ForEach(ArticlesSelected, id: \.idJeuUnitaire) { article in
                                                    HStack(alignment: .center, spacing: 15) {
                                                        VStack(alignment: .leading, spacing: 4) {
                                                            HStack {
                                                                Text("#\(article.idJeuUnitaire)")
                                                                    .font(.system(size: 14, weight: .medium))
                                                                    .foregroundColor(.secondary)
                                                                    .padding(.horizontal, 8)
                                                                    .padding(.vertical, 3)
                                                                    .background(Color.blue.opacity(0.1))
                                                                    .cornerRadius(4)
                                                                
                                                                Text(article.jeu?.nom ?? "Jeu inconnu")
                                                                    .font(.system(size: 16, weight: .bold))
                                                            }
                                                            
                                                            Text("Éditeur: \(article.jeu?.editeur ?? "Inconnu")")
                                                                .font(.system(size: 14))
                                                                .foregroundColor(.secondary)
                                                            
                                                            Text("Prix: \(article.prix, specifier: "%.2f") €")
                                                                .font(.system(size: 14))
                                                                .foregroundColor(.secondary)
                                                        }
                                                        .frame(maxWidth: .infinity, alignment: .leading)
                                                        
                                                        Button(action: {
                                                            if let index = ArticlesSelected.firstIndex(where: { $0.idJeuUnitaire == article.idJeuUnitaire }) {
                                                                ArticlesSelected.remove(at: index)
                                                                if (ArticlesSelected.isEmpty) {
                                                                    self.getJeux = false
                                                                }
                                                            }
                                                        }) {
                                                            Image(systemName: "trash")
                                                                .font(.system(size: 14))
                                                                .foregroundColor(.white)
                                                                .padding(8)
                                                                .background(Color.red)
                                                                .cornerRadius(8)
                                                        }
                                                    }
                                                    .padding(.horizontal, 15)
                                                    .padding(.vertical, 12)
                                                    .background(Color.white)
                                                    Divider()
                                                }
                                            }
                                            .background(Color.white)
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                        }
                                        .frame(height: 200)
                                        .padding(.horizontal)
                                    }
                                }
                                
                                // Section options de retrait
                                VStack(spacing: 20) {
                                    // Toggle pour l'argent
                                    VStack(alignment: .leading, spacing: 6) {
                                        Toggle(isOn: $getArgent) {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Retirer l'argent")
                                                    .font(.headline)
                                                
                                                if getArgent {
                                                    Text("Montant à retirer: \(String(format: "%.2f", vendeurViewModel.vendeur[selectedEmailIndex!].sommeDue)) €")
                                                        .font(.subheadline)
                                                        .foregroundColor(.green)
                                                }
                                            }
                                        }
                                        .toggleStyle(SwitchToggleStyle(tint: Color.green))
                                        .padding()
                                        .background(Color.white.opacity(0.5))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                        )
                                    }
                                    .padding(.horizontal)
                                    .padding(.top, 10)
                                    
                                    // Bouton d'enregistrement
                                    Button(action: {
                                        self.message = ""
                                        if(getArgent || getJeux) {
                                            Task {
                                                let idsJeu : [Int] = ArticlesSelected.map { $0.idJeuUnitaire }
                                                let result : Bool = await retraitViewModel.retraitJeuArgent(
                                                    vendeur: vendeurViewModel.getVendeur(index: self.selectedEmailIndex!),
                                                    listJeu: idsJeu,
                                                    getArgent: self.getArgent
                                                )
                                                if (result) {
                                                    // Définir le message de succès en fonction des options choisies
                                                    if getArgent && !ArticlesSelected.isEmpty {
                                                        self.successMessage = "Retrait de jeux et d'argent réalisé avec succès"
                                                    } else if getArgent {
                                                        self.successMessage = "Retrait d'argent réalisé avec succès"
                                                    } else {
                                                        self.successMessage = "Retrait de jeux réalisé avec succès"
                                                    }
                                                    
                                                    // Activer l'affichage du message de succès
                                                    self.successMessageVisible = true
                                                    
                                                    // Réinitialiser les états
                                                    vendeurViewModel.setEmail(index: self.selectedEmailIndex! , value: "")
                                                    self.selectedEmailIndex = nil
                                                    await vendeurViewModel.searchVendeur(prenom: "", nom: "", email: "", numero: "")
                                                    self.ArticlesSelected = []
                                                    self.message = "réalisé avec succès"
                                                    self.getArgent = false
                                                    self.getJeux = false
                                                } else {
                                                    self.message = "Erreur lors de l'enregistrement"
                                                }
                                            }
                                        } else {
                                            self.message = "Veuillez retirer un jeu ou de l'argent"
                                        }
                                    }) {
                                        Text("Finaliser le retrait")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .frame(height: 55)
                                            .frame(maxWidth: .infinity)
                                            .background(
                                                LinearGradient(gradient: Gradient(colors: [
                                                    (getArgent || getJeux) ? Color.blue : Color.gray,
                                                    (getArgent || getJeux) ? Color.blue.opacity(0.8) : Color.gray.opacity(0.8)
                                                ]),
                                                startPoint: .leading, endPoint: .trailing)
                                            )
                                            .cornerRadius(10)
                                            .shadow(color: (getArgent || getJeux) ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                                    }
                                    .padding(.horizontal)
                                    
                                    // Message de confirmation ou d'erreur
                                    if !message.isEmpty {
                                        Text(message)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(message.contains("succès") ? .green : .red)
                                            .padding(.top, 5)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .padding(.vertical, 15)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.5))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .onAppear {
            Task {
                await vendeurViewModel.searchVendeur(prenom: "", nom: "", email: "", numero: "")
            }
        }
    }
    
    func updateEmailSuggestions(with query: String) {
        guard !query.isEmpty else {
            emailSuggestions = []
            return
        }
        
        emailSuggestions = vendeurViewModel.vendeur
            .filter { $0.email.lowercased().contains(query.lowercased()) }
            .map { $0.email }
    }
    
    func updateArticleSuggestions(with query: String) {
        ArticleSuggestions = retraitViewModel.listJeuUnitaire
            .filter { String($0.idJeuUnitaire).lowercased().contains(query.lowercased()) }
            .filter { selectedJeu in
                !ArticlesSelected.contains(where: { $0.idJeuUnitaire == selectedJeu.idJeuUnitaire })
            }
            .map { String($0.idJeuUnitaire) + " | " + String($0.jeu!.nom)  }
    }
}

struct EnregistrerRetraitView_Previews: PreviewProvider {
    static var previews: some View {
        EnregistrerRetraitView()
    }
}
