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

public struct LabelledItem: Identifiable {
    public let id: String
    public let label: String
    public var children: [LabelledItem]

    public var isLeaf: Bool {
        children.isEmpty
    }
}

extension LabelledItem: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case label
        case children
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        label = try values.decode(String.self, forKey: .label)
        if let children = try? values.decode([LabelledItem].self, forKey: .children) {
            self.children = children
        } else {
            self.children = []
        }

        if let identifier = try? values.decode(String.self, forKey: .id) {
            id = identifier
        }
        else {
            // TODO: We could have multiple items with the same label (theoretically)
            id = label + UUID().uuidString
        }
    }
}
