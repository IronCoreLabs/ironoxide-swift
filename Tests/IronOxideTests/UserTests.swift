@testable import IronOxide
import libironoxide
import XCTest

final class UserTests: XCTestCase {
    let deviceJson = """
    {"accountId": "swifttester33","segmentId": 1,"signingPrivateKey": "pI1SrCz4OffvmviszBATjaELD8tGUc18CixZ+evqeX3m3UKWkM5fsgg7Lt7YdtWPX/GoPUwrL0C7YLar2MEKTw==","devicePrivateKey": "RVBKa0AUEbUxkNJXbp2ErGN4bwIAs1WMZbMxacTGQe0="}
    """

    func testGetPublicKey() {
        let users = [
            UserId("foo")!,
            UserId("swifttester")!,
            UserId("swifttester33")!,
        ]

        let dc = IronOxide.DeviceContext(deviceContextJson: deviceJson)!
        let maybePublicKeys = IronOxide.initialize(device: dc)
            .flatMap { sdk in
                sdk.user.getPublicKey(users: users)
            }

        switch maybePublicKeys {
        case let .success(userKeyList):
            XCTAssertEqual(userKeyList.count, 2)
            let firstUserId = userKeyList[0].id.id
            let secondUserId = userKeyList[1].id.id
            print("Found user \(firstUserId)")
            print("Found user \(secondUserId)")
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }

    func testListDevices() {
        let dc = IronOxide.DeviceContext(deviceContextJson: deviceJson)!
        let maybeDeviceList = IronOxide.initialize(device: dc)
            .flatMap { sdk in
                sdk.user.listDevices()
            }

        switch maybeDeviceList {
        case let .success(deviceListResult):
            print("Found \(deviceListResult.result.count) devices")
            print("Found \(deviceListResult.result[0].created)")
            print("Found \(deviceListResult.result[1].created)")
        case let .failure(error):
            XCTFail(error.localizedDescription)
        }
    }
}
