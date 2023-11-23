//
//  ContentView.swift
//  LabelledDataExplorer
//
//  Created by Toomas Vahter on 23.11.2023.
//

import DesignSystem
import SwiftUI

struct ContentView: View {
    var body: some View {
        ContentPrepareView {
            Text("Success")
        } task: {
            try await Task.sleep(nanoseconds: 3_000_000_000)
        }

    }
}

#Preview {
    ContentView()
}
