@testable import IronOxide
import XCTest

final class DocumentTests: XCTestCase {
    func testEncryptDecryptRoundtrip() throws {
        let sdk = try initializeSdk()

        let bytes: [UInt8] = [10, 42]
        let createResult = try sdk.document
            .encrypt(bytes: bytes,
                     options: DocumentEncryptOpts(id: nil, documentName: nil, grantToAuthor: true, userGrants: [], groupGrants: [], policyGrant: nil)).get()
        XCTAssertNil(createResult.name)
        XCTAssertEqual(createResult.errors.groups.count, 0)
        XCTAssertEqual(createResult.errors.users.count, 0)
        XCTAssertEqual(createResult.changed.users.count, 1)

        let decryptResult = try sdk.document.decrypt(encryptedBytes: createResult.encryptedData).get()
        XCTAssertEqual(decryptResult.decryptedData, bytes)
    }

    func testListWorks() throws {
        let sdk = try initializeSdk()

        let bytes: [UInt8] = [10, 42]
        try sdk.document.encrypt(bytes: bytes).get()

        let listResult = try sdk.document.list().get()
        XCTAssertGreaterThanOrEqual(listResult.result.count, 1)
    }
}
