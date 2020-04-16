import libironoxide

/**
 * Verify a user given a JWT signed for that user. Returns a Some(UserResult) if the user ID in the JWT exists and is synced with
 * IronCore. If the user doesn't exist, returns a None
 */
public func userVerify(jwt: String) -> Result<UserResult?, IronOxideError> {
    // Hack in timeout duration stuff for now
    let val = CRustOptionUnion4232const3232c_void(uninit: 0)
    let timeout = CRustOption4232const3232c_void(val: val, is_some: 0)
    let op = IronOxide_userVerify(Util.swiftStringToRust(jwt), timeout)
    if op.is_ok == 0 {
        return Result.failure(IronOxideError.error(Util.rustStringToSwift(str: op.data.err, fallbackError: "Failed to make request to verify user.")))
    }
    return op.data.ok.is_some == 0 ?
        Result.success(Optional.none) :
        Result.success(UserResult(OpaquePointer(op.data.ok.val.data)))
}

public func userCreate() {}

public func generateNewDevice() {}

public func initialize() {}
