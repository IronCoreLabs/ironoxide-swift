@testable import IronOxideSwift
import libironoxide
import XCTest

final class IronOxideSwiftTests: XCTestCase {
    func testUtf8RoundTrip() {
        let utf8Str = "ℕ ⊆ ℕ₀ ⊂ ℤ ⊂ ℚ ⊂ ℝ ⊂ ℂ, ⊥ < a ≠ b ≡ c ≤ d ≪ ⊤ ⇒ (A ⇔ "
        let into = Util.swiftStringToRust(utf8Str)
        let converted = CRustString(data: into.data, len: into.len, capacity: into.len)
        let out = Util.rustStringToSwift(str: converted, fallbackError: "Not valid utf8")
        XCTAssertEqual(utf8Str, out)
    }

    static var allTests = [
        ("testUtf8RoundTrip", testUtf8RoundTrip),
    ]
}
