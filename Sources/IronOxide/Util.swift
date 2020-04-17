import Foundation
import libironoxide

struct Util {
    /**
     * Convert the provided Swift string into a string we can pass down to native IronOxide
     */
    static func swiftStringToRust(_ str: String) -> CRustStrView {
        let count = str.utf8.count + 1
        let result = UnsafeMutablePointer<Int8>.allocate(capacity: count)
        str.withCString { baseAddress in
            result.initialize(from: baseAddress, count: count)
        }
        return CRustStrView(data: result, len: UInt(str.utf8.count))
    }

    /**
     * Convert the provided UTF-8 native library string into a Swift string
     */
    static func rustStringToSwift(str: CRustString, fallbackError: String) -> String {
        let bytes = Array(UnsafeBufferPointer(start: str.data, count: Int(str.len))).map(UInt8.init)
        return String(bytes: bytes, encoding: String.Encoding.utf8) ?? fallbackError
    }

    /**
     * Take the provided Rust result struct and convert it into a
     */
    static func mapResult(result: CRustResult4232mut3232c_voidCRustString, fallbackError: String) -> Result<OpaquePointer, IronOxideError> {
        result.is_ok == 0 ?
            Result.failure(IronOxideError.error(Util.rustStringToSwift(str: result.data.err, fallbackError: fallbackError))) :
            Result.success(OpaquePointer(result.data.ok))
    }
}
