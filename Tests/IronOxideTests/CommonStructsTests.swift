@testable import IronOxide
import libironoxide
import XCTest

final class CommonStructsTests: XCTestCase {
    func testRustBytesRoundtripEqualityUnsigned() {
        let bytes: [UInt8] = [52, 210, 38, 25, 8, 39]
        let rustBytes = RustBytes(bytes)
        XCTAssertEqual(rustBytes.count, bytes.count)

        let rustConvertedBytes = RustBytes(rustBytes.slice)
        XCTAssertEqual(rustConvertedBytes.count, bytes.count)

        XCTAssertEqual(rustBytes, rustConvertedBytes)
    }

    func testRustBytesRoundtripEqualitySigned() {
        let bytes: [Int8] = [52, -31, 38, 25, -120, 39]
        let rustBytes = RustBytes(bytes)
        XCTAssertEqual(rustBytes.count, bytes.count)

        let rustConvertedBytes = RustBytes(rustBytes.slice)
        XCTAssertEqual(rustConvertedBytes.count, bytes.count)

        XCTAssertEqual(rustBytes, rustConvertedBytes)
    }

    func testRustBytesValidateBytesAsFailure() {
        let originalBytes: [UInt8] = [39, 77, 111, 111, 102, 212, 39, 0]
        let rustBytes = RustBytes(originalBytes)
        let alwaysFailValidator: (CRustSlicei8) -> CRustResult4232mut3232c_voidCRustString = { rustSlice in
            let convertedRustBytes = RustBytes(rustSlice)
            XCTAssertEqual(convertedRustBytes.count, originalBytes.count)
            XCTAssertEqual(convertedRustBytes, rustBytes)
            return createRustReject()
        }

        let res = rustBytes.validateBytesAs(alwaysFailValidator)
        assertResultFailure(res, hasError: "")
    }

    func testRustBytesValidateBytesAsSuccess() throws {
        let originalBytes: [UInt8] = [39, 77, 111, 111, 102, 33, 39, 0]
        let rustBytes = RustBytes(originalBytes)
        let alwaysSuccessValidator: (CRustSlicei8) -> CRustResult4232mut3232c_voidCRustString = { rustSlice in
            let convertedRustBytes = RustBytes(rustSlice)
            XCTAssertEqual(convertedRustBytes.count, originalBytes.count)
            XCTAssertEqual(convertedRustBytes, rustBytes)

            let pointerWrapper = bytesToUnsafePointer(originalBytes)
            let data = CRustResultUnion4232mut3232c_voidCRustString(ok: pointerWrapper)
            return CRustResult4232mut3232c_voidCRustString(data: data, is_ok: 1)
        }

        let success = try unwrapResult(rustBytes.validateBytesAs(alwaysSuccessValidator))
        let pointerWrapper = UnsafeMutableRawPointer(success).assumingMemoryBound(to: UInt8.self)
        let theEnd = Array(UnsafeBufferPointer(start: pointerWrapper, count: originalBytes.count))
        XCTAssertEqual(theEnd, originalBytes)
    }

    func testSdkTimeout() throws {
        let dc = try createUserAndDevice()
        let sdk = initialize(device: dc, config: IronOxideConfig(policyCaching: PolicyCachingConfig(), sdkOperationTimeout: Duration(millis: 5)))
        XCTAssertThrowsError(try sdk.get())
    }
}
