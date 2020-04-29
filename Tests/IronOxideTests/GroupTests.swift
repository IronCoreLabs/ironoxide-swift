@testable import IronOxide
import XCTest

final class GroupTests: XCTestCase {
    func testGroupFunctions() throws {
        let deviceJson =
            #"{"accountId": "swifttester33","segmentId": 1,"signingPrivateKey": "pI1SrCz4OffvmviszBATjaELD8tGUc18CixZ+evqeX3m3UKWkM5fsgg7Lt7YdtWPX/GoPUwrL0C7YLar2MEKTw==","devicePrivateKey": "RVBKa0AUEbUxkNJXbp2ErGN4bwIAs1WMZbMxacTGQe0="}"#
        let dc = IronOxide.DeviceContext(deviceContextJson: deviceJson)!
        let sdk = try IronOxide.initialize(device: dc).get()

        let opts = GroupCreateOpts(id: nil, name: nil, addAsAdmin: true, addAsMember: true, owner: nil, admins: [], members: [], needsRotation: true)
        let createResult = try sdk.group.create(groupCreateOpts: opts).get()
        let groupId = createResult.groupId
        XCTAssertEqual(createResult.adminList.list.count, 1)
        XCTAssertEqual(createResult.memberList.list.count, 1)
        XCTAssertNil(createResult.groupName?.name)
        XCTAssertEqual(createResult.owner.id, dc.accountId.id)
        XCTAssertNotNil(createResult.groupId)
        XCTAssertTrue(createResult.needsRotation!)

        let memberUpdate = try sdk.group.addMembers(groupId: groupId, users: [UserId("swifttester")!]).get()
        XCTAssertEqual(memberUpdate.succeeded.count, 1)
        XCTAssertEqual(memberUpdate.failed.count, 0)

        let rotationResult = try sdk.group.rotatePrivateKey(groupId: groupId).get()
        XCTAssertFalse(rotationResult.needsRotation)
    }
}
