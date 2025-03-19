//
//  route.swift
//  Jeutaro
//
//  Created by etud on 12/03/2025.
//

import Foundation
import SwiftUI

class Routeur : ObservableObject {
    
    @Published var selectedRoute: AnyView = AnyView(ConnexionView())

    func getRoute() -> AnyView {
        return AnyView(selectedRoute)
    }

    func setRoute(route: AnyView) {
        selectedRoute = AnyView(route)
    }
}
