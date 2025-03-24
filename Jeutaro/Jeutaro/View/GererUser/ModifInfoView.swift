//
//  ModifInfoView.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

struct ModifInfoView: View {
    @State var message: String = ""
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Titre de section
            Text("Informations personnelles")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .padding(.top, 5)
                .padding(.horizontal)
            
            // Champ Nom
            VStack(alignment: .leading, spacing: 8) {
                Text("Nom")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                TextField("", text: $userViewModel.nom)
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
                
                TextField("", text: $userViewModel.prenom)
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
                
                TextField("", text: $userViewModel.email)
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
                        let result = await userViewModel.modifInfo()
                        self.message = result ? "Modification réussie" : "Erreur lors de la modification"
                    }
                }) {
                    Text("Enregistrer les modifications")
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
                }
            }
            .padding(.vertical)
        }
        .padding(.vertical, 10)
    }
}

struct ModifInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ModifInfoView()
            .environmentObject(UserViewModel(routeur: Routeur()))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.1))
    }
}