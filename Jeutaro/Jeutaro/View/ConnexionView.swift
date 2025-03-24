//
//  ConnexionView.swift
//  Jeutaro
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct ConnexionView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    @EnvironmentObject var routeur: Routeur
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        ZStack {
            // Fond avec dégradé
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.white]),
                           startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // En-tête
                VStack(spacing: 5) {
                    Text("Bienvenue")
                        .font(.system(size: 26, weight: .light))
                        .foregroundColor(.secondary)
                    
                    Text("Connexion")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.primary)
                }
                .padding(.top, 40)
                
                Spacer(minLength: 20)
                
                // Formulaire
                VStack(alignment: .leading, spacing: 25) {
                    // Email field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Email")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        TextField("", text: $email)
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
                    
                    // Mot de passe field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mot de passe")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        SecureField("", text: $password)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .textContentType(.password)
                            .keyboardType(.default)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 25)
                
                Spacer(minLength: 40)
                
                // Bouton et message
                VStack(spacing: 20) {
                    Button(action: {
                        Task {
                            await userViewModel.login(email: email, password: password)
                        }
                    }) {
                        Text("Se connecter")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                               startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(10)
                            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0, y: 10)
                    }
                    .padding(.horizontal, 25)
                    
                    if !userViewModel.message.isEmpty {
                        Text(userViewModel.message)
                            .font(.subheadline)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
            }
        }
    }
}

struct ConnexionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnexionView()
            .environmentObject(Routeur())
            .environmentObject(UserViewModel(routeur: Routeur()))
    }
}