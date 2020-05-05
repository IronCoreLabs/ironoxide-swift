@testable import IronOxide
import libironoxide
import XCTest

final class UserTests: ICLIntegrationTest {
    func testGetPublicKey() throws {
        let realUsers = [primaryTestUser!,
                         secondaryTestUser!].sorted(by: { $0.id < $1.id })
        let fakeUsers = [
            UserId(UUID().uuidString)!,
        ]
        var userKeyList = try unwrapResult(primarySdk!.user.getPublicKey(users: realUsers + fakeUsers))
        // Sort users so we can assert on the expected values
        userKeyList = userKeyList.sorted(by: { $0.id.id < $1.id.id })

        XCTAssertEqual(userKeyList.count, realUsers.count)
        for i in 0 ..< userKeyList.count {
            assertByteLength(userKeyList[i].publicKey.bytes, 64)
            XCTAssertEqual(userKeyList[i].id.id, realUsers[i].id)
        }
    }

    func testListDevices() throws {
        let deviceList = try unwrapResult(primarySdk!.user.listDevices()).result

        XCTAssertGreaterThan(deviceList.count, 0)
        XCTAssertTrue(deviceList[0].isCurrentDevice)
        XCTAssertNil(deviceList[0].name)
        XCTAssertGreaterThan(deviceList[0].id.id, 0)
        XCTAssertTrue(deviceList[0].created < Date(timeIntervalSinceNow: 0))
        XCTAssertTrue(deviceList[0].lastUpdated < Date(timeIntervalSinceNow: 0))
    }
}
