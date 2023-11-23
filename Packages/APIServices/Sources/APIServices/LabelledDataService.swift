//
//  LabelledDataService.swift
//
//
//  Created by Toomas Vahter on 23.11.2023.
//

import Foundation
import Networking

public final class LabelledDataService {
    private let baseURL: URL
    private let urlSession: URLSessionEndpointLoading

    public convenience init(baseURL: URL) {
        self.init(baseURL: baseURL, urlSession: URLSession.apiServices)
    }

    init(baseURL: URL, urlSession: URLSessionEndpointLoading) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }

    /// Fetches a list of labelled items in a tree like structure.
    /// - Throws: An error with `HTTPEndpointError` type.
    /// - Returns: A list of items with optional child items.
    public func fetchLabelledItems() async throws -> [LabelledItem] {
        let url = baseURL.appending(path: "/frontend-tha/data.json")
        let endpoint = HTTPEndpoint<[LabelledItem]>(jsonResponseURL: url)
        return try await urlSession.loadEndpoint(endpoint)
    }
}

extension LabelledDataService {
    public struct LabelledItem: Decodable {
        let id: String?
        let label: String
        let children: [LabelledItem]?
    }
}
