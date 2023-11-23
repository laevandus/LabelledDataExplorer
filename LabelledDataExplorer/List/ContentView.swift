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

    var body: some View {
        ContentPrepareView {
            NavigationStack {
                List {
                    ListGroupView(items: $viewModel.items)
                }
                .navigationTitle("Data Explorer")
                .toolbar {
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
