//
//  ThemeViewModifier.swift
//  
//
//  Created by Toomas Vahter on 23.11.2023.
//

import SwiftUI

struct ThemeViewModifier: ViewModifier {
    @State private var themeManager = ThemeManager.shared

    func body(content: Content) -> some View {
        content
            .environment(themeManager)
            .tint(themeManager.current.tintColor)
    }
}

public extension View {
    /// Sets a current theme.
    func setTheme() -> some View {
        modifier(ThemeViewModifier())
    }
}

