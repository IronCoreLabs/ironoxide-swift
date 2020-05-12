@testable import IronOxide
import XCTest

final class GroupTests: ICLIntegrationTest {
    func testGroupCreateAndDelete() throws {
        let createResult = try unwrapResult(primarySdk!.group.create())
        XCTAssertEqual(createResult.adminList.list.count, 1)
        XCTAssertEqual(createResult.memberList.list.count, 1)
        XCTAssertNil(createResult.groupName)
        XCTAssertEqual(createResult.owner, primaryTestUser!)
        XCTAssertFalse(createResult.needsRotation!)

        let deleteResult = try unwrapResult(primarySdk!.group.delete(groupId: createResult.groupId))
        XCTAssertEqual(deleteResult, createResult.groupId)
    }

    func testGroupList() throws {
        let listResult1 = try unwrapResult(primarySdk!.group.list())
        // the primaryGroup should always exists
        XCTAssertGreaterThan(listResult1.result.count, 0)
    }

    func testAddAndRemoveMember() throws {
        let memberAdd = try unwrapResult(primarySdk!.group.addMembers(groupId: primaryGroup!, users: [secondaryTestUser!]))
        assertArrayCount(memberAdd.succeeded, 1, fn: { $0.id })
        assertArrayCount(memberAdd.failed, 0, fn: { "(\($0.user.id), \($0.error))" })

        let secondaryGet = try unwrapResult(secondarySdk!.group.getMetadata(groupId: primaryGroup!))
        XCTAssertTrue(secondaryGet.isMember)
        XCTAssertFalse(secondaryGet.isAdmin)

        let memberRemove = try unwrapResult(primarySdk!.group.removeMembers(groupId: primaryGroup!, users: [secondaryTestUser!]))
        assertArrayCount(memberRemove.succeeded, 1, fn: { $0.id })
        assertArrayCount(memberRemove.failed, 0, fn: { "(\($0.user.id), \($0.error))" })
    }

    func testAddAndRemoveAdmin() throws {
        let adminAdd = try unwrapResult(primarySdk!.group.addAdmins(groupId: primaryGroup!, users: [secondaryTestUser!]))
        assertArrayCount(adminAdd.succeeded, 1, fn: { $0.id })
        assertArrayCount(adminAdd.failed, 0, fn: { "(\($0.user.id), \($0.error))" })

        let secondaryGet = try unwrapResult(secondarySdk!.group.getMetadata(groupId: primaryGroup!))
        XCTAssertTrue(secondaryGet.isAdmin)
        XCTAssertFalse(secondaryGet.isMember)

        let adminRemove = try unwrapResult(primarySdk!.group.removeAdmins(groupId: primaryGroup!, users: [secondaryTestUser!]))
        assertArrayCount(adminRemove.succeeded, 1, fn: { $0.id })
        assertArrayCount(adminRemove.failed, 0, fn: { "(\($0.user.id), \($0.error))" })
    }

    func testGroupRotation() throws {
        let rotationResult = try unwrapResult(primarySdk!.group.rotatePrivateKey(groupId: primaryGroup!))
        XCTAssertFalse(rotationResult.needsRotation)
    }

    func testGroupUpdateName() throws {
        let createResult = try unwrapResult(primarySdk!.group.create())
        let newName = GroupName("new name")!
        let updateNameResult = try unwrapResult(primarySdk!.group.updateName(groupId: createResult.groupId, groupName: newName))
        XCTAssertEqual(updateNameResult.name, newName)
    }
}
