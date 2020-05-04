@testable import IronOxide
import XCTest

final class GroupTests: XCTestCase {
    func testGroupFunctions() throws {
        let sdk = try initializeSdk()

        let opts = GroupCreateOpts(id: nil, name: nil, addAsAdmin: true, addAsMember: true, owner: nil, admins: [], members: [],
                                   needsRotation: true)
        let createResult = try unwrapResult(sdk.group.create(groupCreateOpts: opts))
        let groupId = createResult.groupId
        XCTAssertEqual(createResult.adminList.list.count, 1)
        XCTAssertEqual(createResult.memberList.list.count, 1)
        XCTAssertNil(createResult.groupName?.name)
        XCTAssertEqual(createResult.owner.id, getPrimaryTestUserDeviceContext().accountId.id)
        XCTAssertNotNil(createResult.groupId)
        XCTAssertTrue(createResult.needsRotation!)

        let memberUpdate = try unwrapResult(sdk.group.addMembers(groupId: groupId, users: [UserId("swifttester")!]))
        XCTAssertEqual(memberUpdate.succeeded.count, 1)
        XCTAssertEqual(memberUpdate.failed.count, 0)

        let rotationResult = try unwrapResult(sdk.group.rotatePrivateKey(groupId: groupId))
        XCTAssertFalse(rotationResult.needsRotation)
    }
}
