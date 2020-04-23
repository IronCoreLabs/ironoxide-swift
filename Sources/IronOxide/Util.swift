import Foundation
import libironoxide

struct Util {
    /**
     * Convert the provided Int64 timestamp into a Swift date.
     */
    static func timestampToDate(_ ts: Int64) -> Date {
        Date(timeIntervalSince1970: Double(ts))
    }

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
    static func rustStringToSwift(_ str: CRustString) -> String {
        let bytes = Array(UnsafeBufferPointer(start: str.data, count: Int(str.len))).map(UInt8.init)
        //Rust strings are always UTF8, so we can ignore the error case here
        return String(bytes: bytes, encoding: String.Encoding.utf8)!
    }

    /**
     * Take the provided Rust result that on success contains an IronOxide struct and wrap that in the provided Swift `to` struct.
     * If the result is a failure, attempt to parse out the failure and wrap the error string in an IronOxideError.
     */
    static func mapResultTo<T>(result: CRustResult4232mut3232c_voidCRustString, to: (OpaquePointer) -> T) -> Result<T, IronOxideError> {
        result.is_ok == 0 ?
            Result.failure(IronOxideError.error(Util.rustStringToSwift(result.data.err))) :
            Result.success(to(OpaquePointer(result.data.ok)))
    }

    /**
     * Take the provided Rust result that on success contains an array of an IronOxide struct
     */
    static func mapListResultTo<T>(result: CRustResultCRustForeignVecCRustString, to: (OpaquePointer) -> T) -> Result<[T], IronOxideError> {
        if result.is_ok == 1 {
            var rustList = result.data.ok
            var finalList: [T] = []
            for _ in 0 ..< rustList.len {
                finalList.append(to(OpaquePointer(rustList.data)))
                rustList.data += UnsafeMutableRawPointer.Stride(rustList.step)
            }
            return Result.success(finalList)
        } else {
            return Result.failure(IronOxideError.error(Util.rustStringToSwift(result.data.err)))
        }
    }


    /**
     * Generate the struct that represents a None in Rust
     */
    static func rustNone() -> CRustOption4232const3232c_void {
        CRustOption4232const3232c_void(
            //This uses 0 for uninit because that's what the rust-swig code does to represent None
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
        // We can use the ! on baseAddress because the closure we pass to withUnsafeBufferPointer says:
        //   - A closure with an UnsafeBufferPointer parameter that points to the contiguous storage for the array. If no such storage exists, it is created.
        // So it should always exist
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
