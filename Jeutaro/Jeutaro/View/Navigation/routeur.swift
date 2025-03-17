//
//  route.swift
//  Jeutaro
//
//  Created by etud on 12/03/2025.
//

import Foundation
import SwiftUI

class routeur : ObservableObject {
    
    @Published var selectedRoute: AnyView = AnyView(CatalogueView())

    func getRoute() -> AnyView {
        return AnyView(selectedRoute)
    }

    func setRoute(route: AnyView) {
        selectedRoute = AnyView(route)
    }
}
