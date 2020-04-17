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

    /**
     * Generate the struct that represents a None in Rust
     */
    static func rustNone() -> CRustOption4232const3232c_void {
        CRustOption4232const3232c_void(
            val: CRustOptionUnion4232const3232c_void(uninit: 0),
            is_some: 0
        )
    }

    /**
     * Generate the struct that represents a Some() in Rust of the provided pointer data
     */
    static func rustSome(_ ptr: OpaquePointer) -> CRustOption4232const3232c_void {
        CRustOption4232const3232c_void(
            val: CRustOptionUnion4232const3232c_void(data: UnsafeMutableRawPointer(ptr)),
            is_some: 1
        )
    }

    /**
     * Convert the provided byte array into an OpaquePointer that we can pass to libironoxide
     */
    static func bytesToPointer(_ bytes: [UInt8]) -> UnsafePointer<Int8> {
        // TODO: Figure out what this means and if we should figure out how to remove the ! at the end
        bytes.map(Int8.init).withUnsafeBufferPointer { pointerVal in pointerVal.baseAddress! }
    }

    /**
     * Conver the provided byte array into a Rust int8 slice
     */
    static func bytesToSlice(_ bytes: [UInt8]) -> CRustSlicei8 {
        CRustSlicei8(data: Util.bytesToPointer(bytes), len: UInt(bytes.count))
    }

    /**
     * Generic method to validate that the provided bytes can be used to create the type validated by validator.
     */
    static func validateBytesAs(bytes: [UInt8], validator: (CRustSlicei8) -> CRustResult4232mut3232c_voidCRustString) -> OpaquePointer? {
        let rustSlice = CRustSlicei8(data: Util.bytesToPointer(bytes), len: UInt(bytes.capacity))
        let rpk = validator(rustSlice)
        if rpk.is_ok == 0 { return nil }
        return OpaquePointer(rpk.data.ok)
    }
}
