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
        VStack {
            Spacer()
            VStack {
                Text("Enregistrer un achat").font(.system(size: 20))
                Spacer().frame(maxHeight: 20)
                
                VStack {
                    Text("Numéro de l'article")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("numéro de l'article...", text: Binding(
                        get: {
                            String(numeroArticle)
                        },
                        set: { newValue in
                            if let intValue = Int(newValue) {
                                numeroArticle = intValue
                            }
                        }
                    ))
                    .frame(height: 50)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .onChange(of: String(numeroArticle)) { newValue in
                        updateArticleSuggestions(with: newValue)
                    }
                    
                    
                    if !ArticleSuggestions.isEmpty {
                        List(ArticleSuggestions, id: \.self) { suggestion in
                            Text(suggestion)
                                .onTapGesture {
                                    if let selectedJeu = jeuUnitaireViewModel.listJeuUnitaire.first(where: { String($0.idJeuUnitaire) == suggestion }) {
                                        ArticlesSelected.append(selectedJeu)
                                        ArticleSuggestions = []
                                        numeroArticle = 0
                                    }
                                }
                        }
                        .frame(height: 100)
                    }
                    Spacer().frame(maxHeight: 30)
                    Text("Panier")
                    List {
                        ForEach(ArticlesSelected, id: \.idJeuUnitaire) { article in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("ID: \(article.idJeuUnitaire)")
                                    Text("Nom: \(article.jeu!.nom)")
                                    Text("Éditeur: \(article.jeu!.editeur)")
                                    Text("Prix: \(article.prix, specifier: "%.2f") €")
                                }
                                Spacer()
                                Button(action: {
                                    if let index = ArticlesSelected.firstIndex(where: { $0.idJeuUnitaire == article.idJeuUnitaire }) {
                                        ArticlesSelected.remove(at: index)
                                    }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .frame(height: 200)
                }.padding()
                
                VStack {
                    
                    Toggle(isOn: $isPaymentConfirmed) {
                        Text("Confirmer que l'argent a été reçu")
                            .font(.body)
                    }
                    .padding()
                    
                    Button(action: {
                        self.message = ""
                        if(isPaymentConfirmed) {
                            Task {
                                let idsJeu : [Int] = ArticlesSelected.map { $0.idJeuUnitaire }
                                let result : Bool = await jeuUnitaireViewModel.enregistrerAchat(listIdJeu: idsJeu)
                                if (result) {
                                    self.ArticlesSelected = []
                                    self.message = "Achat effectué"
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
                        Text("Enregistrer")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(isPaymentConfirmed ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    Text(self.message)
                }
            }
            Spacer()
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

