//
//  ModificationVendeur.swift
//  Jeutaro
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct ModificationVendeurView: View {
    
    @State private var nom: String = ""
    @State private var prenom: String = ""
    @State private var email: String = ""
    @State private var numero: String = ""
    
    @StateObject var vendeurViewModel: VendeurViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Titre de section
            HStack {
                if (vendeurViewModel.idVendeurSelected == -1) {
                    Text("Créer un vendeur")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                }
                else {
                    Text("Modifier un vendeur")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                if vendeurViewModel.idVendeurSelected != -1 {
                    Button(action: {
                        vendeurViewModel.setIdVendeurSelected(index: -1)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.top, 5)
            .padding(.horizontal)
            
            // Champ Nom
            VStack(alignment: .leading, spacing: 8) {
                Text("Nom")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                TextField("Nom...", text: $nom)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            // Champ Prénom
            VStack(alignment: .leading, spacing: 8) {
                Text("Prénom")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                TextField("Prénom...", text: $prenom)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            // Champ Email
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                TextField("Email...", text: $email)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            // Champ Numéro
            VStack(alignment: .leading, spacing: 8) {
                Text("Numéro")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                TextField("Numéro...", text: $numero)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            // Bouton d'action
            Button(action: {
                Task {
                    await vendeurViewModel.createOrUpdateVendeur(nom: nom, prenom: prenom, email: email, numero: numero)
                }
            }) {
                Text(vendeurViewModel.idVendeurSelected == -1 ? "Créer" : "Mettre à jour")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(10)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 5)
            }
            .padding(.horizontal)
            .padding(.top, 5)
            .padding(.bottom, 10)
        }
        .onChange(of: vendeurViewModel.idVendeurSelected) { newIndex in
            if newIndex != -1, newIndex < vendeurViewModel.vendeur.count {
                let selected = vendeurViewModel.vendeur[newIndex]
                nom = selected.nom
                prenom = selected.prenom
                email = selected.email
                numero = selected.numero
            } else {
                // Réinitialiser les champs si aucune sélection n'est effectuée
                nom = ""
                prenom = ""
                email = ""
                numero = ""
            }
        }
        .padding(.vertical, 10)
    }   
}

struct ModificationVendeur_Previews: PreviewProvider {
    static var previews: some View {
        ModificationVendeurView(vendeurViewModel: VendeurViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.1))
    }
}