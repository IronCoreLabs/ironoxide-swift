@testable import IronOxide
import libironoxide
import XCTest

final class CommonStructsTests: XCTestCase {
    func testRustBytesRoundtripEqualityUnsigned() {
        let bytes: [UInt8] = [52, 210, 38, 25, 8, 39]
        let rustBytes = RustBytes(bytes)
        XCTAssertEqual(rustBytes.count, bytes.count)
        let rustConvertedBytes = rustBytes.withSlice { $0 }
        XCTAssertEqual(rustConvertedBytes.len, UInt(bytes.count))
    }

    func testRustBytesRoundtripEqualitySigned() {
        let bytes: [Int8] = [52, -31, 38, 25, -120, 39]
        let rustBytes = RustBytes(bytes)
        XCTAssertEqual(rustBytes.count, bytes.count)
        let rustConvertedBytes = rustBytes.withSlice { $0 }
        XCTAssertEqual(rustConvertedBytes.len, UInt(bytes.count))
    }

    func testRustBytesValidateBytesAsFailure() {
        let originalBytes: [UInt8] = [39, 77, 111, 111, 102, 212, 39, 0]
        let rustBytes = RustBytes(originalBytes)
        let alwaysFailValidator: (CRustSlicei8) -> CRustResult4232mut3232c_voidCRustString = { rustSlice in
            XCTAssertEqual(rustSlice.len, UInt(originalBytes.count))
            return createRustReject()
        }
        let res = rustBytes.validateBytesAs(alwaysFailValidator)
        assertResultFailure(res, hasError: "")
    }

    func testRustBytesValidateBytesAsSuccess() throws {
        let originalBytes: [UInt8] = [39, 77, 111, 111, 102, 33, 39, 0]
        let rustBytes = RustBytes(originalBytes)
        let alwaysSuccessValidator: (CRustSlicei8) -> CRustResult4232mut3232c_voidCRustString = { rustSlice in
            XCTAssertEqual(rustSlice.len, UInt(originalBytes.count))
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
        let shortTimeout = Duration(millis: 5)
        // This will return a Result error because 5ms is not enough time to make the initialization call
        let sdk = IronOxide.initialize(device: dc, config: IronOxideConfig(policyCaching: PolicyCachingConfig(), sdkOperationTimeout: shortTimeout))
        XCTAssertThrowsError(try sdk.get())
    }

    func testInvalidJwt() throws {
        let jwt = Jwt("foo")
        XCTAssertNil(jwt)
    }

    func testValidJwt() throws {
        let jwt = try generateJWT()
        XCTAssertNotNil(jwt)
        XCTAssertEqual(jwt.algorithm, "ES256")
        XCTAssertEqual(jwt.claims.pid, 431)
        XCTAssertEqual(jwt.claims.sid, "Ironoxide-swift")
        XCTAssertEqual(jwt.claims.kid, 594)
        XCTAssertEqual(jwt.claims.exp, jwt.claims.iat + 120)
    }
}
