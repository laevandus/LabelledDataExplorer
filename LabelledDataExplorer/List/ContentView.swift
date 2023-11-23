//
//  ContentView.swift
//  LabelledDataExplorer
//
//  Created by Toomas Vahter on 23.11.2023.
//

import APIServices
import DesignSystem
import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    @Environment(ThemeManager.self) var manager

    var body: some View {
        ContentPrepareView {
            NavigationStack {
                List {
                    ListGroupView(items: $viewModel.items)
                }
                .navigationTitle("Data Explorer")
                .toolbar {
                    // TODO: Create a settings view, this is for testing
                    Button("Theme (debug)") {
                        manager.current = Theme.allCases.randomElement()!
                    }
                    EditButton()
                }
            }
        } task: {
            try await viewModel.prepare()
        }
    }
}

extension ContentView {
    @Observable final class ViewModel {
        var items = [LabelledItem]()
        let service: LabelledDataService

        init(service: LabelledDataService = LabelledDataService(baseURL: AppConstants.URLs.labelledDataBaseURL)) {
            self.service = service
        }

        func prepare() async throws {
            items = try await service.fetchLabelledItems()
        }
    }
}

#Preview {
    ContentView()
}
