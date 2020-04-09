//
//  util.swift
//  ironoxide-swift
//
//  Created by Ernie Turner on 4/7/20.
//  Copyright © 2020 Ernie Turner. All rights reserved.
//

import Foundation

class Util {
    static func printWithTime(_ string: String) {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ss.SSS"
        print(formatter.string(from: date) + ": " + string)
    }

    static func makeRustString(_ str: String) -> CRustStrView{
        let count = str.utf8.count + 1
        let result = UnsafeMutablePointer<Int8>.allocate(capacity: count)
        str.withCString { (baseAddress) in
            result.initialize(from: baseAddress, count: count)
        }
        return CRustStrView(data: result, len: UInt(str.utf8.count))
    }

    static func mapRustString(rustStr: CRustString, fallbackError: String) -> String{
        let bytes = Array(UnsafeBufferPointer(start: rustStr.data, count: Int(rustStr.len))).map(UInt8.init)
        return String(bytes: bytes, encoding: String.Encoding.utf8) ?? fallbackError
    }
    
    static func mapRustResult(rustRes: CRustResult4232mut3232c_voidCRustString, fallbackError: String) -> Result<OpaquePointer, IronOxideError> {
        return rustRes.is_ok == 0 ?
        Result.failure(IronOxideError.runtimeError(Util.mapRustString(rustStr: rustRes.data.err, fallbackError: fallbackError))) :
        Result.success(OpaquePointer(rustRes.data.ok))
    }
    
    static func runIronOxideOp<T>(_ result: Result<T, IronOxideError>) {
        do {
            try result.get()
        }
        catch IronOxideError.runtimeError(let msg) {
            print(msg)
        }
        catch {
            print("Generic error failure")
        }
    }
}
