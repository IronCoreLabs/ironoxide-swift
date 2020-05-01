@testable import IronOxide
import XCTest

final class DocumentTests: XCTestCase {
    func encryptDecryptRoundtrip() throws {
        let deviceJson =
            #"{"accountId": "swifttester33","segmentId": 1,"signingPrivateKey": "pI1SrCz4OffvmviszBATjaELD8tGUc18CixZ+evqeX3m3UKWkM5fsgg7Lt7YdtWPX/GoPUwrL0C7YLar2MEKTw==","devicePrivateKey": "RVBKa0AUEbUxkNJXbp2ErGN4bwIAs1WMZbMxacTGQe0="}"#
        let dc = IronOxide.DeviceContext(deviceContextJson: deviceJson)!
        let sdk = try IronOxide.initialize(device: dc).get()

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

    func listWorks() throws {
        let deviceJson =
            #"{"accountId": "swifttester33","segmentId": 1,"signingPrivateKey": "pI1SrCz4OffvmviszBATjaELD8tGUc18CixZ+evqeX3m3UKWkM5fsgg7Lt7YdtWPX/GoPUwrL0C7YLar2MEKTw==","devicePrivateKey": "RVBKa0AUEbUxkNJXbp2ErGN4bwIAs1WMZbMxacTGQe0="}"#
        let dc = IronOxide.DeviceContext(deviceContextJson: deviceJson)!
        let sdk = try IronOxide.initialize(device: dc).get()

        let bytes: [UInt8] = [10, 42]
        try sdk.document
            .encrypt(bytes: bytes,
                     options: DocumentEncryptOpts(id: nil, documentName: nil, grantToAuthor: true, userGrants: [], groupGrants: [], policyGrant: nil)).get()

        let listResult = try sdk.document.list().get()
        XCTAssertGreaterThanOrEqual(listResult.result.count, 1)
    }
}
