//
//  PageVendeurView.swift
//  Jeutaro
//
//  Created by etud on 20/03/2025.
//

import SwiftUI

struct PageVendeurView: View {
    
    let vendeurViewModel : VendeurViewModel = VendeurViewModel()
    
    var body: some View {
        VStack(spacing: 1) {
            ModificationVendeurView(vendeurViewModel: vendeurViewModel)
            
            Divider()
                .frame(width: 350)
                .background(Color.gray)
            
            SelectionVendeurView(vendeurViewModel: vendeurViewModel)
        }
    }
}

struct PageVendeurView_Previews: PreviewProvider {
    static var previews: some View {
        PageVendeurView()
    }
}
