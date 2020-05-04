import Foundation
@testable import IronOxide
import XCTest

final class SearchTests: XCTestCase {
    func tokenize() throws {
        let searchQuery = "ironcore labs"

        let sdk = try initializeSdk()
        let groupId = try sdk.group.create().get().groupId

        let ebis = try sdk.search.createBlindIndex(groupId: groupId).get()
        let bis = try ebis.initializeSearch(sdk: sdk).get()
        let queryTokens = Set(try bis.tokenizeQuery(query: searchQuery, partitionId: nil).get())
        let dataTokens = Set(try bis.tokenizeData(data: searchQuery, partitionId: nil).get())
        XCTAssertEqual(queryTokens.count, 8)
        XCTAssertGreaterThan(dataTokens.count, 8)
        XCTAssertTrue(queryTokens.isSubset(of: dataTokens))

        let queryTokens2 = Set(try bis.tokenizeQuery(query: searchQuery, partitionId: "foo").get())
        XCTAssertEqual(queryTokens2.count, 8)
        XCTAssertFalse(queryTokens2.elementsEqual(queryTokens))
    }
}
