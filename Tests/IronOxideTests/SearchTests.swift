import Foundation
@testable import IronOxide
import XCTest

final class SearchTests: ICLIntegrationTest {
    func tokenize() throws {
        let searchQuery = "ironcore labs"

        let groupId = try unwrapResult(primarySdk!.group.create()).groupId
        let ebis = try unwrapResult(primarySdk!.search.createBlindIndex(groupId: groupId))
        let bis = try unwrapResult(ebis.initializeSearch(sdk: primarySdk!))
        let queryTokens = Set(try unwrapResult(bis.tokenizeQuery(query: searchQuery, partitionId: nil)))
        let dataTokens = Set(try unwrapResult(bis.tokenizeData(data: searchQuery, partitionId: nil)))
        XCTAssertEqual(queryTokens.count, 8)
        XCTAssertGreaterThan(dataTokens.count, 8)
        XCTAssertTrue(queryTokens.isSubset(of: dataTokens))

        let queryTokens2 = Set(try unwrapResult(bis.tokenizeQuery(query: searchQuery, partitionId: "foo")))
        XCTAssertEqual(queryTokens2.count, 8)
        XCTAssertFalse(queryTokens2.elementsEqual(queryTokens))
    }
}
