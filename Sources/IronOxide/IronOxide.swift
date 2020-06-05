import libironoxide

/// Top-level configuration object for IronOxide
public class IronOxideConfig: SdkObject {
    /**
     Constructs a default `IronOxideConfig`.

     The policy cache will have a maximum of 128 entries, and SDK operations will time-out after 30 seconds.
     */
    public convenience init() {
        self.init(IronOxideConfig_default())
    }

    /**
     Constructs an `IronOxideConfig` with the provided configuration parameters.

     - parameters:
        - policyCaching: Policy caching configuration for IronOxide
        - sdkOperationTimeout: Timeout for all SDK methods
     */
    public convenience init(policyCaching: PolicyCachingConfig, sdkOperationTimeout: Duration?) {
        let timeoutPtr = Util.buildOptionOf(sdkOperationTimeout, CRustClassOptDuration.init)
        self.init(IronOxideConfig_create(policyCaching.inner, timeoutPtr))
    }

    /// Configuration for maximum policy caching size
    public lazy var policyCachingConfig: PolicyCachingConfig = {
        PolicyCachingConfig(IronOxideConfig_getPolicyCachingConfig(inner))
    }()

    /// Time before SDK operations will time-out
    public lazy var sdkOperationTimeout: Duration? = {
        Util.toOption(IronOxideConfig_getSdkOperationTimeout(inner)).map(Duration.init)
    }()

    deinit { IronOxideConfig_delete(inner) }
}

/**
 Policy evaluation caching config

 Since policies are evaluated by the webservice, caching the result can greatly speed
 up encrypting a document with a PolicyGrant.
 */
public class PolicyCachingConfig: SdkObject {
    /**
     Constructs a default`PolicyCachingConfig`.

     The policy cache will have a maximum of 128 entries.
     */
    public convenience init() {
        self.init(PolicyCachingConfig_default())
    }

    /**
     Constructs a `PolicyCachingConfig` with the provided maximum policy cache size.

      - parameter maxEntries: maximum number of policy evaluations that will be cached by the SDK.
                              If the maximum number is exceeded, the cache will be cleared prior to storing the next entry.
     */
    public convenience init(maxEntries: UInt) {
        self.init(PolicyCachingConfig_create(maxEntries))
    }

    /// Maximum entries in the policy cache
    public lazy var maxEntries: UInt = {
        PolicyCachingConfig_getMaxEntries(inner)
    }()

    deinit { PolicyCachingConfig_delete(inner) }
}

/**
 Verifies the existence of a user using a JWT to identify their user record.

 Returns `nil` if the user could not be found.

 - parameters:
    - jwt: Valid IronCore or Auth0 JWT
    - timeout: Timeout for this operation or `nil` for no timeout
 */
public func userVerify(jwt: String, timeout: Duration? = nil) -> Result<UserResult?, IronOxideError> {
    let timeoutPtr = Util.buildOptionOf(timeout, CRustClassOptDuration.init)
    return Util.toResult(IronOxide_userVerify(Util.swiftStringToRust(jwt), timeoutPtr)).map { maybeUser in
        Util.toOption(maybeUser).map(UserResult.init)
    }
}

/**
 Creates a user.

 - parameters:
    - jwt: Valid IronCore or Auth0 JWT
    - password: Password to use for encrypting and escrowing the user's private key
    - options: User creation parameters
    - timeout: Timeout for this operation or `nil` for no timeout
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
 Generates a new device for the user specified in the JWT.

 This will result in a new transform key (from the user's master private key to the new device's public key)
 being generated and stored with the IronCore Service.

 - parameters:
    - jwt: Valid IronCore or Auth0 JWT
    - password: Password for the user specified in the JWT
    - options: Device creation parameters
    - timeout: Timeout for this operation or `nil` for no timeout
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
 Initializes the IronOxide SDK with a device.

 Verifies that the provided user/segment exists and the provided device keys are valid and
 exist for the provided account.

 - parameters:
    - device: Device to use to initialize the SDK
    - config: Configuration options to apply to the resulting SDK
 */
public func initialize(device: DeviceContext, config: IronOxideConfig = IronOxideConfig()) -> Result<SDK, IronOxideError> {
    Util.toResult(IronOxide_initialize(device.inner, config.inner)).map(SDK.init)
}

/**
 Initializes IronOxide with a device, then rotates private keys where necessary for the user and their groups.

 Verifies that the provided user/segment exists and the provided device keys are valid and exist for the provided account.
 After initialization, checks whether the calling user's private key needs rotation and rotates it if necessary,
 then does the same for each group the user is an admin of.

 This takes an optional `timeout` that is used for the rotation call. This is separate from the `config` timeout because it is expected
 that rotation could take significantly longer than other operations.

 - parameters:
    - device: Device to use to initialize the SDK
    - password: User's password needed for rotation
    - config: Configuration options to apply to the resulting SDK
    - timeout: Timeout to use for rotation
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
