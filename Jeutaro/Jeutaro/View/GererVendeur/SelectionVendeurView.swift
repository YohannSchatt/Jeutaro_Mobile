//
//  SelectionVendeur.swift
//  Jeutaro
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct SelectionVendeurView: View {
    
    @State private var nom: String = ""
    @State private var prenom: String = ""
    @State private var email: String = ""
    @State private var numero: String = ""
    
    @StateObject var vendeurViewModel: VendeurViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Titre de section
            Text("Rechercher un vendeur")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 5)
            
            // Formulaire de recherche
            VStack(spacing: 15) {
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
            }
            .padding(.horizontal)
            
            // Bouton de recherche
            Button(action: {
                Task {
                    await vendeurViewModel.searchVendeur(prenom: prenom, nom: nom, email: email, numero: numero)
                }
            }) {
                Text("Rechercher")
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
            
            // Résultats de recherche
            VStack(spacing: 0) {
                if vendeurViewModel.vendeur.isEmpty {
                    Text("Aucun vendeur trouvé")
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6).opacity(0.5))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                } else {
                    ScrollView {
                        VStack(spacing: 1) {
                            ForEach(vendeurViewModel.vendeur.indices, id: \.self) { index in
                                let vendeur = vendeurViewModel.vendeur[index]
                                UniqueVendeurSelectionView(vendeur: vendeur, idListVendeur: index, vendeurViewModel: vendeurViewModel)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }
                    .frame(maxHeight: 300)
                    .padding(.vertical, 10)
                }
            }
        }
        .padding(.vertical, 10)
    }
}

struct SelectionVendeur_Previews: PreviewProvider {
    static var previews: some View {
        SelectionVendeurView(vendeurViewModel: VendeurViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.1))
    }
}