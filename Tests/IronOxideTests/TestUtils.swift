import IronOxide
import libironoxide
import SwiftJWT
import XCTest

extension XCTestCase {
    /**
     * Unwrap the provided result and throw if the result was rejected with a useful error. Otherwise
     * return the unwrapped value.
     */
    func unwrapResult<S>(_ result: Result<S, IronOxide.IronOxideError>?,
                         in file: StaticString = #file,
                         line: UInt = #line) throws -> S {
        switch result {
        case let .success(wrappedResult):
            return wrappedResult
        case let .failure(error)?:
            XCTFail("Result was not successful: \(error.localizedDescription)", file: file, line: line)
        case nil:
            XCTFail("Result was nil", file: file, line: line)
        }
        throw IronOxideError.error("Result was invalid")
    }

    /**
     * Assert that the provided result is a rejection with the provided error message
     */
    func assertResultFailure<S>(_ result: Result<S, IronOxide.IronOxideError>?,
                                hasError expectedError: String,
                                in file: StaticString = #file,
                                line: UInt = #line) {
        switch result {
        case .success?:
            XCTFail("No error thrown", file: file, line: line)
        case let .failure(error)?:
            XCTAssertEqual(
                error.localizedDescription,
                expectedError,
                file: file, line: line
            )
        case nil:
            XCTFail("Result was nil", file: file, line: line)
        }
    }

    /**
     * Assert that the provided result is a success with the provided expectedValue. Value must have an EQ instance
     * in order to use this function for comparison.
     */
    func assertResultSuccess<S: Equatable>(_ result: Result<S, IronOxide.IronOxideError>?,
                                           hasValue expectedValue: S,
                                           in file: StaticString = #file,
                                           line: UInt = #line) {
        switch result {
        case let .success(val):
            XCTAssertEqual(
                val,
                expectedValue,
                file: file, line: line
            )
        case let .failure(error)?:
            XCTFail("Result rejected with \(error.localizedDescription)", file: file, line: line)
        case nil:
            XCTFail("Result was nil", file: file, line: line)
        }
    }

    /**
     * Assert that the provided bytes have the provided length.
     */
    func assertByteLength(_ bytes: [UInt8], _ length: Int, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(bytes.count, length, "Expected bytes of length \(bytes.count) to have length \(length)", file: file, line: line)
    }

    /**
     * Assert that an array of type S is a given length. Must provide a function to map S to String so it can be printed.
     */
    func assertArrayCount<S>(_ array: [S], _ length: Int, file: StaticString = #file, line: UInt = #line, _ fn: (S) -> String) {
        if array.count == length {
            XCTAssertEqual(array.count, length, file: file, line: line)
        } else {
            let message = "\nError: Expected array of length \(length), found array of length \(array.count): \(array.map { fn($0) }))"
            XCTAssertEqual(array.count, length, message, file: file, line: line)
        }
    }

    /**
     * Assert that an array of Strings has a given length
     */
    func assertArrayCount(_ array: [String], _ length: Int, file: StaticString = #file, line: UInt = #line) {
        assertArrayCount(array, length, file: file, line: line) { $0 }
    }
}

class ICLIntegrationTest: XCTestCase {
    override func setUpWithError() throws {
        if primarySdk == nil || primaryTestUser == nil || primaryTestUserDeviceContext == nil {
            XCTFail("Failed to create primary test user/SDK.")
            throw IronOxideError.error("Initialization failed")
        }
    }
}

/**
 * Convert the provided bytes into a UnsafeMutableRawPointer wrapper that can be used construct various
 * Rust structs
 */
func bytesToUnsafePointer(_ bytes: [UInt8]) -> UnsafeMutableRawPointer {
    let uint8Pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 8)
    uint8Pointer.initialize(from: bytes, count: 8)
    return UnsafeMutableRawPointer(uint8Pointer)
}

/**
 * Create a rejected result with an empty error message
 */
func createRustReject() -> CRustResult4232mut3232c_voidCRustString {
    let errorString = CRustString()
    let error = CRustResultUnion4232mut3232c_voidCRustString(err: errorString)
    return CRustResult4232mut3232c_voidCRustString(data: error, is_ok: 0)
}

