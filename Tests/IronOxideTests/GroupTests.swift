@testable import IronOxide
import XCTest

final class GroupTests: ICLIntegrationTest {
    // func testGroupCreateAndDelete() throws {
    //     let createResult = try unwrapResult(primarySdk!.group.create())
    //     XCTAssertEqual(createResult.adminList.list.count, 1)
    //     XCTAssertEqual(createResult.memberList.list.count, 1)
    //     XCTAssertNil(createResult.groupName)
    //     XCTAssertEqual(createResult.owner, primaryTestUser!)
    //     XCTAssertFalse(createResult.needsRotation!)

    //     let deleteResult = try unwrapResult(primarySdk!.group.delete(groupId: createResult.groupId))
    //     XCTAssertEqual(deleteResult, createResult.groupId)
    // }

    // func testGroupList() throws {
    //     let listResult1 = try unwrapResult(primarySdk!.group.list())
    //     // the primaryGroup should always exists
    //     XCTAssertGreaterThan(listResult1.result.count, 0)
    // }

    func testAddAndRemoveMember() throws {
        let group = try unwrapResult(primarySdk!.group.create())
        let memberAdd = try unwrapResult(primarySdk!.group.addAdmins(groupId: group.groupId, users: [secondaryTestUser!]))
        XCTAssertEqual(memberAdd.succeeded.count, 1)
        XCTAssertEqual(memberAdd.failed.count, 0)

        let secondUser = try createUserAndDevice()
        let secondSdk = try unwrapResult(IronOxide.initialize(device: secondUser))

        let secondaryGet = try unwrapResult(secondSdk.group.getMetadata(groupId: group.groupId))
        print("Added as member")
        print("Am I an admin: \(secondaryGet.isAdmin)")
        print("Am I a member: \(secondaryGet.isMember)")
        XCTAssertTrue(secondaryGet.isMember)
        XCTAssertFalse(secondaryGet.isAdmin)

        // let memberRemove = try unwrapResult(primarySdk!.group.removeMembers(groupId: group.groupId, users: [secondaryTestUser!]))
        // XCTAssertEqual(memberRemove.succeeded.count, 1)
        // XCTAssertEqual(memberRemove.failed.count, 0)
    }

    // func testAddAndRemoveAdmin() throws {
    //     let adminAdd = try unwrapResult(primarySdk!.group.addAdmins(groupId: primaryGroup!, users: [secondaryTestUser!]))
    //     XCTAssertEqual(adminAdd.succeeded.count, 1)
    //     XCTAssertEqual(adminAdd.failed.count, 0)

    //     let secondaryGet = try unwrapResult(secondarySdk!.group.getMetadata(groupId: primaryGroup!))
    //     print("Added as admin")
    //     print("Am I an admin: \(secondaryGet.isAdmin)")
    //     print("Am I a member: \(secondaryGet.isMember)")
    //     XCTAssertTrue(secondaryGet.isAdmin)
    //     XCTAssertFalse(secondaryGet.isMember)

    //     let adminRemove = try unwrapResult(primarySdk!.group.removeAdmins(groupId: primaryGroup!, users: [secondaryTestUser!]))
    //     XCTAssertEqual(adminRemove.succeeded.count, 1)
    //     XCTAssertEqual(adminRemove.failed.count, 0)
    // }

    // func testGroupRotation() throws {
    //     let rotationResult = try unwrapResult(primarySdk!.group.rotatePrivateKey(groupId: primaryGroup!))
    //     XCTAssertFalse(rotationResult.needsRotation)
    // }
}
