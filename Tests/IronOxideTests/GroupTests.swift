@testable import IronOxide
import XCTest

final class GroupTests: ICLIntegrationTest {
    func testGroupFunctions() throws {
        let opts = GroupCreateOpts(id: nil, name: nil, addAsAdmin: true, addAsMember: true, owner: nil, admins: [], members: [],
                                   needsRotation: true)
        let createResult = try unwrapResult(primarySdk!.group.create(groupCreateOpts: opts))
        let groupId = createResult.groupId
        XCTAssertEqual(createResult.adminList.list.count, 1)
        XCTAssertEqual(createResult.memberList.list.count, 1)
        XCTAssertNil(createResult.groupName)
        XCTAssertEqual(createResult.owner.id, primaryTestUserDeviceContext!.accountId.id)
        XCTAssertTrue(createResult.needsRotation!)

        let newUser = try createUserAndDevice().accountId
        let memberUpdate = try unwrapResult(primarySdk!.group.addMembers(groupId: groupId, users: [newUser]))
        XCTAssertEqual(memberUpdate.succeeded.count, 1)
        XCTAssertEqual(memberUpdate.failed.count, 0)

        let rotationResult = try unwrapResult(primarySdk!.group.rotatePrivateKey(groupId: groupId))
        XCTAssertFalse(rotationResult.needsRotation)
    }
}
