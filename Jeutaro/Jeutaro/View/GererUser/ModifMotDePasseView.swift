//
//  ModifMotDePasseView.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

struct ModifMotDePasseView: View {
    @State var oldPassword = ""
    @State var newPassword = ""
    @State var newPasswordConfirmation = ""
    @State var message: String = ""
    
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Titre de section
            Text("Modifier le mot de passe")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .padding(.top, 5)
                .padding(.horizontal)
            
            // Champ Ancien mot de passe
            VStack(alignment: .leading, spacing: 8) {
                Text("Mot de passe actuel")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                SecureField("", text: $oldPassword)
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
            
            // Champ Nouveau mot de passe
            VStack(alignment: .leading, spacing: 8) {
                Text("Nouveau mot de passe")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                SecureField("", text: $newPassword)
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
            
            // Champ Confirmation
            VStack(alignment: .leading, spacing: 8) {
                Text("Confirmer le nouveau mot de passe")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                SecureField("", text: $newPasswordConfirmation)
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
            
            // Bouton et message
            VStack(spacing: 10) {
                Button(action: {
                    Task {
                        let result = await userViewModel.modifPassword(oldPassword: oldPassword, newPassword: newPassword, confirmation: newPasswordConfirmation)
                        self.message = result ? "Modification réussie" : "Erreur lors de la modification"
                    }
                }) {
                    Text("Changer le mot de passe")
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

struct ModifMotDePasseView_Previews: PreviewProvider {
    static var previews: some View {
        ModifMotDePasseView()
            .environmentObject(UserViewModel(routeur: Routeur()))
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.1))
    }
}