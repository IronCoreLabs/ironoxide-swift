@testable import IronOxide
import libironoxide
import XCTest

final class UserTests: XCTestCase {
    func testGetPublicKey() throws {
        let realUsers = [UserId("testuser1")!,
                         UserId("testuser2")!]
        let fakeUsers = [
            UserId(UUID().uuidString)!,
        ]
        try realUsers.forEach { user in _ = try createUserAndDevice(user) }
        var userKeyList = try unwrapResult(primarySdk?.user.getPublicKey(users: realUsers + fakeUsers))

        // Sort users so we can assert on the expected values
        userKeyList = userKeyList.sorted(by: { $0.id.id < $1.id.id })

        XCTAssertEqual(userKeyList.count, 2)
        let firstUser = userKeyList[0]
        let secondUser = userKeyList[1]
        assertByteLength(firstUser.publicKey.bytes, 64)
        assertByteLength(secondUser.publicKey.bytes, 64)
        XCTAssertEqual(firstUser.id.id, "testuser1")
        XCTAssertEqual(secondUser.id.id, "testuser2")
    }

    func testListDevices() throws {
        let deviceList = try unwrapResult(primarySdk?.user.listDevices()).result

        XCTAssertGreaterThan(deviceList.count, 0)
        XCTAssertTrue(deviceList[0].isCurrentDevice)
        XCTAssertNil(deviceList[0].name)
        XCTAssertGreaterThan(deviceList[0].id.id, 0)
        XCTAssertTrue(deviceList[0].created < Date(timeIntervalSinceNow: 0))
        XCTAssertTrue(deviceList[0].lastUpdated < Date(timeIntervalSinceNow: 0))
    }
}
