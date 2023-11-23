//
//  LabelledItemDetailsView.swift
//  LabelledDataExplorer
//
//  Created by Toomas Vahter on 23.11.2023.
//

import APIServices
import DesignSystem
import SwiftUI

struct LabelledItemDetailsView: View {
    @State private var viewModel: ViewModel

    init(id: String) {
        self.viewModel = ViewModel(id: id)
    }

    var body: some View {
        ContentPrepareView {
            Form {
                Section(header: Text("Description")) {
                    Text(viewModel.item.description)
                }
                Section(header: Text("Created")) {
                    TitledValueRowView(title: "Creator", value: viewModel.item.createdBy)
                    TitledValueRowView(title: "Date", value: viewModel.item.createdAt.formatted(date: .abbreviated, time: .standard))
                }
                if let lastModifiedBy = viewModel.item.lastModifiedBy, let lastModifiedAt = viewModel.item.lastModifiedAt {
                    Section(header: Text("Updated")) {
                        TitledValueRowView(title: "Modifier", value: lastModifiedBy)
                        TitledValueRowView(title: "Date", value: lastModifiedAt.formatted(date: .abbreviated, time: .standard))
                    }
                }
            }
            .navigationTitle("Details")
        } task: {
            try await viewModel.prepare()
        }
    }
}

extension LabelledItemDetailsView {
    @Observable final class ViewModel {
        private var details: LabelledItemDetails?
        let id: String
        let service: LabelledDataService

        init(id: String, service: LabelledDataService = LabelledDataService(baseURL: AppConstants.URLs.labelledDataBaseURL)) {
            self.id = id
            self.service = service
        }

        func prepare() async throws {
            details = try await service.fetchLabelledItemDetails(for: id)
        }

        var item: LabelledItemDetails {
            details!
        }
    }
}
