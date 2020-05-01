@testable import IronOxide
import libironoxide
import XCTest

func bytesToUnsafePointer(_ bytes: [UInt8]) -> UnsafeMutableRawPointer {
    let uint8Pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 8)
    uint8Pointer.initialize(from: bytes, count: 8)
    return UnsafeMutableRawPointer(uint8Pointer)
}

func createRustOptionReject() -> CRustResultCRustOption4232mut3232c_voidCRustString {
    let errorString = CRustString()
    let error = CRustResultUnionCRustOption4232mut3232c_voidCRustString(err: errorString)
    return CRustResultCRustOption4232mut3232c_voidCRustString(data: error, is_ok: 0)
}

func createRustReject() -> CRustResult4232mut3232c_voidCRustString {
    let errorString = CRustString()
    let error = CRustResultUnion4232mut3232c_voidCRustString(err: errorString)
    return CRustResult4232mut3232c_voidCRustString(data: error, is_ok: 0)
}

func createRustSuccessWithBytes(_ bytes: [UInt8]) -> CRustResult4232mut3232c_voidCRustString {
    let pointerWrapper = bytesToUnsafePointer(bytes)
    let data = CRustResultUnion4232mut3232c_voidCRustString(ok: pointerWrapper)
    return CRustResult4232mut3232c_voidCRustString(data: data, is_ok: 1)
}

final class UtilTests: XCTestCase {
    func testTimestampToDate() {
        let time: Int64 = 1_587_745_315_000
        let date = Util.timestampToDate(time)
        XCTAssertEqual(date.description, "2020-04-24 16:21:55 +0000")
    }

    func testBoolToInt() {
        XCTAssertEqual(Util.boolToInt(true), 1)
        XCTAssertEqual(Util.boolToInt(false), 0)
    }

    func testIntToBool() {
        XCTAssertTrue(Util.intToBool(Int8(1)))
        XCTAssertTrue(Util.intToBool(Int8(-1)))
        XCTAssertTrue(Util.intToBool(Int8(32)))
        XCTAssertTrue(Util.intToBool(Int8(-32)))
        XCTAssertTrue(Util.intToBool(Int8(127)))
        XCTAssertTrue(Util.intToBool(Int8(-127)))
        XCTAssertFalse(Util.intToBool(Int8(0)))

        XCTAssertTrue(Util.intToBool(UInt8(1)))
        XCTAssertTrue(Util.intToBool(UInt8(32)))
        XCTAssertTrue(Util.intToBool(UInt8(255)))
        XCTAssertFalse(Util.intToBool(UInt8(0)))
    }

    func testUtf8RoundTrip() {
        let original = "ℕ ⊆ ℕ₀ ⊂ ℤ ⊂ ℚ ⊂ ℝ ⊂ ℂ, ⊥ < a ≠ b ≡ c ≤ d ≪ ⊤ ⇒ (A ⇔"
        let into = Util.swiftStringToRust(original)
        let converted = CRustString(data: into.data, len: into.len, capacity: into.len)
        let roundtrip = Util.rustStringToSwift(converted)
        XCTAssertEqual(original, roundtrip)
    }

    func testToResultOpaquePointerWithFailure() {
        assertResultFailure(Util.toResult(createRustReject()), hasError: "")
    }

    func testToResultOpaquePointerWithSuccess() {
        let bytes: [UInt8] = [39, 77, 111, 111, 102, 33, 39, 0]
        let pointerWrapper = bytesToUnsafePointer(bytes)
        let data = CRustResultUnion4232mut3232c_voidCRustString(ok: pointerWrapper)
        let success = CRustResult4232mut3232c_voidCRustString(data: data, is_ok: 1)

        assertResultSuccess(Util.toResult(success), hasValue: OpaquePointer(pointerWrapper))
    }

    func testToResultOptionWithFailure() {
        let reject = createRustOptionReject()

        assertResultFailure(Util.toResult(reject), hasError: "")
    }

    func testToResultOptionWithSuccess() throws {
        let bytes: [UInt8] = [39, 77, 111, 111, 102, 33, 39, 0]
        let pointerWrapper = bytesToUnsafePointer(bytes)

        let optionSome = CRustOption4232mut3232c_void(
            val: CRustOptionUnion4232mut3232c_void(data: pointerWrapper),
            is_some: 1
        )

        let data = CRustResultUnionCRustOption4232mut3232c_voidCRustString(ok: optionSome)
        let success = CRustResultCRustOption4232mut3232c_voidCRustString(data: data, is_ok: 1)

        let some = try unwrapResult(Util.toResult(success))
        XCTAssertEqual(some.is_some, 1)
        XCTAssertEqual(some.val.data, pointerWrapper)
    }

