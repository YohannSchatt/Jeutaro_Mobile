//
//  ButtonNavigation.swift
//  Jeutaro
//
//  Created by etud on 14/03/2025.
//

import SwiftUI

struct ButtonNavigation<Destination : View>: View {
    
    @ObservedObject var selection: routeur
    let text : String
    let view : Destination
    
    var body: some View {
        HStack {
            Button(action: {
                selection.setRoute(route: AnyView(view))
            }) {
                Text(text)
                    .font(.system(size: 20))
                    .padding() // Add padding around the text
                    .foregroundColor(.black)
            }
            Spacer()
        }.border(Color.black, width: 2)
        .background(DefineColor.color5.color)
    }
}

struct ButtonNavigation_Previews: PreviewProvider {
    static var previews: some View {
        ButtonNavigation(selection: routeur(), text: "Text", view: ConnexionView())
    }
}
