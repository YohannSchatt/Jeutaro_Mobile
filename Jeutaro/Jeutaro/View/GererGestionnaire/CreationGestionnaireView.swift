//
//  CreationGestionnaireView.swift
//  Jeutaro
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

struct CreationGestionnaireView: View {
    
    @State var nom: String = ""
    @State var prenom: String = ""
    @State var email: String = ""
    
    @State var message: String = ""
    
    @ObservedObject var gestionnaireViewModel: GestionnaireViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Titre de section
            Text("Création d'un gestionnaire")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 5)
            
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
                    .padding(.horizontal)
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
                    .padding(.horizontal)
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
                    .padding(.horizontal)
            }
            .padding(.horizontal)
            
            // Bouton et message
            VStack(spacing: 10) {
                Button(action: {
                    Task {
                        let result: Bool = await gestionnaireViewModel.createGestionnaire(nom: nom, prenom: prenom, email: email)
                        message = result ? "Création réussie" : "Erreur lors de la création"
                    }
                }) {
                    Text("Créer")
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
                
                if !message.isEmpty {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(message.contains("réussi") ? .green : .red)
                        .padding(.top, 5)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .padding(.vertical)
        }
        .padding(.vertical, 10)
    }
}


struct CreationGestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        CreationGestionnaireView(gestionnaireViewModel: GestionnaireViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.1))
    }
}