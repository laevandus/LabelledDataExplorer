//
//  Theme.swift
//
//
//  Created by Toomas Vahter on 23.11.2023.
//

import SwiftUI

// TODO: Persistence
// TODO: More settings in addition to tint

struct ThemeSettings {
    let tintColor: Color
}

public enum Theme: CaseIterable {
    case bear, sunny, grassy
}

/// Manages the current theme.
@Observable public final class ThemeManager {
    public init() {}

    static let shared = ThemeManager()

    public var current: Theme = .sunny
}

// MARK: -

extension Theme {
    var tintColor: Color {
        switch self {
        case .bear: Color("BearTintColor", bundle: .module)
        case .sunny: Color("SunnyTintColor", bundle: .module)
        case .grassy: Color("GrassyTintColor", bundle: .module)
        }
    }
}

