import libironoxide

/**
 * Verify a user given a JWT signed for that user. Returns a Some(UserResult) if the user ID in the JWT exists and is synced with
 * IronCore. If the user doesn't exist, returns a None
 */
public func userVerify(jwt: String) -> Result<UserResult?, IronOxideError> {
    let op = IronOxide_userVerify(Util.swiftStringToRust(jwt), Util.rustNone())
    if op.is_ok == 0 {
        return Result.failure(IronOxideError.error(Util.rustStringToSwift(str: op.data.err, fallbackError: "Failed to verify user.")))
    }
    return op.data.ok.is_some == 0 ?
        Result.success(Optional.none) :
        Result.success(UserResult(OpaquePointer(op.data.ok.val.data)))
}

/**
 * Create a new user within the IronCore system.
 */
public func userCreate(jwt: String, password: String, options: UserCreateOpts = UserCreateOpts()) -> Result<UserCreateResult, IronOxideError> {
    let rJwt = Util.swiftStringToRust(jwt)
    let rPassword = Util.swiftStringToRust(password)
    return Util.mapResult(result: IronOxide_userCreate(rJwt, rPassword, options.inner, Util.rustNone()), fallbackError: "Failed to create user.")
        .map { res in
            UserCreateResult(res)
        }
}

/**
 * Generates a new device for the user specified in the signed JWT. This will result in a new transform key (from the user's master private key to
 * the new device's public key) being generated and stored with the IronCore Service.
 */
public func generateNewDevice(jwt: String, password: String, options: DeviceCreateOpts = DeviceCreateOpts()) -> Result<DeviceAddResult, IronOxideError> {
    let rJwt = Util.swiftStringToRust(jwt)
    let rPassword = Util.swiftStringToRust(password)
    return Util.mapResult(result: IronOxide_generateNewDevice(rJwt, rPassword, options.inner, Util.rustNone()), fallbackError: "Failed to create device.")
        .map { res in
            DeviceAddResult(res)
        }
}

/**
 * Initialize IronOxide with a device. Verifies that the provided user/segment exists and the provided device keys are valid and exist for the provided account.
 */
public func initialize(device: DeviceContext) -> Result<SDK, IronOxideError> {
    return Util.mapResult(result: IronOxide_initialize(device.inner, IronOxideConfig_default()), fallbackError: "Failed to initialize IronOxide.")
        .map { res in
            SDK(res)
        }
}
