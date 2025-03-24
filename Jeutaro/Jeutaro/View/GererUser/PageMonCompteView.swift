//
//  PageMonCompteView.swift
//  Jeutaro
//
//  Created by etud on 24/03/2025.
//

import SwiftUI

struct PageMonCompteView: View {
    var body: some View {
        VStack {
            Spacer()
            ModifInfoView()
            Divider()
                .frame(width: 350)
                .background(Color.gray)
            ModifMotDePasseView()
            Spacer()
        }
        .padding()
    }
}

struct PageMonCompteView_Previews: PreviewProvider {
    static var previews: some View {
        PageMonCompteView()
    }
}
