import Foundation
@testable import IronOxide
import XCTest

final class SearchTests: ICLIntegrationTest {
    func testTokenize() throws {
        let searchQuery = "ironcore labs"
        let groupId = try unwrapResult(primarySdk!.group.create()).groupId
        let ebis = try unwrapResult(primarySdk!.search.createBlindIndex(groupId: groupId))
        let bis = try unwrapResult(ebis.initializeSearch(sdk: primarySdk!))
        let queryTokens = Set(try unwrapResult(bis.tokenizeQuery(query: searchQuery, partitionId: nil)))
        let dataTokens = Set(try unwrapResult(bis.tokenizeData(data: searchQuery, partitionId: nil)))
        assertCollectionCount(queryTokens, 8)
        assertCollectionCountGreaterThan(dataTokens, 8)
        XCTAssertTrue(queryTokens.isSubset(of: dataTokens))
        let queryTokens2 = Set(try unwrapResult(bis.tokenizeQuery(query: searchQuery, partitionId: "foo")))
        assertCollectionCount(queryTokens2, 8)
        XCTAssertFalse(queryTokens2.elementsEqual(queryTokens))
    }
}
