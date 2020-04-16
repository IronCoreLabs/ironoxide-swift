import Foundation
import libironoxide

/**
 * ID of a user. Unique with in a segment.
 */
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

    public func id() -> String {
        Util.rustStringToSwift(str: UserId_getId(inner), fallbackError: "Failed to extract user ID")
    }
}

/**
 * IDs and public key for existing user on verify result
 */
public struct UserResult {
    var inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public func getAccountId() -> UserId {
        UserId(UserResult_getAccountId(inner))
    }

    public func getNeedsRotation() -> Bool {
        UserResult_getNeedsRotation(inner) == 1
    }

    public func getSegmentId() -> UInt {
        UserResult_getSegmentId(inner)
    }

    public func getUserPublicKey() -> PublicKey {
        PublicKey(UserResult_getUserPublicKey(inner))
    }
}
