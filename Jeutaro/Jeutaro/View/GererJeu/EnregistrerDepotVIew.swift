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
    
    @State private var message: String = ""
    
    let jeuxViewModel: JeuxViewModel = JeuxViewModel()
    
    var body: some View {
        ZStack {
            // Fond avec dégradé
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // En-tête
                    Text("Enregistrer un dépôt")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                    
                    // Contenu principal
                    VStack(spacing: 25) {
                        // Section Email du vendeur
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email du vendeur")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            TextField("Email du vendeur...", text: $email)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                                .onChange(of: email) { newValue in
                                    updateEmailSuggestions(with: newValue)
                                }
                            
                            if !emailSuggestions.isEmpty {
                                ScrollView {
                                    VStack(spacing: 0) {
                                        ForEach(emailSuggestions, id: \.self) { suggestion in
                                            HStack {
                                                Text(suggestion)
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal, 15)
                                                Spacer()
                                            }
                                            .contentShape(Rectangle())
                                            .background(Color.white)
                                            .onTapGesture {
                                                email = suggestion
                                                selectedEmailIndex = emailSuggestions.firstIndex(of: suggestion)
                                                emailSuggestions = []
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
                        
                        // Section Nom du jeu
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nom du jeu")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            TextField("Nom du jeu...", text: $nom)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                )
                                .onChange(of: nom) { newValue in
                                    updateNomSuggestions(with: newValue)
                                }
                            
                            if !nomSuggestions.isEmpty {
                                ScrollView {
                                    VStack(spacing: 0) {
                                        ForEach(nomSuggestions, id: \.self) { suggestion in
                                            HStack {
                                                Text(suggestion)
                                                    .padding(.vertical, 10)
                                                    .padding(.horizontal, 15)
                                                Spacer()
                                            }
                                            .contentShape(Rectangle())
                                            .background(Color.white)
                                            .onTapGesture {
                                                nom = suggestion
                                                selectedNomIndex = nomSuggestions.firstIndex(of: suggestion)
                                                nomSuggestions = []
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
                        
                        // Section État
                        VStack(alignment: .leading, spacing: 8) {
                            Text("État du jeu")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            Picker("État", selection: $selectedEtat) {
                                ForEach(Etat.allCases) { etat in
                                    Text(etat.rawValue).tag(etat)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal)
                        
                        // Section Prix
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Prix")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            TextField("Prix", text: Binding(
                                get: { String(prix) },
                                set: { newValue in
                                    if let floatValue = Float(newValue) {
                                        prix = floatValue
                                    }
                                }
                            ))
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal)
                        
                        // Bouton de création
                        VStack(spacing: 10) {
                            Button(action: {
                                if (self.selectedNomIndex == nil || self.selectedEmailIndex == nil) {
                                    self.message = "Veuillez sélectionner un vendeur et un jeu"
                                } else {
                                    Task {
                                        let result: Bool = await jeuxViewModel.createJeuUnitaire(
                                            idJeu: jeuxViewModel.jeuxDB[self.selectedNomIndex!].idJeu,
                                            idVendeur: jeuxViewModel.vendeurDB[self.selectedEmailIndex!].idVendeur,
                                            etat: self.selectedEtat,
                                            prix: self.prix
                                        )
                                        if (result) {
                                            self.message = "Ajout avec succès"
                                        } else {
                                            self.message = "Erreur dans l'ajout"
                                        }
                                    }
                                }
                            }) {
                                Text("Enregistrer le dépôt")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(height: 55)
                                    .frame(maxWidth: .infinity)
                                    .background(
                                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                                     startPoint: .leading, endPoint: .trailing)
                                    )
                                    .cornerRadius(10)
                                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 5)
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                            
                            if !message.isEmpty {
                                Text(message)
                                    .font(.subheadline)
                                    .foregroundColor(message.contains("succès") ? .green : .red)
                                    .padding(.top, 5)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white.opacity(0.5))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    )
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
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