    func testToOptionNone() {
        let optionNone = CRustOption4232mut3232c_void(
            val: CRustOptionUnion4232mut3232c_void(uninit: 0),
            is_some: 0
        )
        XCTAssertNil(Util.toOption(optionNone))
    }

    func testToOptionSome() {
        let bytes: [UInt8] = [39, 77, 111, 111, 102, 33, 39, 0]
        let pointerWrapper = bytesToUnsafePointer(bytes)

        let optionSome = CRustOption4232mut3232c_void(
            val: CRustOptionUnion4232mut3232c_void(data: pointerWrapper),
            is_some: 1
        )
        XCTAssertNotNil(optionSome)
        XCTAssertEqual(optionSome.val.data, pointerWrapper)
    }

    func rustVecToBytes() {
        let originalBytes: [UInt8] = [39, 77, 111, 111, 102, 33, 39, 0]
        let bytesCopy = originalBytes.map(Int8.init)

        let rustBytes = bytesCopy.withUnsafeBufferPointer { pt in
            CRustVeci8(data: pt.baseAddress, len: UInt(bytesCopy.count), capacity: UInt(bytesCopy.count))
        }
        let swiftBytes = Util.rustVecToBytes(rustBytes)
        XCTAssertEqual(swiftBytes, originalBytes)
    }

    func testBytesToRustSlice() {
        let originalBytes: [UInt8] = [39, 77, 111, 111, 102, 33, 39, 0]
        let rustSlice = Util.bytesToRustSlice(originalBytes)

        XCTAssertEqual(rustSlice.len, UInt(originalBytes.count))
        // let newBytes = Array(UnsafeBufferPointer(start: rustSlice.data, count: Int(rustSlice.len)))
        // XCTAssertEqual(newBytes, originalBytes.map(Int8.init))
    }

    func testRustSlice() {
        let originalBytes: [Int8] = [39, 77, 111, 111, 102, 33, 39, 0]
        // We don't want the bytes to be freed until we're ready, so increment the retention count
        // Unmanaged only works on classes, so we have to wrap in a class for this to work -- Box in this case.
        let retainedBytes = Unmanaged.passRetained(Box(originalBytes))
        // A change to the underlying array could render this pointer invalid.
        // We've expressly retained the value so this ptr is safe until we release if not mutated.
        let ptr = UnsafePointer(originalBytes)
        // We'll decrement the retained value when this block goes out of scope.
        // Ideally this happens after rust is done with thee CRustSlicei8.
        defer {
            retainedBytes.release()
        }
        // Make the slice
        let rustSlice = CRustSlicei8(data: Optional(ptr), len: UInt(originalBytes.count))
        // Let's go back from the rust slice pointer to an array of bytes
        let newBytes: [Int8] = Array(UnsafeBufferPointer(start: rustSlice.data, count: Int(rustSlice.len)))
        XCTAssertEqual(newBytes, originalBytes)
    }

    func testValidateBytesAsFailure() throws {
        let originalBytes: [UInt8] = [39, 77, 111, 111, 102, 33, 39, 0]
        let alwaysFailValidator: (CRustSlicei8) -> CRustResult4232mut3232c_voidCRustString = { rustSlice in
            // TODO: Figure out why this fails
            XCTAssertEqual(rustSlice.len, UInt(originalBytes.count))
            let buffer = UnsafeBufferPointer(start: rustSlice.data, count: Int(rustSlice.len))
            // XCTAssertEqual(Array(buffer), originalBytes.map(Int8.init))
            return createRustReject()
        }

        assertResultFailure(Util.validateBytesAs(bytes: originalBytes, validator: alwaysFailValidator), hasError: "")
    }

    func testValidateBytesAsSuccess() throws {
        let originalBytes: [UInt8] = [39, 77, 111, 111, 102, 33, 39, 0]
        let alwaysSuccessValidator: (CRustSlicei8) -> CRustResult4232mut3232c_voidCRustString = { _ in
            createRustSuccessWithBytes(originalBytes)
        }

        let success = try unwrapResult(Util.validateBytesAs(bytes: originalBytes, validator: alwaysSuccessValidator))

        let pointerWrapper = UnsafeMutableRawPointer(success).assumingMemoryBound(to: UInt8.self)
        let theEnd = Array(UnsafeBufferPointer(start: pointerWrapper, count: originalBytes.count))
        XCTAssertEqual(theEnd, originalBytes)
    }
}
