//
//  TestURLSession.swift
//
//
//  Created by Toomas Vahter on 23.11.2023.
//

import Foundation
import Networking

struct TestURLSession: URLSessionEndpointLoading {
    let jsonResponseURL: URL

    init(jsonResponseURL: URL) {
        self.jsonResponseURL = jsonResponseURL
    }

    func loadEndpoint<ResponsePayload: Decodable>(_ endpoint: HTTPEndpoint<ResponsePayload>) async throws -> ResponsePayload {
        do {
            let data = try Data(contentsOf: jsonResponseURL)
            return try JSONDecoder().decode(ResponsePayload.self, from: data)
        } catch {
            throw HTTPEndpointError.emptyData
        }
    }
}
