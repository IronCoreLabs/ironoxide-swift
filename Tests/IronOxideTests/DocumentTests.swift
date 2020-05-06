@testable import IronOxide
import XCTest

final class DocumentTests: ICLIntegrationTest {
    func testEncryptDecryptRoundtrip() throws {
        let bytes: [UInt8] = [10, 42]
        let createResult = try unwrapResult(primarySdk!.document
            .encrypt(bytes: bytes,
                     options: DocumentEncryptOpts(id: nil, documentName: nil, grantToAuthor: true, userGrants: [], groupGrants: [], policyGrant: nil)))
        XCTAssertNil(createResult.name)
        XCTAssertEqual(createResult.errors.groups.count, 0)
        XCTAssertEqual(createResult.errors.users.count, 0)
        XCTAssertEqual(createResult.changed.users.count, 1)

        let decryptResult = try unwrapResult(primarySdk!.document.decrypt(encryptedBytes: createResult.encryptedData))
        XCTAssertEqual(decryptResult.decryptedData, bytes)
    }

    func testListWorks() throws {
        let bytes: [UInt8] = [10, 42]
        _ = primarySdk!.document.encrypt(bytes: bytes)

        let listResult = try unwrapResult(primarySdk!.document.list())
        XCTAssertGreaterThanOrEqual(listResult.result.count, 1)
    }
}
