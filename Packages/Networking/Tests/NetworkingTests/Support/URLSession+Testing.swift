//
//  URLSession+Testing.swift
//
//
//  Created by Toomas Vahter on 23.11.2023.
//

import Foundation

extension URLSession {
    static func testableSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [TestURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}
