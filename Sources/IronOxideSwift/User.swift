import Foundation
import libironoxide

public struct UserId {
    var inner: OpaquePointer

    init(_ id: OpaquePointer) {
        inner = id
    }

    public init?(_ id: String) {
        let id = UserId_validate(Util.swiftStringToRust(id))
        if id.is_ok == 0 { return nil }
        inner = OpaquePointer(id.data.ok)
    }

    public func getId() -> String {
        return Util.rustStringToSwift(str: UserId_getId(inner), fallbackError: "Failed to extract user ID")
    }
}

public struct UserResult {
    var inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public func getAccountId() -> UserId {
        return UserId(UserResult_getAccountId(inner))
    }
}
