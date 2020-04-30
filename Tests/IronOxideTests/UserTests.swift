@testable import IronOxide
import libironoxide
import XCTest

final class UserTests: XCTestCase {
    func testGetPublicKey() throws {
        let users = [
            UserId("foo")!,
            UserId("swifttester")!,
            UserId("swifttester33")!,
        ]

        let sdk = try initializeSdk()

        var userKeyList = try unwrapResult(sdk.user.getPublicKey(users: users))

        // Sort users so we can assert on the expected values
        userKeyList = userKeyList.sorted(by: { $0.id.id < $1.id.id })

        XCTAssertEqual(userKeyList.count, 2)
        let firstUser = userKeyList[0]
        let secondUser = userKeyList[1]
        assertByteLength(firstUser.publicKey.bytes, 64)
        assertByteLength(secondUser.publicKey.bytes, 64)
        XCTAssertEqual(firstUser.id.id, "swifttester")
        XCTAssertEqual(secondUser.id.id, "swifttester33")
    }

    func testListDevices() throws {
        let sdk = try initializeSdk()
        let deviceList = try unwrapResult(sdk.user.listDevices()).result

        XCTAssertGreaterThan(deviceList.count, 0)
        XCTAssertTrue(deviceList[0].isCurrentDevice)
        XCTAssertNil(deviceList[0].name)
        XCTAssertGreaterThan(deviceList[0].id.id, 0)
        XCTAssertTrue(deviceList[0].created < Date(timeIntervalSinceNow: 0))
        XCTAssertTrue(deviceList[0].lastUpdated < Date(timeIntervalSinceNow: 0))
    }
}
