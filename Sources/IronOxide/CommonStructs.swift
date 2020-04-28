import libironoxide

/**
 * Represents an asymmetric private key that wraps the underlying bytes of the key.
 */
public class PrivateKey {
    let inner: OpaquePointer
    init(_ pk: OpaquePointer) {
        inner = pk
    }

    /**
     * Create a new PrivateKey from the provided array of bytes. Will fail if the provided bytes are not a valid IronCore PrivateKey
     */
    public init?(_ bytes: [UInt8]) {
        switch Util.validateBytesAs(bytes: bytes, validator: PrivateKey_validate) {
        case .success(let privKey):
            inner = privKey
        case .failure:
            return nil
        }
    }

    /**
     * Get the PrivateKey data out as an array of bytes
     */
    public lazy var bytes: [UInt8] = {
        Util.toBytes(PrivateKey_asBytes(inner))
    }()

    deinit {PrivateKey_delete(inner)}
}

/**
 * Represents an encrypted asymmetric private key that wraps the underlying bytes of the encrypted key.
 */
public class EncryptedPrivateKey {
    let inner: OpaquePointer
    init(_ epk: OpaquePointer) {
        inner = epk
    }

    /**
     * Get the EncryptedPrivateKey data out as an array of bytes
     */
    public lazy var bytes: [UInt8] = {
        Util.toBytes(EncryptedPrivateKey_asBytes(inner))
    }()

    deinit {EncryptedPrivateKey_delete(inner)}
}

/**
 * Represents an asymmetric public key that wraps the underlying bytes of the key.
 */
public class PublicKey {
    let inner: OpaquePointer
    init(_ pk: OpaquePointer) {
        inner = pk
    }

    /**
     * Create a new PublicKey from the provided array of bytes. Will fail if the provided bytes are not a valid IronCore PublicKey
     */
    public init?(_ bytes: [UInt8]) {
        switch Util.validateBytesAs(bytes: bytes, validator: PublicKey_validate) {
        case .success(let pubKey):
            inner = pubKey
        case .failure:
            return nil
        }
    }

    /**
     * Get the PublicKey data out as an array of bytes
     */
    public lazy var bytes: [UInt8] = {
        Util.toBytes(PublicKey_asBytes(inner))
    }()

    deinit {PublicKey_delete(inner)}
}

/**
 * Signing keypair specific to a device. Used to sign all requests to the IronCore API endpoints. Needed to create a `DeviceContext`.
 */
public class DeviceSigningKeyPair {
    let inner: OpaquePointer
    init(_ pk: OpaquePointer) {
        inner = pk
    }

    /**
     * Create a new DeviceSigningKeyPair from the provided array of bytes. Will fail if the provided bytes are not a valid device signing key pair
     */
    public init?(_ bytes: [UInt8]) {
        switch Util.validateBytesAs(bytes: bytes, validator: DeviceSigningKeyPair_validate) {
        case .success(let dskp):
            inner = dskp
        case .failure:
            return nil
        }
    }

    /**
     * Get the DeviceSigningKeyPair data out as an array of bytes
     */
    public lazy var bytes: [UInt8] = {
        Util.toBytes(DeviceSigningKeyPair_asBytes(inner))
    }()

    deinit {DeviceSigningKeyPair_delete(inner)}
}

/**
 * ID of a user. Unique with in a segment.
 */
public class UserId {
    let inner: OpaquePointer
    init(_ id: OpaquePointer) {
        inner = id
    }

    /**
     * Create an new UserId from the provided String. Will fail if the ID contains invalid characters.
     */
    public init?(_ id: String) {
        switch Util.toResult(UserId_validate(Util.swiftStringToRust(id))) {
        case .success(let id):
            inner = id
        case .failure:
            return nil
        }
    }

    public lazy var id: String = {
        Util.rustStringToSwift(UserId_getId(inner))
    }()

    deinit {UserId_delete(inner)}
}

/**
 * ID of a device. Device IDs are numeric and will always be greater than 0.
 */
public class DeviceId {
    let inner: OpaquePointer
    init(_ id: OpaquePointer) {
        inner = id
    }

    /**
     * Create a new DeviceId from the provided Int64. Will fail if the device ID is not valid.
     */
    public init?(_ id: Int64) {
        switch Util.toResult(DeviceId_validate(id)) {
        case .success(let deviceId):
            inner = deviceId
        case .failure:
            return nil
        }
    }

    public lazy var id: Int64 = {
        DeviceId_getId(inner)
    }()

    deinit {DeviceId_delete(inner)}
}

/**
 * Readable device name.
 */
public class DeviceName {
    let inner: OpaquePointer
    init(_ name: OpaquePointer) {
        inner = name
    }

    /**
     * Create a DeviceName from the provided string. Will fail if the string contains invalid characters
     */
    public init?(_ name: String) {
        switch Util.toResult(DeviceName_validate(Util.swiftStringToRust(name))) {
        case .success(let deviceName):
            inner = deviceName
        case .failure:
            return nil
        }
    }

    public lazy var name: String = {
        Util.rustStringToSwift(DeviceName_getName(inner))
    }()

    deinit {DeviceName_delete(inner)}
}

/**
 * Account's device context. Needed to initialize IronOxide with a set of device keys.
 */
public class DeviceContext {
    let inner: OpaquePointer
    /**
     * Create a DeviceContext from the provided required device information.
     */
    public init(userId: UserId, segmentId: UInt64, devicePrivateKey: PrivateKey, signingPrivateKey: DeviceSigningKeyPair) {
        inner = DeviceContext_new(userId.inner, Int64(segmentId), devicePrivateKey.inner, signingPrivateKey.inner)
    }

    /**
     * Attempt to create a new device from the provided JSON string. Expects the keys to be
     *  - accountId: string
     *  - segmentId: int
     *  - devicePrivateKey: Base64 encoded string
     *  - signingPrivateKey: Base64 encoded string
     */
    public init?(deviceContextJson: String) {
        switch Util.toResult(DeviceContext_fromJsonString(Util.swiftStringToRust(deviceContextJson))) {
        case .success(let dc):
            inner = dc
        case .failure:
            return nil
        }
    }

    public lazy var accountId: UserId = {
        UserId(DeviceContext_getAccountId(inner))
    }()

    public lazy var segmentId: UInt = {
        DeviceContext_getSegmentId(inner)
    }()

    public lazy var devicePrivateKey: PrivateKey = {
        PrivateKey(DeviceContext_getDevicePrivateKey(inner))
    }()

    public lazy var signingPrivateKey: DeviceSigningKeyPair = {
        DeviceSigningKeyPair(DeviceContext_getDevicePrivateKey(inner))
    }()

    deinit { DeviceSigningKeyPair_delete(inner) }
}
