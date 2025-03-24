//
//  ModifInfoView.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

struct ModifInfoView: View {
    
    @State var oldPassword = ""
    
    @State var newPassword = ""
    
    @State var newPasswordConfirmation = ""
    
    @State var message : String = ""
    
    @EnvironmentObject var userViewModel : UserViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("Modification information")
                    .font(.system(size:20))
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                VStack(spacing: 8) {
                    Text("Nom")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("nom...", text: $userViewModel.nom)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(height: 40)
                        .padding(.horizontal)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    Text("Prenom")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("prenom...", text: $userViewModel.prenom)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(height: 40)
                        .padding(.horizontal)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    Text("Email")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("email...", text: $userViewModel.email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .frame(height: 40)
                        .padding(.horizontal)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 16)
            }
            VStack {
                Button(action: {
                    Task {
                        let result : Bool = await userViewModel.modifInfo()
                        self.message = result ? "Modification réussie" : "Erreur lors de la modification"
                    }
                }) {
                    Text("Enregistrer")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 16)
                Text(self.message)
                    .font(.footnote)
                    .foregroundColor(self.message.contains("réussi") ? .green : .red)
                    .padding(.top, 8)
            }
        }
        .padding()
    }
}

struct ModifInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ModifInfoView()
    }
}
