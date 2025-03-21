//
//  SelectionVendeur.swift
//  Jeutaro
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct SelectionVendeurView: View {
    
    @State private var nom : String = ""
    @State private var prenom : String = ""
    @State private var email : String = ""
    @State private var numero : String = ""
    
    @StateObject var vendeurViewModel : VendeurViewModel
    
    var body: some View {
            VStack  {
                VStack(spacing: 0) {
                    Text("Chercher un vendeur")
                    Text("nom")
                    TextField("nom...", text: $nom)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(height: 35)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    Text("Prénom")
                    TextField("Prénom...", text: $prenom)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(height: 35)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    Text("Email")
                    TextField("Email...", text: $email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .frame(height: 35)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                    Text("Numéro")
                    TextField("Numéro...", text: $numero)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(height: 35)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                VStack {
                    Button(action: {
                        Task {
                            await vendeurViewModel.searchVendeur(prenom: prenom, nom: nom, email: email, numero: numero)
                        }
                    }) {
                        Text("Chercher")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 30)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(vendeurViewModel.vendeur.indices, id: \.self) { index in
                            let vendeur = vendeurViewModel.vendeur[index]
                            UniqueVendeurSelectionView(vendeur: vendeur, idListVendeur: index, vendeurViewModel: vendeurViewModel)
                        }
                    }
                }.frame(maxHeight: .infinity) // Permet à la ScrollView de s'adapter à l'espace disponible
                    .border(Color.black, width: 2)
                    .padding(.top, 8)
                    
                Spacer()
            }
        }
}

struct SelectionVendeur_Previews: PreviewProvider {
    static var previews: some View {
        SelectionVendeurView(vendeurViewModel: VendeurViewModel())
    }
}
