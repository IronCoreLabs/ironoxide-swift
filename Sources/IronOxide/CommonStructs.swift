import libironoxide

/**
 * Represents an asymmetric private key that wraps the underlying bytes of the key.
 */
public struct PrivateKey {
    let inner: OpaquePointer
    init(_ pk: OpaquePointer) {
        inner = pk
    }

    /**
     * Create a new PrivateKey from the provided array of bytes. Will fail if the provided bytes are not a valid IronCore PrivateKey
     */
    public init?(_ bytes: [UInt8]) {
        if let privKey = Util.validateBytesAs(bytes: bytes, validator: PrivateKey_validate) {
            inner = privKey
        } else {
            return nil
        }
    }

    /**
     * Get the PrivateKey data out as an array of bytes
     */
    public func asBytes() -> [UInt8] {
        let pk = PrivateKey_asBytes(inner)
        return Array(UnsafeBufferPointer(start: pk.data, count: Int(pk.len))).map(UInt8.init)
    }
}

/**
 * Represents an asymmetric public key that wraps the underlying bytes of the key.
 */
public struct PublicKey {
    let inner: OpaquePointer
    init(_ pk: OpaquePointer) {
        inner = pk
    }

    /**
     * Create a new PublicKey from the provided array of bytes. Will fail if the provided bytes are not a valid IronCore PublicKey
     */
    public init?(_ bytes: [UInt8]) {
        if let pubKey = Util.validateBytesAs(bytes: bytes, validator: PublicKey_validate) {
            inner = pubKey
        } else {
            return nil
        }
    }

    /**
     * Get the PublicKey data out as an array of bytes
     */
    public func asBytes() -> [UInt8] {
        let pk = PublicKey_asBytes(inner)
        return Array(UnsafeBufferPointer(start: pk.data, count: Int(pk.len))).map(UInt8.init)
    }
}

/**
 * Signing keypair specific to a device. Used to sign all requests to the IronCore API endpoints. Needed to create a `DeviceContext`.
 */
public struct DeviceSigningKeyPair {
    let inner: OpaquePointer
    init(_ pk: OpaquePointer) {
        inner = pk
    }

    /**
     * Create a new DeviceSigningKeyPair from the provided array of bytes. Will fail if the provided bytes are not a valid device signing key pair
     */
    public init?(_ bytes: [UInt8]) {
        if let dskp = Util.validateBytesAs(bytes: bytes, validator: DeviceSigningKeyPair_validate) {
            inner = dskp
        } else {
            return nil
        }
    }

    /**
     * Get the DeviceSigningKeyPair data out as an array of bytes
     */
    public func asBytes() -> [UInt8] {
        let pk = PublicKey_asBytes(inner)
        return Array(UnsafeBufferPointer(start: pk.data, count: Int(pk.len))).map(UInt8.init)
    }
}

/**
 * ID of a user. Unique with in a segment.
 */
public struct UserId {
    let inner: OpaquePointer
    init(_ id: OpaquePointer) {
        inner = id
    }

    /**
     * Create an new UserId from the provided String. Will fail if the ID contains invalid characters.
     */
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
 * ID of a device. Device IDs are numeric and will always be greater than 0.
 */
public struct DeviceId {
    let inner: OpaquePointer
    init(_ id: OpaquePointer) {
        inner = id
    }

    /**
     * Create a new DeviceId from the provided Int64. Will fail if the device ID is not valid.
     */
    public init?(_ id: Int64) {
        let id = DeviceId_validate(id)
        if id.is_ok == 0 { return nil }
        inner = OpaquePointer(id.data.ok)
    }

    public func id() -> Int64 {
        DeviceId_getId(inner)
    }
}

/**
 * Readable device name.
 */
public struct DeviceName {
    let inner: OpaquePointer
    init(_ name: OpaquePointer) {
        inner = name
    }

    /**
     * Create a DeviceName from the provided string. Will fail if the string contains invalid characters
     */
    public init?(_ name: String) {
        let name = DeviceName_validate(Util.swiftStringToRust(name))
        if name.is_ok == 0 { return nil }
        inner = OpaquePointer(name.data.ok)
    }

    public func name() -> String {
        Util.rustStringToSwift(str: DeviceName_getName(inner), fallbackError: "Failed to extract device name")
    }
}

/**
 * Account's device context. Needed to initialize IronOxide with a set of device keys.
 */
public struct DeviceContext {
    let inner: OpaquePointer
    /**
     * Create a DeviceContext from the provided required device information.
     */
    public init(userId: UserId, segmentId: Int64, devicePrivateKey: PrivateKey, signingPrivateKey: DeviceSigningKeyPair) {
        inner = DeviceContext_new(userId.inner, segmentId, devicePrivateKey.inner, signingPrivateKey.inner)
    }

    /**
     * Attempt to create a new device from the provided JSON string. Expects the keys to be
     *  - accountId: string
     *  - segmentId: int
     *  - devicePrivateKey: Base64 encoded string
     *  - signingPrivateKey: Base64 encoded string
     */
    public init?(deviceContextJson: String) {
        let dc = DeviceContext_fromJsonString(Util.swiftStringToRust(deviceContextJson))
        if dc.is_ok == 0 { return nil }
        inner = OpaquePointer(dc.data.ok)
    }

    public func getAccountId() -> UserId {
        UserId(DeviceContext_getAccountId(inner))
    }

    public func getSegmentId() -> Int64 {
        Int64(DeviceContext_getSegmentId(inner))
    }

    public func getDevicePrivateKey() -> PrivateKey {
        PrivateKey(DeviceContext_getDevicePrivateKey(inner))
    }

    public func getSigningPrivateKey() -> DeviceSigningKeyPair {
        DeviceSigningKeyPair(DeviceContext_getDevicePrivateKey(inner))
    }
}
