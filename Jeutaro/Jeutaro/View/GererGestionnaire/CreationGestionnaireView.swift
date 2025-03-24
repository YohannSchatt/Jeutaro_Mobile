//
//  CreationGestionnaireView.swift
//  Jeutaro
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

struct CreationGestionnaireView: View {
    
    @State var nom : String = ""
    @State var prenom : String = ""
    @State var email : String = ""
    
    @State var message : String = ""
    
    @ObservedObject var gestionnaireViewModel : GestionnaireViewModel
    
    var body: some View {
        VStack {
            VStack(spacing: 8) {
                Text("Création d'un gestionnaire")
                    .font(.system(size:20))
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                VStack(spacing: 8) {
                    Text("Nom")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Nom...", text: $nom)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(height: 40)
                        .padding(.horizontal)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    Text("Prénom")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Prénom...", text: $prenom)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(height: 40)
                        .padding(.horizontal)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    Text("Email")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    TextField("Email...", text: $email)
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
                        let result : Bool = await gestionnaireViewModel.createGestionnaire(nom: self.nom, prenom: self.prenom, email: self.email)
                        self.message = result ? "Création réussie" : "Erreur lors de la création"
                    }
                }) {
                    Text("Créer")
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


struct CreationGestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        CreationGestionnaireView(gestionnaireViewModel: GestionnaireViewModel())
    }
}
