@testable import IronOxide
import libironoxide
import XCTest

final class UserTests: ICLIntegrationTest {
    func testVerifyNonUser() throws {
        let verifyResult = try unwrapResult(IronOxide.userVerify(jwt: try generateJWT(nil)))
        XCTAssertNil(verifyResult)
    }

    func testVerifyUser() throws {
        let dc = try createUserAndDevice()
        let verifyResult = try unwrapResult(IronOxide.userVerify(jwt: try generateJWT(dc.accountId)))
        XCTAssertNotNil(verifyResult)
        XCTAssertEqual(verifyResult!.accountId, dc.accountId)
        XCTAssertEqual(verifyResult!.segmentId, 710)
        XCTAssertTrue(verifyResult!.needsRotation)
    }

    func testPrivateKeyRotation() throws {
        let dc = try createUserAndDevice()
        let sdk = try unwrapResult(IronOxide.initialize(device: dc))
        let rotationResult1 = try unwrapResult(sdk.user.rotatePrivateKey(password: "foo"))
        XCTAssertFalse(rotationResult1.needsRotation)
        let rotationResult2 = try unwrapResult(sdk.user.rotatePrivateKey(password: "foo"))
        XCTAssertNotEqual(rotationResult1.userMasterPrivateKey.bytes, rotationResult2.userMasterPrivateKey.bytes)
    }

    func testGenerateDeviceWithTimeout() throws {
        let jwt = try generateJWT()
        _ = try unwrapResult(IronOxide.userCreate(jwt: jwt, password: "foo"))
        // call will fail because timeout is too short
        let deviceResult = IronOxide.generateNewDevice(jwt: jwt, password: "foo", options: DeviceCreateOpts(), timeout: Duration(millis: 5))
        XCTAssertThrowsError(try deviceResult.get())
    }

    func testInitAndRotation() throws {
        let dc = try createUserAndDevice()
        let jwt = try generateJWT(dc.accountId)
        let verifyResult1 = try unwrapResult(IronOxide.userVerify(jwt: jwt))!
        XCTAssertTrue(verifyResult1.needsRotation)
        _ = try unwrapResult(IronOxide.initializeAndRotate(device: dc, password: "foo", timeout: Duration(seconds: 30)))
        let verifyResult2 = try unwrapResult(IronOxide.userVerify(jwt: jwt))!
        XCTAssertFalse(verifyResult2.needsRotation)
    }

    func testGetPublicKey() throws {
        let realUsers = [primaryTestUser!, secondaryTestUser!].sorted(by: { $0.id < $1.id })
        let fakeUsers = [UserId(UUID().uuidString)!]
        var userKeyList = try unwrapResult(primarySdk!.user.getPublicKey(users: realUsers + fakeUsers))
        // Sort users so we can assert on the expected values
        userKeyList = userKeyList.sorted(by: { $0.id.id < $1.id.id })
        userKeyList.forEach { assertByteLength($0.publicKey.bytes, 64) }
        XCTAssertTrue(userKeyList.map { $0.id }.elementsEqual(realUsers))
    }

    func testListDevices() throws {
        let deviceList = try unwrapResult(primarySdk!.user.listDevices()).result
        assertCollectionCountGreaterThan(deviceList, 0, fn: { $0.id.id })
        XCTAssertTrue(deviceList[0].isCurrentDevice)
        XCTAssertNil(deviceList[0].name)
        XCTAssertGreaterThan(deviceList[0].id.id, 0)
        XCTAssertTrue(deviceList[0].created < Date(timeIntervalSinceNow: 0))
        XCTAssertTrue(deviceList[0].lastUpdated < Date(timeIntervalSinceNow: 0))
    }

    func testDeviceDelete() throws {
        let jwt = try generateJWT()
        _ = try unwrapResult(IronOxide.userCreate(jwt: jwt, password: "foo"))
        let deviceAddResult = try unwrapResult(IronOxide.generateNewDevice(jwt: jwt, password: "foo"))
        let sdk = try unwrapResult(IronOxide.initialize(device: DeviceContext(deviceAddResult: deviceAddResult)))
        let deviceDeleteResult = try unwrapResult(sdk.user.deleteDevice(deviceId: deviceAddResult.deviceId))
        XCTAssertEqual(deviceAddResult.deviceId, deviceDeleteResult)
        // this call will fail because the device in `sdk` was deleted
        let groupList = sdk.group.list()
        XCTAssertThrowsError(try groupList.get())
    }
}
