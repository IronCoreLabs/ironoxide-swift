import libironoxide
@testable import IronOxide
import XCTest

final class UtilTests: XCTestCase {
    func testTimestampToDate() {
        let time: Int64 = 1587745315000
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
}