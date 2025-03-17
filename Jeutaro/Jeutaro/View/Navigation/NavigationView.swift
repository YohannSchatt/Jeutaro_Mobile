//
//  NavigationView.swift
//  Jeutaro
//
//  Created by etud on 13/03/2025.
//

import SwiftUI

struct NavigationView: View {

    @ObservedObject var selection: routeur

    var body: some View {
        selection.getRoute()
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(selection: routeur())
    }
}
