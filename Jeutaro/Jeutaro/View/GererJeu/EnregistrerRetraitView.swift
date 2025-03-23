//
//  EnregistrerRetraitView.swift
//  Jeutaro
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

struct EnregistrerRetraitView: View {
    
    @State var email: String = ""
    @State private var numeroArticle: String = ""
    
    @State private var emailSuggestions: [String] = []
    @State private var ArticleSuggestions: [String] = []
    
    @State private var selectedEmailIndex: Int? = nil
    @State private var ArticlesSelected: [JeuUnitaire] = []
    
    @State private var getArgent : Bool = false
    @State private var getJeux : Bool = false
    
    @State private var message : String = ""
    
    let retraitViewModel : RetraitViewModel = RetraitViewModel()
    let vendeurViewModel : VendeurViewModel = VendeurViewModel()
    
    var body: some View {
        VStack{
            Text("Enregister un dépot").font(.system(size:20))
            Spacer().frame(maxHeight: 20)
            
            VStack{
                
                HStack {
                    
                    Spacer()
                    
                    if(selectedEmailIndex == nil) {
                        
                        TextField("email du vendeur...", text: $email)
                            .frame(height:50)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                            .onChange(of: email) { newValue in
                                if selectedEmailIndex == nil {
                                    updateEmailSuggestions(with: newValue)
                                }
                            }
                    }
                    else {
                        VStack(spacing: 1){
                            Text("Email vendeur sélectionné : " + vendeurViewModel.vendeur[self.selectedEmailIndex!].email)
                            HStack{
                                Spacer()
                                Text("Nom : " + vendeurViewModel.vendeur[self.selectedEmailIndex!].nom)
                                Spacer()
                                Text("Prenom : " + vendeurViewModel.vendeur[self.selectedEmailIndex!].prenom)
                                Spacer()
                            }
                        }
                    }
                    
                    Spacer()
                    
                    if selectedEmailIndex != nil {
                        Button(action: {
                            email = ""
                            selectedEmailIndex = nil
                            emailSuggestions = []
                            ArticlesSelected = []
                            numeroArticle = ""
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                    Spacer()
                }
                
                if !emailSuggestions.isEmpty || self.selectedEmailIndex == nil {
                    List(emailSuggestions, id: \.self) { suggestion in
                        Text(suggestion)
                            .onTapGesture {
                                email = suggestion
                                selectedEmailIndex = emailSuggestions.firstIndex(of: suggestion)
                                emailSuggestions = []
                                Task {
                                    await retraitViewModel.getJeuVendeur(vendeur: vendeurViewModel.vendeur[selectedEmailIndex!])
                                }
                            }
                    }
                    .frame(height: 100)
                }
            }.padding()
            
            if selectedEmailIndex != nil {
                VStack {
                    Text("Numéro de l'article")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("numéro de l'article...", text: $numeroArticle)
                    .frame(height: 50)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .onChange(of: String(numeroArticle)) { newValue in
                        updateArticleSuggestions(with: newValue)
                    }
                    
                    
                    List(ArticleSuggestions, id: \.self) { suggestion in
                        Text(suggestion)
                            .onTapGesture {
                                let suggestionParts = suggestion.split(separator: "|")
                                let suggestionIdString = suggestionParts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                                if let suggestionId = Int(suggestionIdString) {
                                    if let selectedJeu = retraitViewModel.listJeuUnitaire.first(where: { $0.idJeuUnitaire == suggestionId }) {
                                        ArticlesSelected.append(selectedJeu)
                                        numeroArticle = ""
                                        updateArticleSuggestions(with: numeroArticle)
                                        getJeux = true
                                    }
                                }
                            }
                    }.frame(height: 100)
                    
                    Spacer().frame(height: 30)
                    
                    Text("Jeu à retirer")
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
                                        if (ArticlesSelected.isEmpty) {
                                            self.getJeux = false
                                        }
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
                
                Spacer()
                
                VStack {
                    VStack {
                        Toggle(isOn: $getArgent) {
                            Text("Confirmer que l'argent a été reçu")
                                .font(.body)
                        }
                        .padding()
                        Text("le vendeur a \(vendeurViewModel.vendeur[selectedEmailIndex!].sommeDue, specifier: "%.2f")")
                    }
                    
                    Button(action: {
                        self.message = ""
                        if(getArgent || getJeux) {
                            Task {
                                let idsJeu : [Int] = ArticlesSelected.map { $0.idJeuUnitaire }
                                let result : Bool = await retraitViewModel.retraitJeuArgent(vendeur: &vendeurViewModel.vendeur[self.selectedEmailIndex!], listJeu: idsJeu, getArgent: self.getArgent)
                                if (result) {
                                    self.ArticlesSelected = []
                                    self.message = "réalisé avec succès"
                                    
                                }
                                else {
                                    self.message = "Erreur lors de l'enregistrement"
                                }
                            }
                        }
                        else {
                            self.message = "Veuillez retirer un jeu ou de l'argent"
                        }
                    }) {
                        Text("Enregistrer")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(getArgent || getJeux ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                    Text(self.message)
                }
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
