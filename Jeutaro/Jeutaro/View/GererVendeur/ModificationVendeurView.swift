//
//  ModificationVendeur.swift
//  Jeutaro
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct ModificationVendeurView : View {
    
    @State private var nom : String = ""
    @State private var prenom : String = ""
    @State private var email : String = ""
    @State private var numero : String = ""
    
    @StateObject var vendeurViewModel : VendeurViewModel
    
    var body: some View {
        VStack  {
            VStack(spacing: 0) {
                if (vendeurViewModel.idVendeurSelected == -1) {
                    Text("Créer un vendeur")
                }
                else {
                    Text("Modifier un vendeur")
                }
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
                            await vendeurViewModel.createOrUpdateVendeur(nom: nom, prenom: prenom, email: email, numero: numero)
                        }
                    }) {
                        if (vendeurViewModel.idVendeurSelected == -1) {
                            Text("Créer")
                                .foregroundColor(.white)
                                .frame(width: 200, height: 30)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        else {
                            Text("Mettre à jour")
                                .foregroundColor(.white)
                                .frame(width: 200, height: 30)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                }
            }
            .onChange(of: vendeurViewModel.idVendeurSelected) { newIndex in
                if newIndex != -1, newIndex < vendeurViewModel.vendeur.count {
                    let selected = vendeurViewModel.vendeur[newIndex]
                    nom = selected.nom
                    prenom = selected.prenom
                    email = selected.email
                    numero = selected.numero
                } else {
                    // Réinitialiser les champs si aucune sélection n’est effectuée
                    nom = ""
                    prenom = ""
                    email = ""
                    numero = ""
                }
            }
        }
    }   
}

struct ModificationVendeur_Previews: PreviewProvider {
    static var previews: some View {
        ModificationVendeurView(vendeurViewModel: VendeurViewModel())
    }
}
