//
//  Color.swift
//  Jeutaro
//
//  Created by etud on 13/03/2025.
//

import Foundation
import SwiftUI

public enum DefineColor {
    case color1
    case color2
    case color3
    case color4
    case color5

    var color: Color {
        switch self {
        case .color1:
            return Color(red: 0.9, green: 0.4, blue: 0.7) // Rose
        case .color2:
            return Color(red: 0.6, green: 0.2, blue: 0.8) // Violet
        case .color3:
            return Color(red: 0.8, green: 0.3, blue: 0.6) // Rose foncé
        case .color4:
            return Color(red: 0.7, green: 0.2, blue: 0.5) // Violet foncé
        case .color5:
            return Color(red: 0.9, green: 0.6, blue: 0.8) // Rose clair
        }
    }
}
