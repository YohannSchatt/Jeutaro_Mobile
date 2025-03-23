//
//  EnregistrerDepot.swift
//  Jeutaro
//
//  Created by etud on 22/03/2025.
//

import SwiftUI

struct EnregistrerDepotView: View {
    
    @State var email: String = ""
    @State var nom: String = ""
    @State var prix: Float = 0
    
    @State private var selectedEtat: Etat = .NEUF
    
    @State private var emailSuggestions: [String] = []
    @State private var nomSuggestions: [String] = []
    
    @State private var selectedEmailIndex: Int? = nil
    @State private var selectedNomIndex: Int? = nil
    
    @State private var message : String = ""
    
    let jeuxViewModel: JeuxViewModel = JeuxViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Enregister un dépot").font(.system(size:20))
                Spacer().frame(maxHeight: 20)
                
                VStack {
                    Text("Email du vendeur")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("email du vendeur...", text: $email)
                        .frame(height:50)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .onChange(of: email) { newValue in
                            updateEmailSuggestions(with: newValue)
                        }
                    
                    if !emailSuggestions.isEmpty {
                        List(emailSuggestions, id: \.self) { suggestion in
                            Text(suggestion)
                                .onTapGesture {
                                    email = suggestion
                                    selectedEmailIndex = emailSuggestions.firstIndex(of: suggestion)
                                    emailSuggestions = []
                                }
                        }
                        .frame(height: 100)
                    }
                }.padding()
                
                VStack {
                    Text("Nom du jeu")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("Nom du jeu...", text: $nom)
                        .frame(height:50)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .onChange(of: nom) { newValue in
                            updateNomSuggestions(with: newValue)
                        }
                    
                    if !nomSuggestions.isEmpty {
                        List(nomSuggestions, id: \.self) { suggestion in
                            Text(suggestion)
                                .onTapGesture {
                                    nom = suggestion
                                    selectedNomIndex = nomSuggestions.firstIndex(of: suggestion)
                                    nomSuggestions = []
                                }
                        }
                        .frame(height: 100)
                    }
                }.padding()
                
                HStack {
                    Spacer().frame(maxWidth: 20)
                    Text("Etat")
                    Picker("Etat", selection: $selectedEtat) {
                        ForEach(Etat.allCases) { etat in
                            Text(etat.rawValue).tag(etat)
                        }
                    }
                    Spacer()
                }
                .pickerStyle(MenuPickerStyle())
                
                VStack {
                    Text("Prix")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    TextField("prix", text: Binding(
                        get: {
                            String(prix)
                        },
                        set: { newValue in
                            if let floatValue = Float(newValue) {
                                prix = floatValue
                            }
                        }
                    ))
                    .frame(height: 50)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .padding()
            }
            VStack {
                Button(action: {
                    if (self.selectedNomIndex == nil || self.selectedEmailIndex == nil) {
                        self.message = "Veuillez sélectionner un vendeur et un jeu"
                    } else {
                        Task {
                            let result : Bool = await jeuxViewModel.createJeuUnitaire(idJeu: jeuxViewModel.jeuxDB[self.selectedNomIndex!].idJeu,
                                                                  idVendeur: jeuxViewModel.vendeurDB[self.selectedEmailIndex!].idVendeur,
                                                                  etat: self.selectedEtat,
                                                                  prix: self.prix)
                            if (result) {
                                self.message = "Ajout avec succès"
                            }
                            else {
                                self.message = "Erreur dans l'ajout"
                            }
                        }
                    }
                }) {
                    Text("Créer")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Text(self.message)
            }
            Spacer()
        }
    }
    
    func updateEmailSuggestions(with query: String) {
        guard !query.isEmpty else {
            emailSuggestions = []
            return
        }
        
        emailSuggestions = jeuxViewModel.vendeurDB
            .filter { $0.email.lowercased().contains(query.lowercased()) }
            .map { $0.email }
    }
    
    func updateNomSuggestions(with query: String) {
        guard !query.isEmpty else {
            nomSuggestions = []
            return
        }
        
        nomSuggestions = jeuxViewModel.jeuxDB
            .filter { $0.nom.lowercased().contains(query.lowercased()) }
            .map { $0.nom }
    }
}

struct EnregistrerDepot_Previews: PreviewProvider {
    static var previews: some View {
        EnregistrerDepotView()
    }
}
