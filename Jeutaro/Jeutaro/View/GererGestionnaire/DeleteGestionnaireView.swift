//
//  DeleteGestionnaire.swift
//  Jeutaro
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

struct DeleteGestionnaireView: View {
    
    @State var nom : String = ""
    @State var prenom : String = ""
    @State var email : String = ""
    
    @ObservedObject var gestionnaireViewModel : GestionnaireViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 8) {
                    Text("Chercher un gestionnaire")
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
                        gestionnaireViewModel.filterGestionnaire(nom: self.nom, prenom: self.prenom, email: self.email)
                    }) {
                        Text("Chercher")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 16)
                }
                
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(gestionnaireViewModel.listfilterGestionnaire.indices, id: \.self) { index in
                            UniqueGestionnaireView(user: gestionnaireViewModel.listfilterGestionnaire[index], idListGestionnaire: index, gestionnaireViewModel: gestionnaireViewModel)
                        }
                    }
                }
                .frame(maxHeight: .infinity)
                .border(Color.black, width: 2)
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                Spacer()
            }
            .onAppear {
                Task {
                    await gestionnaireViewModel.getGestionnaire()
                }
                gestionnaireViewModel.filterGestionnaire(nom: self.nom, prenom: self.prenom, email: self.email)
            }
            .padding()
        }
    }
}

struct DeleteGestionnaire_Previews: PreviewProvider {
    static var previews: some View {
        DeleteGestionnaireView(gestionnaireViewModel: GestionnaireViewModel())
    }
}
