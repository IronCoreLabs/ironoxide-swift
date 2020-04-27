import libironoxide
import struct Foundation.Date

struct Util {
    /**
     * Convert the provided Int64 timestamp into a Swift date.
     */
    static func timestampToDate(_ ts: Int64) -> Date {
        Date(timeIntervalSince1970: Double(ts))
    }

    /**
     * Convert the provided boolean into a Int8 expected by IronOxide for boolean arguments
     */
    static func intFromBool(_ b: Bool) -> Int8 {
        b ? 1 : 0
    }

    /**
     * Return true if the provided UInt8 represents a true value
     */
    static func isTrue(_ int: UInt8) -> Bool {
        int != 0
    }

    /**
     * Return true if the provided Int8 represents a true value
     */
    static func isTrue(_ int: Int8) -> Bool {
        int != 0
    }

    /**
     * Convert the provided IronOxide Result of opaque data into a Swift Result
     */
    static func toResult(_ result: CRustResult4232mut3232c_voidCRustString) -> Result<OpaquePointer, IronOxideError> {
        Util.isTrue(result.is_ok) ?
            .success(OpaquePointer(result.data.ok)) :
            .failure(IronOxideError.error(Util.rustStringToSwift(result.data.err)))
    }

    /**
     * Convert the provided IronOxide Result of an Option into a Swift Result
     */
    static func toResult(_ result: CRustResultCRustOption4232mut3232c_voidCRustString) -> Result<CRustOption4232mut3232c_void, IronOxideError> {
        Util.isTrue(result.is_ok) ?
            .success(result.data.ok) :
            .failure(IronOxideError.error(Util.rustStringToSwift(result.data.err)))
    }

    /**
     * Convert the provided IronOxide Result of a Vec into a Swift Result
     */
    static func toResult(_ result: CRustResultCRustForeignVecCRustString) -> Result<CRustForeignVec, IronOxideError> {
        Util.isTrue(result.is_ok) ?
            .success(result.data.ok) :
            .failure(IronOxideError.error(Util.rustStringToSwift(result.data.err)))
    }

    /**
     * Take the provided Rust result that on success contains an array of an IronOxide struct
     */
    static func mapListResultTo<T>(result: CRustResultCRustForeignVecCRustString, to: (OpaquePointer) -> T) -> Result<[T], IronOxideError> {
        Util.toResult(result).map {rustList in
            Util.collectTo(list: rustList, to: to)
        }
    }

    /**
     * Convert the provided IronOxide Result of opaque data into a Swift Option
     */
    static func toOption(_ result: CRustOption4232mut3232c_void) -> OpaquePointer? {
        Util.isTrue(result.is_some) ?
            OpaquePointer(result.val.data) :
            nil
    }

    /**
     * Convert the provided Array of IronOxide bytes into Swift UInt8 bytes
     */
    static func toBytes(_ bytes: CRustVeci8) -> [UInt8] {
        Array(UnsafeBufferPointer(start: bytes.data, count: Int(bytes.len))).map(UInt8.init)
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
     * Iterate over the provided list of a Rust vec and use the provided mapper to convert them to a collection of T
     */
    static func collectTo<T>(list: CRustForeignVec, to: (OpaquePointer) -> T) -> [T] {
        //var listCopy = list //Shallow copy since the argument for map is immutable
        var finalList: [T] = []
        //This is done becuase list is immutable and we're modifying it in our loop. Since we only access the data if
        //the list has any length, we're safe to ignore the pointer being nil
        var data = list.data!
        for _ in 0 ..< list.len {
            finalList.append(to(OpaquePointer(data)))
            data += UnsafeMutableRawPointer.Stride(list.step)
        }
        return finalList
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
    static func validateBytesAs(bytes: [UInt8], validator: (CRustSlicei8) -> CRustResult4232mut3232c_voidCRustString) -> Result<OpaquePointer, IronOxideError> {
        let rustSlice = CRustSlicei8(data: Util.bytesToPointer(bytes), len: UInt(bytes.capacity))
        return Util.toResult(validator(rustSlice))
    }
}
