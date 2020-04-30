import IronOxide
import XCTest

extension XCTestCase {
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

    func assertByteLength(_ bytes: [UInt8], _ length: Int) {
        XCTAssertEqual(bytes.count, length, "Expected bytes of length \(bytes.count) to have length \(length)")
    }
}

let deviceJson = """
{"accountId": "swifttester33","segmentId": 1,"signingPrivateKey": "pI1SrCz4OffvmviszBATjaELD8tGUc18CixZ+evqeX3m3UKWkM5fsgg7Lt7YdtWPX/GoPUwrL0C7YLar2MEKTw==","devicePrivateKey": "RVBKa0AUEbUxkNJXbp2ErGN4bwIAs1WMZbMxacTGQe0="}
"""

let dc = IronOxide.DeviceContext(deviceContextJson: deviceJson)!

func initializeSdk() throws -> SDK {
    let sdk = try IronOxide.initialize(device: dc).get()
    return sdk
}

func getPrimaryTestUserDeviceContext() -> DeviceContext { dc }
