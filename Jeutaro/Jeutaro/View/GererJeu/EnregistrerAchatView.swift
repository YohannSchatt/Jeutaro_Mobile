//
//  EnregistrerAchatView.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import SwiftUI

public struct EnregistrerAchatView: View {
    
    @State private var numeroArticle: Int = 0
    @State private var message: String = ""
    
    @State private var isPaymentConfirmed: Bool = false
    
    @State private var ArticleSuggestions: [String] = []
    @State private var ArticlesSelected: [JeuUnitaire] = []
    
    let jeuUnitaireViewModel: JeuUnitaireViewModel = JeuUnitaireViewModel()
    
    public var body: some View {
        ZStack {
            // Fond avec dégradé
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // En-tête
                    Text("Enregistrer un achat")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 20) {
                        // Section recherche d'article
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Numéro de l'article")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            TextField("Numéro de l'article...", text: Binding(
                                get: { String(numeroArticle) },
                                set: { newValue in
                                    if let intValue = Int(newValue) {
                                        numeroArticle = intValue
                                    }
                                }
                            ))
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                            .onChange(of: String(numeroArticle)) { newValue in
                                updateArticleSuggestions(with: newValue)
                            }
                            
                            // Liste des suggestions
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
                                                if let selectedJeu = jeuUnitaireViewModel.listJeuUnitaire.first(where: { String($0.idJeuUnitaire) == suggestion }) {
                                                    ArticlesSelected.append(selectedJeu)
                                                    ArticleSuggestions = []
                                                    numeroArticle = 0
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
                                .frame(maxHeight: 150)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Section panier
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Panier")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                
                                Spacer()
                                
                                Text("Total: \(String(format: "%.2f", ArticlesSelected.reduce(0) { $0 + $1.prix })) €")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                    )
                            }
                            
                            if ArticlesSelected.isEmpty {
                                HStack {
                                    Spacer()
                                    VStack(spacing: 10) {
                                        Image(systemName: "cart")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray.opacity(0.5))
                                        
                                        Text("Votre panier est vide")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 40)
                                    Spacer()
                                }
                                .background(Color(.systemGray6).opacity(0.3))
                                .cornerRadius(10)
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
                                                    
                                                    Text("État: \(article.etat.rawValue)")
                                                        .font(.system(size: 14))
                                                        .foregroundColor(.secondary)
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Text("\(article.prix, specifier: "%.2f") €")
                                                    .font(.system(size: 16, weight: .bold))
                                                
                                                Button(action: {
                                                    if let index = ArticlesSelected.firstIndex(where: { $0.idJeuUnitaire == article.idJeuUnitaire }) {
                                                        ArticlesSelected.remove(at: index)
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
                                .frame(height: 250)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Section confirmation et paiement
                        VStack(spacing: 20) {
                            // Toggle confirmation paiement
                            Toggle(isOn: $isPaymentConfirmed) {
                                Text("Confirmer que l'argent a été reçu")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                            }
                            .toggleStyle(SwitchToggleStyle(tint: Color.green))
                            .padding(.horizontal)
                            
                            // Bouton d'enregistrement
                            Button(action: {
                                self.message = ""
                                if(isPaymentConfirmed) {
                                    Task {
                                        let idsJeu : [Int] = ArticlesSelected.map { $0.idJeuUnitaire }
                                        let result : Bool = await jeuUnitaireViewModel.enregistrerAchat(listIdJeu: idsJeu)
                                        if (result) {
                                            self.ArticlesSelected = []
                                            self.message = "Achat effectué avec succès"
                                            await jeuUnitaireViewModel.getJeuxUnitaireDisponible()
                                        }
                                        else {
                                            self.message = "Erreur lors de l'achat"
                                        }
                                    }
                                }
                                else {
                                    self.message = "Veuillez confirmer le paiement"
                                }
                            }) {
                                Text("Finaliser l'achat")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(height: 55)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        LinearGradient(gradient: Gradient(colors: [
                                            isPaymentConfirmed ? Color.blue : Color.gray,
                                            isPaymentConfirmed ? Color.blue.opacity(0.8) : Color.gray.opacity(0.8)
                                        ]),
                                        startPoint: .leading, endPoint: .trailing)
                                    )
                                    .cornerRadius(10)
                                    .shadow(color: isPaymentConfirmed ? Color.blue.opacity(0.3) : Color.gray.opacity(0.2), radius: 5, x: 0, y: 5)
                            }
                            .padding(.horizontal)
                            .disabled(ArticlesSelected.isEmpty)
                            .opacity(ArticlesSelected.isEmpty ? 0.6 : 1)
                            
                            // Message de confirmation ou d'erreur
                            if !message.isEmpty {
                                Text(message)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(message.contains("succès") || message.contains("effectué") ? .green : .red)
                                    .padding(.top, 5)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.vertical, 10)
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
                await jeuUnitaireViewModel.getJeuxUnitaireDisponible()
            }
        }
    }
    
    func updateArticleSuggestions(with query: String) {
        guard !query.isEmpty else {
            self.ArticleSuggestions = []
            return
        }
        
        ArticleSuggestions = jeuUnitaireViewModel.listJeuUnitaire
            .filter { String($0.idJeuUnitaire).lowercased().contains(query.lowercased()) }
            .map { String($0.idJeuUnitaire) }
    }
}

struct EnregistrerAchatView_Previews: PreviewProvider {
    static var previews: some View {
        EnregistrerAchatView()
    }
}