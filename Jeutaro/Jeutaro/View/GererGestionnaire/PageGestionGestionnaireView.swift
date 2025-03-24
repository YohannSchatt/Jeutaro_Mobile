//
//  PageGestionGestionnaire.swift
//  Jeutaro
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

struct PageGestionGestionnaireView: View {
    
    let gestionnaireViewModel : GestionnaireViewModel = GestionnaireViewModel()
    
    var body: some View {
        VStack {
            Spacer()
            CreationGestionnaireView(gestionnaireViewModel: gestionnaireViewModel)
            Divider()
                .frame(width: 350)
                .background(Color.gray)
            DeleteGestionnaireView(gestionnaireViewModel: gestionnaireViewModel)
            Spacer()
        }
        .padding()
    }
}

struct PageGestionGestionnaire_Previews: PreviewProvider {
    static var previews: some View {
        PageGestionGestionnaireView()
    }
}
