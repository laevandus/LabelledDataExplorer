//
//  URLSession+APIServices.swift
//
//
//  Created by Toomas Vahter on 23.11.2023.
//

import Foundation

extension URLSession {
    /// A shared URLSession which does not use persistent storages.
    ///
    /// - Note: Using a single session enables more efficient networking through connection reusage.
    static let apiServices = URLSession(configuration: .ephemeral)
}
