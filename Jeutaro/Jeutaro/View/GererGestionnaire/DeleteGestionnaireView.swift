//
//  DeleteGestionnaire.swift
//  Jeutaro
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

struct DeleteGestionnaireView: View {
    
    @State var nom: String = ""
    @State var prenom: String = ""
    @State var email: String = ""
    
    @ObservedObject var gestionnaireViewModel: GestionnaireViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Titre de section
            Text("Rechercher un gestionnaire")
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
            
            // Bouton de recherche
            Button(action: {
                gestionnaireViewModel.filterGestionnaire(nom: nom, prenom: prenom, email: email)
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
            .padding(.vertical, 10)
            
            // Liste des résultats
            VStack(spacing: 0) {
                if gestionnaireViewModel.listfilterGestionnaire.isEmpty {
                    Text("Aucun gestionnaire trouvé")
                        .foregroundColor(.secondary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6).opacity(0.5))
                        .cornerRadius(10)
                } else {
                    ScrollView {
                        VStack(spacing: 1) {
                            ForEach(gestionnaireViewModel.listfilterGestionnaire.indices, id: \.self) { index in
                                UniqueGestionnaireView(user: gestionnaireViewModel.listfilterGestionnaire[index], idListGestionnaire: index, gestionnaireViewModel: gestionnaireViewModel)
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .frame(maxHeight: 300)
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            Task {
                await gestionnaireViewModel.getGestionnaire()
            }
            gestionnaireViewModel.filterGestionnaire(nom: nom, prenom: prenom, email: email)
        }
        .padding(.vertical, 10)
    }
}

struct DeleteGestionnaire_Previews: PreviewProvider {
    static var previews: some View {
        DeleteGestionnaireView(gestionnaireViewModel: GestionnaireViewModel())
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.1))
    }
}