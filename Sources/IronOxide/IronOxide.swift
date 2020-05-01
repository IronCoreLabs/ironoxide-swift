import libironoxide

/// Top-level configuration object for IronOxide
public class IronOxideConfig: SdkObject {
    public convenience init() {
        self.init(IronOxideConfig_default())
    }

    /**
     * - Parameter policyCaching: policy caching configuration for IronOxide
     * - Parameter sdkOperationTimeout: timeout for all SDK methods
     */
    public convenience init(policyCaching: PolicyCachingConfig, sdkOperationTimeout: Duration?) {
        let timeoutPtr = Util.buildOptionOf(sdkOperationTimeout, CRustClassOptDuration.init)
        self.init(IronOxideConfig_create(policyCaching.inner, timeoutPtr))
    }

    public lazy var policyCachingConfig: PolicyCachingConfig = {
        PolicyCachingConfig(IronOxideConfig_getPolicyCachingConfig(inner))
    }()

    public lazy var sdkOperationTimeout: Duration? = {
        Util.toOption(IronOxideConfig_getSdkOperationTimeout(inner)).map(Duration.init)
    }()

    deinit { IronOxideConfig_delete(inner) }
}

/**
 * Policy evaluation caching config
 *
 * Since policies are evaluated by the webservice, caching the result can greatly speed
 * up encrypting a document with a PolicyGrant.
 */
public class PolicyCachingConfig: SdkObject {
    public convenience init() {
        self.init(PolicyCachingConfig_default())
    }

    /**
     * - Parameter maxEntries: maximum number of policy evaluations that will be cached by the SDK.
     *                         If the maximum number is exceeded, the cache will be cleared prior to storing the next entry.
     */
    public convenience init(maxEntries: UInt) {
        self.init(PolicyCachingConfig_create(maxEntries))
    }

    public lazy var maxEntries: UInt = {
        PolicyCachingConfig_getMaxEntries(inner)
    }()

    deinit { PolicyCachingConfig_delete(inner) }
}

/**
 * Verify a user given a JWT signed for that user. Returns a Some(UserResult) if the user ID in the JWT exists and is synced with
 * IronCore. If the user doesn't exist, returns a None
 */
public func userVerify(jwt: String, timeout: Duration? = nil) -> Result<UserResult?, IronOxideError> {
    let timeoutPtr = Util.buildOptionOf(timeout, CRustClassOptDuration.init)
    return Util.toResult(IronOxide_userVerify(Util.swiftStringToRust(jwt), timeoutPtr)).map { maybeUser in
        Util.toOption(maybeUser).map(UserResult.init)
    }
}

/**
 * Create a new user within the IronCore system.
 */
public func userCreate(
    jwt: String,
    password: String,
    options: UserCreateOpts = UserCreateOpts(),
    timeout: Duration? = nil
) -> Result<UserCreateResult, IronOxideError> {
    let timeoutPtr = Util.buildOptionOf(timeout, CRustClassOptDuration.init)
    return Util.toResult(IronOxide_userCreate(
        Util.swiftStringToRust(jwt),
        Util.swiftStringToRust(password),
        options.inner,
        timeoutPtr
    )).map(UserCreateResult.init)
}

/**
 * Generates a new device for the user specified in the signed JWT. This will result in a new transform key (from the user's master private key to
 * the new device's public key) being generated and stored with the IronCore Service.
 */
public func generateNewDevice(
    jwt: String,
    password: String,
    options: DeviceCreateOpts = DeviceCreateOpts(),
    timeout: Duration? = nil
) -> Result<DeviceAddResult, IronOxideError> {
    let timeoutPtr = Util.buildOptionOf(timeout, CRustClassOptDuration.init)
    return Util.toResult(IronOxide_generateNewDevice(
        Util.swiftStringToRust(jwt),
        Util.swiftStringToRust(password),
        options.inner,
        timeoutPtr
    )).map(DeviceAddResult.init)
}

/**
 * Initialize IronOxide with a device. Verifies that the provided user/segment exists and the provided device keys are valid and exist for the provided account.
 */
public func initialize(device: DeviceContext, config: IronOxideConfig = IronOxideConfig()) -> Result<SDK, IronOxideError> {
    Util.toResult(IronOxide_initialize(device.inner, config.inner)).map(SDK.init)
}

/**
 * Initialize IronOxide with a device, then rotate private keys where necessary for the user and their groups.
 *
 * Verifies that the provided user/segment exists and the provided device keys are valid and exist for the provided account.
 * After initialization, checks whether the calling user's private key needs rotation and rotates it if necessary,
 * then does the same for each group the user is an admin of.
 *
 * This takes an optional `timeout` that is used for the rotation call. This is separate from the `config` timeout because it is expected
 * that rotation could take significantly longer than other operations.
 */
public func initializeAndRotate(
    device: DeviceContext,
    password: String,
    config: IronOxideConfig = IronOxideConfig(),
    timeout: Duration?
) -> Result<SDK, IronOxideError> {
    let timeoutPtr = Util.buildOptionOf(timeout, CRustClassOptDuration.init)
    return Util.toResult(IronOxide_initializeAndRotate(device.inner, Util.swiftStringToRust(password), config.inner, timeoutPtr)).map(SDK.init)
}
