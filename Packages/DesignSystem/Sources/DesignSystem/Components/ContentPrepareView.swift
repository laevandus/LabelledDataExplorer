//
//  ContentPrepareView.swift
//
//
//  Created by Toomas Vahter on 23.11.2023.
//

import SwiftUI

public struct ContentPrepareView<Content, Failure, Loading>: View where Content: View, Failure: View, Loading: View {
    @State private var viewContent: ViewContent = .loading

    @ViewBuilder let content: () -> Content
    @ViewBuilder let failure: (Error, @escaping () async -> Void) -> Failure
    @ViewBuilder let loading: () -> Loading
    let task: () async throws -> Void

    public init(content: @escaping () -> Content,
         failure: @escaping (Error, @escaping () async -> Void) -> Failure = { ContentRetryView(error: $0, retryTask: $1) },
         loading: @escaping () -> Loading = { ProgressView() },
         task: @escaping () async throws -> Void) {
        self.content = content
        self.failure = failure
        self.loading = loading
        self.task = task
    }

    public var body: some View {
        Group {
            switch viewContent {
            case .content:
                content()
            case .failure(let error):
                failure(error, loadTask)
            case .loading:
                loading()
            }
        }
        .onLoad(perform: loadTask)
    }

    @MainActor func loadTask() async {
        do {
            viewContent = .loading
            try await task()
            viewContent = .content
        }
        catch {
            viewContent = .failure(error)
        }
    }
}

extension ContentPrepareView {
    enum ViewContent {
        case loading
        case content
        case failure(Error)
    }
}

#Preview {
    ContentPrepareView(content: {
        Text("Main Content")
    }, task: {
        // Simulate async loading
        try await Task.sleep(nanoseconds: 1_000_000_000)
    })
}