struct MyClaims: Claims {
    let pid: Int
    let sid: String
    let kid: Int
    let iat: Int
    let exp: Int
    let sub: String
}

func generateJWT(_ userId: UserId? = nil) throws -> String {
    setenv("IRONCORE_ENV", "stage", 1)
    let projectId = 431
    let segmentId = "Ironoxide-swift"
    let identityAssertionKeyId = 594
    let iat = Int(NSDate().timeIntervalSince1970)
    let accountId = userId != nil ? userId!.id : UUID().uuidString
    let myClaims = MyClaims(pid: projectId, sid: segmentId, kid: identityAssertionKeyId, iat: iat, exp: iat + 120, sub: accountId)
    var myJWT = JWT(header: Header(), claims: myClaims)
    let key = Data(
        """
        -----BEGIN PRIVATE KEY-----
        MIGHAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBG0wawIBAQQgPscp0L2Y1RpVvs41
        W5ncdg5RvTldeb+wB/AsStrTAQuhRANCAARrORv9Ub2bGfvevuovDb/zj61AcLqy
        8ZaZbze8FsvGg15XfGdCOjk+OLqOU04OSWp3cq0eyMT2uWA4/GR9EI2D
        -----END PRIVATE KEY-----
        -----BEGIN PUBLIC KEY-----
        MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEazkb/VG9mxn73r7qLw2/84+tQHC6
        svGWmW83vBbLxoNeV3xnQjo5Pji6jlNODklqd3KtHsjE9rlgOPxkfRCNgw==
        -----END PUBLIC KEY-----
        """.utf8)
    if #available(macOS 10.13, *) {
        let jwtSigner = JWTSigner.es256(privateKey: key)
        return try myJWT.sign(using: jwtSigner)
    }
    throw IronOxideError.error("Unable to sign JWT. ES256 requires OSX 10.13 or later.")
}

/**
 * Helper function to make a new user and device with an optional UserId. Returns only the DeviceContext,
 * as the UserId can be obtained from `device.accountId`
 */
func createUserAndDevice(_ userId: UserId? = nil) throws -> DeviceContext {
    let jwt = try generateJWT(userId)
    let password = "foo"
    let opts = UserCreateOpts(needsRotation: true)
    _ = IronOxide.userCreate(jwt: jwt, password: password, options: opts)
    let newDevice = try IronOxide.generateNewDevice(jwt: jwt, password: password).get()
    return DeviceContext(deviceAddResult: newDevice)
}

/**
 * Private variable that calls and holds the primary test user's SDK and DeviceContext. Meant to be private to
 * force use of `primaryTestUser`, `primaryTestUserDeviceContext`, and `primarySDK`.
 */
private let createPrimaryTestUser: (SDK?, DeviceContext?) = {
    let maybeDevice = try? createUserAndDevice()
    let maybeSdk = try? maybeDevice.flatMap { device in IronOxide.initialize(device: device) }?.get()
    return (maybeSdk, maybeDevice)
}()

/**
 * UserId for test user created at start of tests. It's encouraged to use this user
 * when it's not necessary to create a new one for a given test.
 */
let primaryTestUser: UserId? = {
    let (_, device) = createPrimaryTestUser
    return device?.accountId
}()

/// DeviceContext for `primaryTestUser`
let primaryTestUserDeviceContext: DeviceContext? = {
    let (_, device) = createPrimaryTestUser
    return device
}()

/// SDK initialized by `primaryTestUser`
let primarySdk: SDK? = {
    let (sdk, _) = createPrimaryTestUser
    return sdk
}()

/**
 * Private variable that calls and holds a secondary test user's SDK and DeviceContext. Meant to be private to
 * force use of `secondaryTestUser`, `secondaryTestUserDeviceContext`.
 */
private let createSecondaryTestUser: DeviceContext? = {
    let maybeDevice = try? createUserAndDevice()
    return maybeDevice
}()

/// Secondary UserId for test user created at start of tests
let secondaryTestUser: UserId? = {
    let device = createSecondaryTestUser
    return device?.accountId
}()

/// DeviceContext for `secondaryTestUser`
let secondaryTestUserDeviceContext: DeviceContext? = {
    let device = createSecondaryTestUser
    return device
}()
