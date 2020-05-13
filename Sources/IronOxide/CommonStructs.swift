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

public class DocumentId: SdkObject {
    /**
     * Create a new DocumentId from the provided String. Will fail if the document ID is not valid.
     */
    public convenience init?(_ id: String) {
        switch Util.toResult(DocumentId_validate(Util.swiftStringToRust(id))) {
        case let .success(documentId):
            self.init(documentId)
        case .failure:
            return nil
        }
    }

    public lazy var id: String = {
        Util.rustStringToSwift(DocumentId_getId(inner))
    }()

    deinit { DocumentId_delete(inner) }
}

extension DocumentId: Equatable {
    public static func == (lhs: DocumentId, rhs: DocumentId) -> Bool {
        Util.intToBool(private_DocumentId_rustEq(lhs.inner, rhs.inner))
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
        let rustBytes = RustBytes(bytes)
        switch rustBytes.validateBytesAs(PrivateKey_validate) {
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
        let rustBytes = RustBytes(bytes)
        switch rustBytes.validateBytesAs(PublicKey_validate) {
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
        let rustBytes = RustBytes(bytes)
        switch rustBytes.validateBytesAs(DeviceSigningKeyPair_validate) {
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

extension UserId: Equatable {
    public static func == (lhs: UserId, rhs: UserId) -> Bool {
        Util.intToBool(private_UserId_rustEq(lhs.inner, rhs.inner))
    }
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

extension GroupId: Equatable {
    public static func == (lhs: GroupId, rhs: GroupId) -> Bool {
        Util.intToBool(private_GroupId_rustEq(lhs.inner, rhs.inner))
    }
}

public class UserOrGroupId: SdkObject {
    public lazy var id: String = {
        Util.rustStringToSwift(UserOrGroupId_getId(inner))
    }()

    public lazy var isUser: Bool = {
        Util.intToBool(UserOrGroupId_isUser(inner))
    }()

    public lazy var isGroup: Bool = {
        Util.intToBool(UserOrGroupId_isGroup(inner))
    }()

    deinit { UserOrGroupId_delete(inner) }
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

extension DeviceId: Equatable {
    public static func == (lhs: DeviceId, rhs: DeviceId) -> Bool {
        Util.intToBool(private_DeviceId_rustEq(lhs.inner, rhs.inner))
    }
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

    public convenience init(deviceAddResult: DeviceAddResult) {
        self.init(userId: deviceAddResult.accountId, segmentId: UInt64(deviceAddResult.segmentId), devicePrivateKey: deviceAddResult.devicePrivateKey,
                  signingPrivateKey: deviceAddResult.signingPrivateKey)
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

/**
 * Creates a new duration of time given either seconds or milliseconds. Used to provided timeout durations for SDK API requests
 */
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

/**
 * Representation of bytes within Rust
 */
class RustBytes {
    let innerMemory: ContiguousArray<Int8>

    /**
     * Initialize with a swift array of signed bytes
     */
    init(_ a: [Int8]) {
        innerMemory = ContiguousArray(a)
    }

    /**
     * Initialize with a swift array of unsigned bytes. Internally stores as an array of swift bytes without changing any bits in the raw storage.
     */
    init(_ a: [UInt8]) {
        innerMemory = ContiguousArray(a.map { Int8(bitPattern: $0) })
    }

    /**
     * Convert the initialized byte array into a slice that we can pass to libironoxide.
     * If possible, use withSlice() instead to ensure the lifetime of the swift array and the rust slice stay in sync.
     */
    private lazy var slice: CRustSlicei8 = {
        innerMemory.withContiguousStorageIfAvailable { ptr in CRustSlicei8(data: ptr.baseAddress, len: UInt(ptr.count)) }!
    }()

    lazy var count: Int = { innerMemory.count }()

    /**
     * Takes a function that needs a rust slice as input, runs that function and returns the result.
     * This is the safest way to pass a swift array to rust as a slice.
     */
    func withSlice<R>(_ body: (CRustSlicei8) throws -> R) rethrows -> R {
        try body(slice)
    }

    /**
     * Generic method to validate that the provided bytes can be used to create the type validated by the validator function.
     */
    func validateBytesAs(_ validator: (CRustSlicei8) -> CRustResult4232mut3232c_voidCRustString) -> Result<OpaquePointer, IronOxideError> {
        Util.toResult(validator(slice))
    }
}

/**
 * Implement equality for RustBytes
 */
extension RustBytes: Equatable {
    static func == (lhs: RustBytes, rhs: RustBytes) -> Bool {
        lhs.innerMemory == rhs.innerMemory
    }
}

/**
 * Representation of an array of Rust objects in Swift
 */
class RustObjects<T> {
    let innerMemory: ContiguousArray<T>

    /**
     * Converts an array of SdkObjects to an array of the things the objects point to.
     */
    init(array: [SdkObject], fn: (OpaquePointer) -> T) {
        innerMemory = ContiguousArray(array.map { obj in fn(obj.inner) })
    }

    /**
     * Convert the array of objects into a slice that we can pass to libironoxide.
     * If possible, use withSlice() instead to ensure the lifetime of the swift array and the rust slice stay in sync.
     */
    private lazy var slice: CRustObjectSlice = {
        let step = UInt(MemoryLayout<T>.stride)
        return innerMemory.withContiguousStorageIfAvailable { pt in
            CRustObjectSlice(data: UnsafeMutableRawPointer(mutating: pt.baseAddress!), len: UInt(pt.count), step: step)
        }!
    }()

    lazy var count: Int = { innerMemory.count }()

    /**
     * Takes a function that needs a rust object slice as input, runs that function and returns the result.
     * This is the safest way to pass a swift array to rust as a slice.
     */
    func withSlice<R>(_ body: (CRustObjectSlice) throws -> R) rethrows -> R {
        try body(slice)
    }
}
