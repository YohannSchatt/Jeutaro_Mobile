//
//  PageGestionGestionnaire.swift
//  Jeutaro
//
//  Created by etud on 23/03/2025.
//

import SwiftUI

struct PageGestionGestionnaireView: View {
    var body: some View {
        VStack {
            Spacer()
            CreationGestionnaireView()
            Spacer()
            DeleteGestionnaire()
            Spacer()
        }
    }
}

struct PageGestionGestionnaire_Previews: PreviewProvider {
    static var previews: some View {
        PageGestionGestionnaireView()
    }
}
