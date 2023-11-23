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

    /// Fetches labelled item details for an id.
    /// - Throws: An error with `HTTPEndpointError` type.
    public func fetchLabelledItemDetails(for id: String) async throws -> LabelledItemDetails {
        let url = baseURL.appending(path: "frontend-tha/entries/\(id).json")
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601FractionalSeconds
        let endpoint = HTTPEndpoint<LabelledItemDetails>(jsonResponseURL: url, decoder: decoder)
        return try await urlSession.loadEndpoint(endpoint)
    }
}

// MARK: -

public struct LabelledItem: Identifiable, Hashable {
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

// MARK: -

public struct LabelledItemDetails: Decodable, Identifiable {
    public let id: String
    public let createdAt: Date
    public let createdBy: String
    public let lastModifiedAt: Date?
    public let lastModifiedBy: String?
    public let description: String

    public init(id: String, createdAt: Date, createdBy: String, lastModifiedAt: Date?, lastModifiedBy: String?, description: String) {
        self.id = id
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.lastModifiedAt = lastModifiedAt
        self.lastModifiedBy = lastModifiedBy
        self.description = description
    }
}

// MARK: -

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601FractionalSeconds = custom {
        try .init(iso8601FractionalSeconds: $0.singleValueContainer().decode(String.self))
    }
}

extension Date {
    init(iso8601FractionalSeconds parseInput: ParseStrategy.ParseInput) throws {
        try self.init(parseInput, strategy: .iso8601FractionalSeconds)
    }
}

extension ParseStrategy where Self == Date.ISO8601FormatStyle {
    static var iso8601FractionalSeconds: Date.ISO8601FormatStyle { .iso8601FractionalSeconds }
}

extension Date.ISO8601FormatStyle {
    static let iso8601FractionalSeconds: Self = .init(includingFractionalSeconds: true)
}
