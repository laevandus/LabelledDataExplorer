//
//  ContentRetryView.swift
//
//
//  Created by Toomas Vahter on 23.11.2023.
//

import SwiftUI

public struct ContentRetryView: View {
    let error: Error
    let retryTask: () async -> Void

    public init(error: Error, retryTask: @escaping () async -> Void) {
        self.error = error
        self.retryTask = retryTask
    }

    public var body: some View {
        ContentUnavailableView(label: {
            Label("Failed to load", systemImage: "exclamationmark.circle.fill")
        }, description: {
            Text(error.localizedDescription)
        }, actions: {
            Button(action: {
                Task { await retryTask() }
            }, label: {
                Text("Retry")
            })
        })
    }
}

#Preview {
    ContentRetryView(error: NSError(domain: "Preview", code: 0), retryTask: {})
}
