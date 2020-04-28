import libironoxide
@testable import IronOxide
import XCTest

final class UtilTests: XCTestCase {
    let deviceJson = """
{"accountId": "swifttester33","segmentId": 1,"signingPrivateKey": "pI1SrCz4OffvmviszBATjaELD8tGUc18CixZ+evqeX3m3UKWkM5fsgg7Lt7YdtWPX/GoPUwrL0C7YLar2MEKTw==","devicePrivateKey": "RVBKa0AUEbUxkNJXbp2ErGN4bwIAs1WMZbMxacTGQe0="}
"""

    func testTimestampToDate() {
        let time: Int64 = 1587745315000
        let date = Util.timestampToDate(time)
        XCTAssertEqual(date.description, "2020-04-24 16:21:55 +0000")
    }

    func testIntFromBool() {
        XCTAssertEqual(Util.intFromBool(true), 1)
        XCTAssertEqual(Util.intFromBool(false), 0)
    }

    func testIsTrue() {
        XCTAssertTrue(Util.isTrue(Int8(1)))
        XCTAssertTrue(Util.isTrue(Int8(-1)))
        XCTAssertTrue(Util.isTrue(Int8(32)))
        XCTAssertTrue(Util.isTrue(Int8(-32)))
        XCTAssertTrue(Util.isTrue(Int8(127)))
        XCTAssertTrue(Util.isTrue(Int8(-127)))
        XCTAssertFalse(Util.isTrue(Int8(0)))

        XCTAssertTrue(Util.isTrue(UInt8(1)))
        XCTAssertTrue(Util.isTrue(UInt8(32)))
        XCTAssertTrue(Util.isTrue(UInt8(255)))
        XCTAssertFalse(Util.isTrue(UInt8(0)))
    }

    func testUtf8RoundTrip() {
        let original = "ℕ ⊆ ℕ₀ ⊂ ℤ ⊂ ℚ ⊂ ℝ ⊂ ℂ, ⊥ < a ≠ b ≡ c ≤ d ≪ ⊤ ⇒ (A ⇔"
        let into = Util.swiftStringToRust(original)
        let converted = CRustString(data: into.data, len: into.len, capacity: into.len)
        let roundtrip = Util.rustStringToSwift(converted)
        XCTAssertEqual(original, roundtrip)
    }

    static var allTests = [
        ("testTimestampToDate", testTimestampToDate),
        ("testIntFromBool", testIntFromBool),
        ("testIsTrue", testIsTrue),
        ("testUtf8RoundTrip", testUtf8RoundTrip),
    ]
}