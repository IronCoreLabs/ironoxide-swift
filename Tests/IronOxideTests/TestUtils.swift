import IronOxide
import libironoxide
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
    func assertByteLength(_ bytes: [UInt8], _ length: Int) {
        XCTAssertEqual(bytes.count, length, "Expected bytes of length \(bytes.count) to have length \(length)")
    }
}

let deviceJson = """
{"accountId": "swifttester33","segmentId": 1,"signingPrivateKey": "pI1SrCz4OffvmviszBATjaELD8tGUc18CixZ+evqeX3m3UKWkM5fsgg7Lt7YdtWPX/GoPUwrL0C7YLar2MEKTw==","devicePrivateKey": "RVBKa0AUEbUxkNJXbp2ErGN4bwIAs1WMZbMxacTGQe0="}
"""

let dc = IronOxide.DeviceContext(deviceContextJson: deviceJson)!

/**
 * Attempt to initialize the IronOxide SDK with the fixed deviceJson above
 */
func initializeSdk() throws -> SDK {
    let sdk = try IronOxide.initialize(device: dc).get()
    return sdk
}

/**
 * Get the DeviceContext struct for our primary unit test user
 */
func getPrimaryTestUserDeviceContext() -> DeviceContext { dc }

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
