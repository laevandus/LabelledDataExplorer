//
//  LabelledDataServiceTests.swift
//  
//
//  Created by Toomas Vahter on 23.11.2023.
//

@testable import APIServices
import Networking
import XCTest

final class LabelledDataServiceTests: XCTestCase {
    private static let baseURL = URL(string: "https://www.example.org")!

    func testDecodingTreeLikeResponse() async throws {
        let session = TestURLSession(jsonResponseURL: TestData.labelledDataResponse1)
        let service = LabelledDataService(baseURL: Self.baseURL, urlSession: session)
        let result = try await service.fetchLabelledItems()
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.map(\.label).sorted(), ["9elements", "img.ly"])

        let thirdLevelChildren: [LabelledItem]? = result
            .first(where: { $0.label == "img.ly" })?.children
            .first(where: { $0.label == "Workspace B" })?.children
            .first(where: { $0.label == "Entry 3" })?.children
        XCTAssertEqual(thirdLevelChildren?.map(\.label).sorted(), ["Sub-Entry 1"])
    }
}
