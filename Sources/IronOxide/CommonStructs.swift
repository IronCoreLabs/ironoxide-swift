import libironoxide

/**
 * Superclass to all SDK classes. The data of the class is stored in `inner`, and there is an internal `init` for setting the data.
 *
 * Requires subclass inits to be `convenience init` which call `self.init` to set `inner`
 */
public class SdkObject {
    let inner: OpaquePointer
    init(_ t: OpaquePointer) {
        inner = t
    }
}

/**
 * Represents an asymmetric private key that wraps the underlying bytes of the key.
 */
public class PrivateKey: SdkObject {
    /**
     * Create a new PrivateKey from the provided array of bytes. Will fail if the provided bytes are not a valid IronCore PrivateKey
     */
    public convenience init?(_ bytes: [UInt8]) {
        switch Util.validateBytesAs(bytes: bytes, validator: PrivateKey_validate) {
        case let .success(privKey):
            self.init(privKey)
        case .failure:
            return nil
        }
    }

    /**
     * Get the PrivateKey data out as an array of bytes
     */
    public lazy var bytes: [UInt8] = {
        Util.rustVecToBytes(PrivateKey_asBytes(inner))
    }()

    deinit { PrivateKey_delete(inner) }
}

/**
 * Represents an encrypted asymmetric private key that wraps the underlying bytes of the encrypted key.
 */
public class EncryptedPrivateKey: SdkObject {
    /**
     * Get the EncryptedPrivateKey data out as an array of bytes
     */
    public lazy var bytes: [UInt8] = {
        Util.rustVecToBytes(EncryptedPrivateKey_asBytes(inner))
    }()

    deinit { EncryptedPrivateKey_delete(inner) }
}

/**
 * Represents an asymmetric public key that wraps the underlying bytes of the key.
 */
public class PublicKey: SdkObject {
    /**
     * Create a new PublicKey from the provided array of bytes. Will fail if the provided bytes are not a valid IronCore PublicKey
     */
    public convenience init?(_ bytes: [UInt8]) {
        switch Util.validateBytesAs(bytes: bytes, validator: PublicKey_validate) {
        case let .success(pubKey):
            self.init(pubKey)
        case .failure:
            return nil
        }
    }

    /**
     * Get the PublicKey data out as an array of bytes
     */
    public lazy var bytes: [UInt8] = {
        Util.rustVecToBytes(PublicKey_asBytes(inner))
    }()

    deinit { PublicKey_delete(inner) }
}

/**
 * Signing keypair specific to a device. Used to sign all requests to the IronCore API endpoints. Needed to create a `DeviceContext`.
 */
public class DeviceSigningKeyPair: SdkObject {
    /**
     * Create a new DeviceSigningKeyPair from the provided array of bytes. Will fail if the provided bytes are not a valid device signing key pair
     */
    public convenience init?(_ bytes: [UInt8]) {
        switch Util.validateBytesAs(bytes: bytes, validator: DeviceSigningKeyPair_validate) {
        case let .success(dskp):
            self.init(dskp)
        case .failure:
            return nil
        }
    }

    /**
     * Get the DeviceSigningKeyPair data out as an array of bytes
     */
    public lazy var bytes: [UInt8] = {
        Util.rustVecToBytes(DeviceSigningKeyPair_asBytes(inner))
    }()

    deinit { DeviceSigningKeyPair_delete(inner) }
}

/**
 * ID of a user. Unique with in a segment.
 */
public class UserId: SdkObject {
    /**
     * Create an new UserId from the provided String. Will fail if the ID contains invalid characters.
     */
    public convenience init?(_ id: String) {
        switch Util.toResult(UserId_validate(Util.swiftStringToRust(id))) {
        case let .success(id):
            self.init(id)
        case .failure:
            return nil
        }
    }

    public lazy var id: String = {
        Util.rustStringToSwift(UserId_getId(inner))
    }()

    deinit { UserId_delete(inner) }
}

/**
 * ID of a group. Unique with in a segment.
 */
public class GroupId: SdkObject {
    /**
     * Create an new GroupId from the provided String. Will fail if the ID contains invalid characters.
     */
    public convenience init?(_ id: String) {
        switch Util.toResult(GroupId_validate(Util.swiftStringToRust(id))) {
        case let .success(id):
            self.init(id)
        case .failure:
            return nil
        }
    }

    public lazy var id: String = {
        Util.rustStringToSwift(GroupId_getId(inner))
    }()

    deinit { GroupId_delete(inner) }
}

/**
 * ID of a device. Device IDs are numeric and will always be greater than 0.
 */
public class DeviceId: SdkObject {
    /**
     * Create a new DeviceId from the provided Int64. Will fail if the device ID is not valid.
     */
    public convenience init?(_ id: Int64) {
        switch Util.toResult(DeviceId_validate(id)) {
        case let .success(deviceId):
            self.init(deviceId)
        case .failure:
            return nil
        }
    }

    public lazy var id: Int64 = {
        DeviceId_getId(inner)
    }()

    deinit { DeviceId_delete(inner) }
}

/**
 * Readable device name.
 */
public class DeviceName: SdkObject {
    /**
     * Create a DeviceName from the provided string. Will fail if the string contains invalid characters
     */
    public convenience init?(_ name: String) {
        switch Util.toResult(DeviceName_validate(Util.swiftStringToRust(name))) {
        case let .success(deviceName):
            self.init(deviceName)
        case .failure:
            return nil
        }
    }

    public lazy var name: String = {
        Util.rustStringToSwift(DeviceName_getName(inner))
    }()

    deinit { DeviceName_delete(inner) }
}

/**
 * Account's device context. Needed to initialize IronOxide with a set of device keys.
 */
public class DeviceContext: SdkObject {
    /**
     * Create a DeviceContext from the provided required device information.
     */
    public convenience init(userId: UserId, segmentId: UInt64, devicePrivateKey: PrivateKey, signingPrivateKey: DeviceSigningKeyPair) {
        self.init(DeviceContext_new(userId.inner, Int64(segmentId), devicePrivateKey.inner, signingPrivateKey.inner))
    }

    /**
     * Attempt to create a new device from the provided JSON string. Expects the keys to be
     *  - accountId: string
     *  - segmentId: int
     *  - devicePrivateKey: Base64 encoded string
     *  - signingPrivateKey: Base64 encoded string
     */
    public convenience init?(deviceContextJson: String) {
        switch Util.toResult(DeviceContext_fromJsonString(Util.swiftStringToRust(deviceContextJson))) {
        case let .success(dc):
            self.init(dc)
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

public class Duration: SdkObject {
    public convenience init(millis: UInt64) {
        self.init(Duration_fromMillis(millis))
    }

    public convenience init(seconds: UInt64) {
        self.init(Duration_fromSecs(seconds))
    }

    public lazy var millis: UInt64 = {
        Duration_getMillis(inner)
    }()

    public lazy var seconds: UInt64 = {
        Duration_getSecs(inner)
    }()

    deinit { Duration_delete(inner) }
}
