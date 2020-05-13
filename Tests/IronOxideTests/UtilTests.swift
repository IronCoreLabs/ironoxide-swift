@testable import IronOxide
import libironoxide
import XCTest

final class UtilTests: XCTestCase {
    func testassertCollectionCount() {
        let array = [DocumentId("1")!, DocumentId("2")!]
        assertCollectionCount(array, 2, fn: { $0.id })
    }

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
        let errorString = CRustString()
        let error = CRustResultUnionCRustOption4232mut3232c_voidCRustString(err: errorString)
        let reject = CRustResultCRustOption4232mut3232c_voidCRustString(data: error, is_ok: 0)

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

    func testRustVecToBytesi8() {
        let originalBytes: [UInt8] = [39, 77, 111, 111, 102, 33, 39, 0]
        let bytesCopy = originalBytes.map(Int8.init)

        let rustBytes = bytesCopy.withUnsafeBufferPointer { pt in
            CRustVeci8(data: pt.baseAddress, len: UInt(bytesCopy.count), capacity: UInt(bytesCopy.count))
        }
        let swiftBytes = Util.rustVecToBytes(rustBytes)
        XCTAssertEqual(swiftBytes, originalBytes)
    }

    func testRustVecToBytesi32() {
        let originalBytes: [UInt32] = [39, 77, 111, 111, 102, 33, 39, 0]
        let bytesCopy = originalBytes.map(Int32.init)

        let rustBytes = bytesCopy.withUnsafeBufferPointer { pt in
            CRustVeci32(data: pt.baseAddress, len: UInt(bytesCopy.count), capacity: UInt(bytesCopy.count))
        }
        let swiftBytes = Util.rustVecToBytes(rustBytes)
        XCTAssertEqual(swiftBytes, originalBytes)
    }
}
