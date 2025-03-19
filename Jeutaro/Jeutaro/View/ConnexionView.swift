//
//  WelcomeView.swift
//  Jeutaro
//
//  Created by etud on 12/03/2025.
//

import SwiftUI

struct ConnexionView: View {
    @State private var email : String = ""
    @State private var password : String = ""

    @EnvironmentObject var routeur : Routeur
    @EnvironmentObject var userViewModel : UserViewModel

    var body: some View {
        VStack {
            Spacer()
            Text("Connexion")
                .font(.system(size:40))
                .padding()
            Spacer()
            Text("Email")
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom)
            Text("Mot de passe")
            SecureField("Mot de passe", text: $password)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .textContentType(.password)
                .keyboardType(.default)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom)
            Spacer()
            VStack {
                Button(action: {
                    Task {
                        await userViewModel.login(email: email, password: password)
                    }
                }) {
                    Text("Connexion")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                if !userViewModel.message.isEmpty {
                    Text(userViewModel.message)
                        .foregroundColor(.red)
                        .padding()
                }
            }.frame(maxHeight : 30)
            Spacer()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        ConnexionView()
    }
}
