import struct Foundation.Date
import libironoxide

class Box<A> {
    var unbox: A
    init(_ value: A) {
        self.unbox = value
    }
}

struct Util {
    /// Convert the provided Int64 timestamp into a Swift date.
    static func timestampToDate(_ msTimestamp: Int64) -> Date {
        Date(timeIntervalSince1970: Double(msTimestamp) / 1000.0)
    }

    /// Convert the provided boolean into a Int8 expected by IronOxide for boolean arguments
    static func boolToInt(_ b: Bool) -> Int8 {
        b ? 1 : 0
    }

    /// Return true if the provided UInt8 represents a true value
    static func intToBool(_ int: UInt8) -> Bool {
        int != 0
    }

    /// Return true if the provided Int8 represents a true value
    static func intToBool(_ int: Int8) -> Bool {
        int != 0
    }

    /// Convert the provided IronOxide Result of opaque data into a Swift Result
    static func toResult(_ result: CRustResult4232mut3232c_voidCRustString) -> Result<OpaquePointer, IronOxideError> {
        Util.intToBool(result.is_ok) ?
            .success(OpaquePointer(result.data.ok)) :
            .failure(IronOxideError.error(Util.rustStringToSwift(result.data.err)))
    }

    /// Convert the provided IronOxide Result of an Option into a Swift Result
    static func toResult(_ result: CRustResultCRustOption4232mut3232c_voidCRustString) -> Result<CRustOption4232mut3232c_void, IronOxideError> {
        Util.intToBool(result.is_ok) ?
            .success(result.data.ok) :
            .failure(IronOxideError.error(Util.rustStringToSwift(result.data.err)))
    }

    /// Convert the provided IronOxide Result of a Vec into a Swift Result
    static func toResult(_ result: CRustResultCRustForeignVecCRustString) -> Result<CRustForeignVec, IronOxideError> {
        Util.intToBool(result.is_ok) ?
            .success(result.data.ok) :
            .failure(IronOxideError.error(Util.rustStringToSwift(result.data.err)))
    }

    /// Convert the provided IronOxide Result of a Vec of i32 into a Swift Result
    static func toResult(_ result: CRustResultCRustVeci32CRustString) -> Result<CRustVeci32, IronOxideError> {
        Util.intToBool(result.is_ok) ?
            .success(result.data.ok) :
            .failure(IronOxideError.error(Util.rustStringToSwift(result.data.err)))
    }

    /// Take the provided Rust result that on success contains an array of an IronOxide struct
    static func mapListResultTo<T>(result: CRustResultCRustForeignVecCRustString, to: (OpaquePointer) -> T) -> Result<[T], IronOxideError> {
        Util.toResult(result).map { rustList in
            Util.collectTo(list: rustList, to: to)
        }
    }

    /// Take the provided Rust result of Vec of i32 that on success contains an array of UInt32
    static func mapListResultToUInt32Array(_ result: CRustResultCRustVeci32CRustString) -> Result<[UInt32], IronOxideError> {
        Util.toResult(result).map { rustList in
            Util.rustVecToBytes(rustList)
        }
    }

    /// Convert the provided IronOxide Result of opaque data into a Swift Option
    static func toOption(_ result: CRustOption4232mut3232c_void) -> OpaquePointer? {
        Util.intToBool(result.is_some) ?
            OpaquePointer(result.val.data) :
            nil
    }

    /// Convert the provided IronOxide Option of i64 into a Swift Option
    static func toOption(_ result: CRustOptioni64) -> Int64? {
        Util.intToBool(result.is_some) ?
            result.val.data :
            nil
    }

    /// Convert the provided IronOxide Option of String into a Swift Option
    static func toOption(_ result: CRustOptionCRustString) -> String? {
        Util.intToBool(result.is_some) ?
            rustStringToSwift(result.val.data) :
            nil
    }

    /// Convert the provided Swift string into a string we can pass down to native IronOxide
    static func swiftStringToRust(_ str: String) -> CRustStrView {
        let count = str.utf8.count + 1
        let result = UnsafeMutablePointer<Int8>.allocate(capacity: count)
        str.withCString { baseAddress in
            result.initialize(from: baseAddress, count: count)
        }
        return CRustStrView(data: result, len: UInt(str.utf8.count))
    }

    /**
     Convert the provided UTF-8 native library string into a Swift string where the bytes are copied into Swift managed memory and
     the provided Rust string freed.
     */
    static func rustStringToSwift(_ str: CRustString) -> String {
        let bytes = Array(UnsafeBufferPointer(start: str.data, count: Int(str.len))).map(UInt8.init)
        // Rust strings are always UTF8, so we can ignore the error case here
        let swiftString = String(bytes: bytes, encoding: String.Encoding.utf8)!
        crust_string_free(str)
        return swiftString
    }

    /// Iterate over the provided list of a Rust vec and use the provided mapper to convert them to a collection of T
    static func collectTo<T>(list: CRustForeignVec, to: (OpaquePointer) -> T) -> [T] {
        var finalList: [T] = []
        // This is done because list is immutable and we're modifying it in our loop. Since we only access the data if
        // the list has any length, we're safe to ignore the pointer being nil
        var data = list.data!
        for _ in 0 ..< list.len {
            let item = UnsafeMutableRawPointer.allocate(byteCount: Int(list.step), alignment: 8)
            item.copyMemory(from: data, byteCount: Int(list.step))
            finalList.append(to(OpaquePointer(item)))
            data += UnsafeMutableRawPointer.Stride(list.step)
        }
        return finalList
    }

    /**
     Convert the provided Array of IronOxide bytes into Swift UInt8 bytes. The bytes will be copied into Swift managed memory and the
     original bytes in Rust freed
     */
    static func rustVecToBytes(_ bytes: CRustVeci8) -> [UInt8] {
        Array(UnsafeBufferPointer(start: bytes.data, count: Int(bytes.len))).map { UInt8(bitPattern: $0) }
    }

    /**
     Convert the provided Array of IronOxide bytes into Swift Int32 bytes. The bytes will be copied into Swift managed memory and the
     original bytes in Rust freed
     */
    static func rustVecToBytes(_ rustVec: CRustVeci32) -> [UInt32] {
        Array(UnsafeBufferPointer(start: rustVec.data, count: Int(rustVec.len))).map { UInt32(bitPattern: $0) }
    }

    /// Convert a Java NullableBoolean to a Swift Bool
    static func nullableBooleanToBool(_ nullableBoolean: OpaquePointer) -> Bool {
        Util.intToBool(NullableBoolean_getBoolean(nullableBoolean))
    }

    /// Converts an optional Swift type into a `CRustClassOpt*`
    static func buildOptionOf<T>(_ obj: SdkObject?, _ fn: (UnsafeMutableRawPointer?) -> T) -> T {
        obj == nil ? fn(nil) : fn(UnsafeMutableRawPointer(obj!.inner))
    }
}
