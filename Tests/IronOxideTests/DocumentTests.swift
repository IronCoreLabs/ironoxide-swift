@testable import IronOxide
import XCTest

final class DocumentTests: ICLIntegrationTest {
    func testList() throws {
        let bytes: [UInt8] = [10, 42]
        _ = primarySdk!.document.encrypt(bytes: bytes)

        let listResult = try unwrapResult(primarySdk!.document.list())
        XCTAssertGreaterThanOrEqual(listResult.result.count, 1)
    }

    func roundtripHelper(bytes: [UInt8]) throws {
        let createResult = try unwrapResult(primarySdk!.document
            .encrypt(bytes: bytes,
                     options: DocumentEncryptOpts(id: nil, documentName: nil, grantToAuthor: true, userGrants: [primaryTestUser!], groupGrants: [],
                                                  policyGrant: nil)))
        XCTAssertNil(createResult.name)
        assertCollectionCount(createResult.accessErrors.groups, 0)
        assertCollectionCount(createResult.accessErrors.users, 0)
        assertCollectionCount(createResult.grants.users, 1)

        let decryptResult = try unwrapResult(primarySdk!.document.decrypt(encryptedBytes: createResult.encryptedData))
        XCTAssertEqual(decryptResult.decryptedData, bytes)
    }

    func testRoundtrip() throws {
        try roundtripHelper(bytes: [10, 42])
    }

    func testRoundtripEmpty() throws {
        try roundtripHelper(bytes: [])
    }

    func testEncryptDefault() throws {
        let bytes: [UInt8] = [1, 10, 100]
        let createResult = try unwrapResult(primarySdk!.document.encrypt(bytes: bytes, options: DocumentEncryptOpts()))
        assertCollectionCount(createResult.grants.users, 1)
        assertCollectionCount(createResult.grants.groups, 0)
        assertCollectionCount(createResult.accessErrors.users, 0)
        assertCollectionCount(createResult.accessErrors.groups, 0)
    }

    func testEncryptWithPolicy() throws {
        let dc = try createUserAndDevice()
        let sdk = try unwrapResult(IronOxide.initialize(device: dc))
        let groupId = GroupId("data_recovery_\(dc.accountId.id)")!
        let groupOpts = GroupCreateOpts(id: groupId, name: nil, addAsAdmin: true, addAsMember: true, owner: nil, admins: [], members: [], needsRotation: false)
        _ = sdk.group.create(groupCreateOpts: groupOpts)
        let bytes: [UInt8] = [1, 2, 3, 4]
        let policy = PolicyGrant(category: Category(s: "PII"), sensitivity: Sensitivity(s: "INTERNAL"), dataSubject: nil, substituteUser: nil)!
        let documentOpts = DocumentEncryptOpts(id: nil, documentName: DocumentName("doc name"), grantToAuthor: false, userGrants: [], groupGrants: [],
                                               policyGrant: policy)
        let encryptResult = try unwrapResult(sdk.document.encrypt(bytes: bytes, options: documentOpts))
        XCTAssertEqual(encryptResult.grants.groups, [groupId])
        XCTAssertEqual(encryptResult.grants.users, [dc.accountId])
        XCTAssertEqual(encryptResult.accessErrors.groups, [GroupId("badgroupid_frompolicy")])
        XCTAssertEqual(encryptResult.accessErrors.users, [UserId("baduserid_frompolicy")])

        // try with empty policy
        let opts = DocumentEncryptOpts(id: nil, documentName: nil, grantToAuthor: false, userGrants: [], groupGrants: [], policyGrant: PolicyGrant())
        _ = try unwrapResult(sdk.document.encrypt(bytes: [0], options: opts))
        XCTAssertEqual(sdk.clearPolicyCache(), 1)
    }

    func testEncryptToOther() throws {
        let opts = DocumentEncryptOpts(id: nil, documentName: nil, grantToAuthor: false, userGrants: [secondaryTestUser!], groupGrants: [], policyGrant: nil)
        let encryptResult = try unwrapResult(primarySdk!.document.encrypt(bytes: [], options: opts))
        XCTAssertEqual(encryptResult.grants.users, [secondaryTestUser])
        assertCollectionCount(encryptResult.grants.groups, 0)
        assertCollectionCount(encryptResult.accessErrors.users, 0)
        assertCollectionCount(encryptResult.accessErrors.groups, 0)
    }

    func testEncryptToNothing() throws {
        let opts = DocumentEncryptOpts(id: nil, documentName: nil, grantToAuthor: false, userGrants: [], groupGrants: [], policyGrant: nil)
        let encryptResult = primarySdk!.document.encrypt(bytes: [1], options: opts)
        XCTAssertThrowsError(try encryptResult.get())
    }

