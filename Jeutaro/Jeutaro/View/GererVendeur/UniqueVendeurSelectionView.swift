//
//  UniqueVendeurSelectionView.swift
//  Jeutaro
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct UniqueVendeurSelectionView: View {
    
    let vendeur : Vendeur
    
    let idListVendeur : Int
    
    let vendeurViewModel : VendeurViewModel
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack {
                    Text(vendeur.nom)
                    Text(vendeur.prenom)
                }
                Text(vendeur.numero)
                Text(vendeur.email)
            }
            Spacer()
            Button(action: {
                Task {
                    vendeurViewModel.setIdVendeurSelected(index: self.idListVendeur)
                }
            }) {
                Text("Sélectionner")
                    .foregroundColor(.white)
                    .frame(width: 110, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }.border(Color.black, width: 2)
    }
}

struct UniqueVendeurSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        UniqueVendeurSelectionView(vendeur : Vendeur(idVendeur: 1, prenom: "Paul", nom: "Merle", email: "paul@example.com", numero: "0606060606"), idListVendeur : 0, vendeurViewModel: VendeurViewModel())
    }
}
