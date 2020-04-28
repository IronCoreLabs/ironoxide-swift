import libironoxide
@testable import IronOxide
import XCTest

final class UserTests: XCTestCase {
    let deviceJson = """
{"accountId": "swifttester33","segmentId": 1,"signingPrivateKey": "pI1SrCz4OffvmviszBATjaELD8tGUc18CixZ+evqeX3m3UKWkM5fsgg7Lt7YdtWPX/GoPUwrL0C7YLar2MEKTw==","devicePrivateKey": "RVBKa0AUEbUxkNJXbp2ErGN4bwIAs1WMZbMxacTGQe0="}
"""

    func testListDevices() {
        let dc = IronOxide.DeviceContext(deviceContextJson: deviceJson)!
        let maybeDeviceList = IronOxide.initialize(device: dc)
            .flatMap {sdk in
                sdk.user.listDevices()
            }

        switch maybeDeviceList {
        case .success(let deviceListResult):
            print("Found \(deviceListResult.result.count) devices")
            print("Found \(deviceListResult.result[0].created)")
            print("Found \(deviceListResult.result[1].created)")
        case .failure(let error):
            print(error)
        }
    }

    static var allTests = [
        ("testListDevices", testListDevices),
    ]
}