    func testUpdateName() throws {
        let originalName = DocumentName("top secret")!
        let opts = DocumentEncryptOpts(id: nil, documentName: originalName, grantToAuthor: true, userGrants: [], groupGrants: [],
                                       policyGrant: nil)
        let encryptResult = try unwrapResult(primarySdk!.document.encrypt(bytes: [1, 2], options: opts))
        XCTAssertEqual(encryptResult.name, originalName)

        let newName = DocumentName("declassified")
        let updateResult = try unwrapResult(primarySdk!.document.updateName(documentId: encryptResult.id, newName: newName))
        XCTAssertEqual(updateResult.name, newName)
    }

    func testDecryptAfterRotation() throws {
        let bytes: [UInt8] = [1, 2]
        let dc = try createUserAndDevice()
        let sdk = try unwrapResult(IronOxide.initialize(device: dc))
        let encryptResult = try unwrapResult(sdk.document.encrypt(bytes: bytes))

        _ = sdk.user.rotatePrivateKey(password: "foo")

        let decryptResult = try unwrapResult(sdk.document.decrypt(encryptedBytes: encryptResult.encryptedData))
        XCTAssertEqual(decryptResult.decryptedData, bytes)
    }

    func testUpdateBytes() throws {
        let bytes: [UInt8] = [1, 2]
        let encryptResult = try unwrapResult(primarySdk!.document.encrypt(bytes: bytes))
        let newBytes: [UInt8] = [3, 4]
        let updateResult = try unwrapResult(primarySdk!.document.updateBytes(documentId: encryptResult.id, newBytes: newBytes))
        let decryptResult = try unwrapResult(primarySdk!.document.decrypt(encryptedBytes: updateResult.encryptedData))
        XCTAssertEqual(decryptResult.decryptedData, newBytes)
    }

    func testAddRemoveMembers() throws {
        let encryptResult = try unwrapResult(primarySdk!.document.encrypt(bytes: [1]))
        assertCollectionCount(encryptResult.grants.users, 1)
        assertCollectionCount(encryptResult.grants.groups, 0)

        let addResult = try unwrapResult(primarySdk!.document.grantAccess(documentId: encryptResult.id, users: [secondaryTestUser!], groups: []))
        assertCollectionCount(addResult.changed.users, 1)
        assertCollectionCount(addResult.changed.groups, 0)

        let metadata = try unwrapResult(primarySdk!.document.getMetadata(documentId: encryptResult.id))
        assertCollectionCount(metadata.visibleToUsers, 2)

        let removeResult = try unwrapResult(primarySdk!.document.revokeAccess(documentId: encryptResult.id, users: [secondaryTestUser!], groups: []))
        assertCollectionCount(removeResult.changed.users, 1)
        assertCollectionCount(removeResult.changed.groups, 0)

        let metadata2 = try unwrapResult(primarySdk!.document.getMetadata(documentId: encryptResult.id))
        assertCollectionCount(metadata2.visibleToUsers, 1)
    }

    func testEncryptUnmanagedRoundtrip() throws {
        let bytes: [UInt8] = [1, 2, 3]
        let encryptResult = try unwrapResult(primarySdk!.document.advanced.encryptUnmanaged(bytes: bytes))
        let decryptResult = try unwrapResult(primarySdk!.document.advanced
            .decryptUnmanaged(encryptedBytes: encryptResult.encryptedData, encryptedDeks: encryptResult.encryptedDeks))
        XCTAssertEqual(decryptResult.decryptedData, bytes)
    }

    func testEncryptUnmanagedToOther() throws {
        let bytes: [UInt8] = [1, 2, 3]
        let opts = DocumentEncryptOpts(id: nil, documentName: nil, grantToAuthor: false, userGrants: [secondaryTestUser!], groupGrants: [], policyGrant: nil)
        let encryptResult = try unwrapResult(primarySdk!.document.advanced.encryptUnmanaged(bytes: bytes, options: opts))
        let decryptResult = primarySdk!.document.advanced
            .decryptUnmanaged(encryptedBytes: encryptResult.encryptedData, encryptedDeks: encryptResult.encryptedDeks)
        XCTAssertThrowsError(try decryptResult.get())
    }

    func testEncryptUnmanagedToNothing() throws {
        let bytes: [UInt8] = [1, 2, 3]
        let opts = DocumentEncryptOpts(id: nil, documentName: nil, grantToAuthor: false, userGrants: [], groupGrants: [], policyGrant: nil)
        let encryptResult = primarySdk!.document.advanced.encryptUnmanaged(bytes: bytes, options: opts)
        XCTAssertThrowsError(try encryptResult.get())
    }

    func testGetIdFromBytes() throws {
        let bytes: [UInt8] = [2, 3, 4]
        let encryptResult = try unwrapResult(primarySdk!.document.encrypt(bytes: bytes))
        let id = try unwrapResult(primarySdk!.document.getIdFromBytes(bytes: encryptResult.encryptedData))
        XCTAssertEqual(encryptResult.id, id)
    }
}
