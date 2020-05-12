@testable import IronOxide
import XCTest

final class GroupTests: ICLIntegrationTest {
    func testGroupCreateDefault() throws {
        let createResult = try unwrapResult(primarySdk!.group.create())
        assertArrayCount(createResult.adminList.list, 1, fn: { $0.id })
        assertArrayCount(createResult.memberList.list, 1, fn: { $0.id })
        XCTAssertNil(createResult.groupName)
        XCTAssertEqual(createResult.owner, primaryTestUser!)
        XCTAssertFalse(createResult.needsRotation!)
        XCTAssertEqual(createResult.created, createResult.lastUpdated)
        XCTAssertTrue(createResult.isAdmin)
        XCTAssertTrue(createResult.isMember)
    }

    func testGroupCreateSpecificOwner() throws {
        // create with secondaryTestUser as owner
        let opts = GroupCreateOpts(id: nil, name: nil, addAsAdmin: true, addAsMember: true, owner: secondaryTestUser!, admins: [secondaryTestUser!],
                                   members: [secondaryTestUser!], needsRotation: true)
        let createResult = try unwrapResult(primarySdk!.group.create(groupCreateOpts: opts))
        XCTAssertEqual(createResult.owner, secondaryTestUser!)
    }

    func testGroupCreateInvalidUser() throws {
        // create with member that doesn't exist
        let opts = GroupCreateOpts(id: nil, name: nil, addAsAdmin: true, addAsMember: true, owner: nil, admins: [],
                                   members: [UserId("fakeuser3456")!], needsRotation: true)
        let createResult = primarySdk!.group.create(groupCreateOpts: opts)
        XCTAssertThrowsError(try createResult.get())
    }

    func testGroupCreateInvalidId() throws {
        // create with invalid group id
        let opts = GroupCreateOpts(id: GroupId("'=#.other|/$non@;safe'-:;id_")!, name: nil, addAsAdmin: true, addAsMember: true, owner: nil, admins: [],
                                   members: [], needsRotation: true)
        let createResult = primarySdk!.group.create(groupCreateOpts: opts)
        XCTAssertThrowsError(try createResult.get())
    }

    func testGroupDelete() throws {
        let createResult = try unwrapResult(primarySdk!.group.create())
        let deleteResult = try unwrapResult(primarySdk!.group.delete(groupId: createResult.groupId))
        XCTAssertEqual(deleteResult, createResult.groupId)
    }

    func testInitAndRotate() throws {
        let createResult = try unwrapResult(primarySdk!.group.create())
        _ = try unwrapResult(initializeAndRotate(device: primaryTestUserDeviceContext!, password: "foo", config: IronOxideConfig(),
                                                 timeout: Duration(seconds: 30)))
        let groupGet = try unwrapResult(primarySdk!.group.getMetadata(groupId: createResult.groupId))
        XCTAssertFalse(groupGet.needsRotation!)
    }

    func testGroupList() throws {
        _ = try unwrapResult(primarySdk!.group.create())
        let listResult1 = try unwrapResult(primarySdk!.group.list())
        XCTAssertGreaterThan(listResult1.result.count, 0)
    }

    func testAddAndRemoveMember() throws {
        let groupCreate = try unwrapResult(primarySdk!.group.create())
        let memberAdd = try unwrapResult(primarySdk!.group.addMembers(groupId: groupCreate.groupId, users: [secondaryTestUser!]))
        assertArrayCount(memberAdd.succeeded, 1, fn: { $0.id })
        assertArrayCount(memberAdd.failed, 0, fn: { "(\($0.user.id), \($0.error))" })

        let secondaryGet = try unwrapResult(secondarySdk!.group.getMetadata(groupId: groupCreate.groupId))
        XCTAssertTrue(secondaryGet.isMember)
        XCTAssertFalse(secondaryGet.isAdmin)

        let memberRemove = try unwrapResult(primarySdk!.group.removeMembers(groupId: groupCreate.groupId, users: [secondaryTestUser!]))
        assertArrayCount(memberRemove.succeeded, 1, fn: { $0.id })
        assertArrayCount(memberRemove.failed, 0, fn: { "(\($0.user.id), \($0.error))" })
    }

    func testAddAndRemoveAdmin() throws {
        let groupCreate = try unwrapResult(primarySdk!.group.create())
        let adminAdd = try unwrapResult(primarySdk!.group.addAdmins(groupId: groupCreate.groupId, users: [secondaryTestUser!]))
        assertArrayCount(adminAdd.succeeded, 1, fn: { $0.id })
        assertArrayCount(adminAdd.failed, 0, fn: { "(\($0.user.id), \($0.error))" })

        let secondaryGet = try unwrapResult(secondarySdk!.group.getMetadata(groupId: groupCreate.groupId))
        XCTAssertTrue(secondaryGet.isAdmin)
        XCTAssertFalse(secondaryGet.isMember)

        let adminRemove = try unwrapResult(primarySdk!.group.removeAdmins(groupId: groupCreate.groupId, users: [secondaryTestUser!]))
        assertArrayCount(adminRemove.succeeded, 1, fn: { $0.id })
        assertArrayCount(adminRemove.failed, 0, fn: { "(\($0.user.id), \($0.error))" })
    }

    func testGroupRotation() throws {
        let opts = GroupCreateOpts(id: nil, name: nil, addAsAdmin: true, addAsMember: true, owner: nil, admins: [], members: [], needsRotation: true)
        let groupCreate = try unwrapResult(primarySdk!.group.create(groupCreateOpts: opts))
        let rotationResult = try unwrapResult(primarySdk!.group.rotatePrivateKey(groupId: groupCreate.groupId))
        XCTAssertFalse(rotationResult.needsRotation)
    }

    func testGroupRotationNonAdmin() throws {
        let opts = GroupCreateOpts(id: nil, name: nil, addAsAdmin: true, addAsMember: true, owner: nil, admins: [], members: [secondaryTestUser!],
                                   needsRotation: true)
        let groupCreate = try unwrapResult(primarySdk!.group.create(groupCreateOpts: opts))
        let rotationResult = secondarySdk!.group.rotatePrivateKey(groupId: groupCreate.groupId)
        XCTAssertThrowsError(try rotationResult.get())
    }

    func testGroupUpdateName() throws {
        let createResult = try unwrapResult(primarySdk!.group.create())
        let newName = GroupName("new name")!
        let updateNameResult = try unwrapResult(primarySdk!.group.updateName(groupId: createResult.groupId, groupName: newName))
        XCTAssertEqual(updateNameResult.name, newName)
    }
}
