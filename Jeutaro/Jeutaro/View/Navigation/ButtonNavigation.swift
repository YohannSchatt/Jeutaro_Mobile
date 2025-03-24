//
//  ButtonNavigation.swift
//  Jeutaro
//
//  Created by etud on 14/03/2025.
//

import SwiftUI

struct ButtonNavigation<Destination: View>: View {
    
    @EnvironmentObject var routeur: Routeur
    
    let text: String
    let view: Destination
    
    var body: some View {
        Button(action: {
            routeur.setRoute(route: AnyView(view))
        }) {
            HStack {
                Text(text)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(Color.blue.opacity(0.6))
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct ButtonNavigation_Previews: PreviewProvider {
    static var previews: some View {
        ButtonNavigation(text: "Text", view: ConnexionView())
            .environmentObject(Routeur())
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
