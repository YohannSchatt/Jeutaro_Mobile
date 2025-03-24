//
//  UniqueGestionnaireView.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

struct UniqueGestionnaireView: View {
    
    let user: User
    
    let idListGestionnaire : Int
    
    let gestionnaireViewModel : GestionnaireViewModel
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack {
                    Text(user.getNom())
                    Text(user.getPrenom())
                }
                Text(user.getEmail())
            }
            Spacer()
            Button(action: {
                Task {
                    let result : Bool = await gestionnaireViewModel.deleteGestionnaire(email: user.getEmail())
                    if (result) {
                        gestionnaireViewModel.filterGestionnaire(nom: user.getNom(), prenom: user.getPrenom(), email: user.getEmail())
                    }
                }
            }) {
                Text("Supprimer")
                    .foregroundColor(.white)
                    .frame(width: 110, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }.border(Color.black, width: 2)
    }
}

struct UniqueGestionnaireView_Previews: PreviewProvider {
    static var previews: some View {
        UniqueGestionnaireView(user: User(nom: "Test", prenom: "Test2", email: "Test@example.co", role: .GESTIONNAIRE), idListGestionnaire: 0, gestionnaireViewModel: GestionnaireViewModel())
    }
}
