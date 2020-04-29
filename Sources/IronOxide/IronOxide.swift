import libironoxide

/**
 * Verify a user given a JWT signed for that user. Returns a Some(UserResult) if the user ID in the JWT exists and is synced with
 * IronCore. If the user doesn't exist, returns a None
 */
public func userVerify(jwt: String) -> Result<UserResult?, IronOxideError> {
    Util.toResult(IronOxide_userVerify(Util.swiftStringToRust(jwt), CRustClassOptDuration())).map { maybeUser in
        Util.toOption(maybeUser).map(UserResult.init)
    }
}

/**
 * Create a new user within the IronCore system.
 */
public func userCreate(jwt: String, password: String, options: UserCreateOpts = UserCreateOpts()) -> Result<UserCreateResult, IronOxideError> {
    Util.toResult(IronOxide_userCreate(
        Util.swiftStringToRust(jwt),
        Util.swiftStringToRust(password),
        options.inner,
        CRustClassOptDuration()
    ))
        .map(UserCreateResult.init)
}

/**
 * Generates a new device for the user specified in the signed JWT. This will result in a new transform key (from the user's master private key to
 * the new device's public key) being generated and stored with the IronCore Service.
 */
public func generateNewDevice(jwt: String, password: String, options: DeviceCreateOpts = DeviceCreateOpts()) -> Result<DeviceAddResult, IronOxideError> {
    Util.toResult(IronOxide_generateNewDevice(
        Util.swiftStringToRust(jwt),
        Util.swiftStringToRust(password),
        options.inner,
        CRustClassOptDuration()
    ))
        .map(DeviceAddResult.init)
}

/**
 * Initialize IronOxide with a device. Verifies that the provided user/segment exists and the provided device keys are valid and exist for the provided account.
 */
public func initialize(device: DeviceContext) -> Result<SDK, IronOxideError> {
    Util.toResult(IronOxide_initialize(device.inner, IronOxideConfig_default())).map(SDK.init)
}
