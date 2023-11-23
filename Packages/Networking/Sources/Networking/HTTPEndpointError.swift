//
//  HTTPEndpointError.swift
//
//
//  Created by Toomas Vahter on 23.11.2023.
//

import Foundation

/// The error describing HTTP endpoint loading failures.
public enum HTTPEndpointError: Error {
    /// Connection failed with underlying error.
    case connection(Error)
    /// Expected response data but no data was returned.
    case emptyData
    /// Failed to create a URLRequest
    case invalidURLRequest
    /// Failed to parse response data.
    case responseParsing(Error)
    /// Expected HTTPURLResponse but non-HTTP response was received.
    case unknownURLResponse
    /// Unexpected HTTP status code was received.
    case unexpectedHTTPStatusCode(Int)
    /// The request succeeded but server failed to compose a response data (e.g. missing or invalid request parameters).
    case responsePayloadFailure
}
