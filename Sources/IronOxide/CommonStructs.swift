import libironoxide

/**
 Superclass to all SDK classes. The data of the class is stored in `inner`, and there is an internal `init` for setting the data.

 Requires subclass inits to be `convenience init` which call `self.init` to set `inner`
 */
public class SdkObject {
    let inner: OpaquePointer
    init(_ t: OpaquePointer) {
        inner = t
    }
}

/**
 ID of a document.

 Must be unique within the document's segment and match the regex `^[a-zA-Z0-9_.$#|@/:;=+'-]+$`.
 */
public class DocumentId: SdkObject {
    /**
     Constructs a `DocumentId` from the provided String.

     Fails if the provided ID is not valid.
     */
    public convenience init?(_ id: String) {
        switch Util.toResult(DocumentId_validate(Util.swiftStringToRust(id))) {
        case let .success(documentId):
            self.init(documentId)
        case .failure:
            return nil
        }
    }

    /// ID of the document
    public lazy var id: String = {
        Util.rustStringToSwift(DocumentId_getId(inner))
    }()

    deinit { DocumentId_delete(inner) }
}

extension DocumentId: CustomStringConvertible {
    public var description: String {
        id
    }
}

extension DocumentId: Equatable {
    public static func == (lhs: DocumentId, rhs: DocumentId) -> Bool {
        Util.intToBool(private_DocumentId_rustEq(lhs.inner, rhs.inner))
    }
}

/// Asymmetric private encryption key.
public class PrivateKey: SdkObject {
    /**
     Constructs a PrivateKey from the provided array of bytes.

     Fails if the provided bytes are not a valid IronCore PrivateKey.
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

    /// Bytes of the private key
    public lazy var bytes: [UInt8] = {
        Util.rustVecToBytes(PrivateKey_asBytes(inner))
    }()

    deinit { PrivateKey_delete(inner) }
}

/// User's encrypted private key.
public class EncryptedPrivateKey: SdkObject {
    /// Bytes of the user's encrypted private key
    public lazy var bytes: [UInt8] = {
        Util.rustVecToBytes(EncryptedPrivateKey_asBytes(inner))
    }()

    deinit { EncryptedPrivateKey_delete(inner) }
}

/// Asymmetric public encryption key.
public class PublicKey: SdkObject {
    /**
     Constructs a PublicKey from the provided array of bytes.

     Fails if the provided bytes are not a valid IronCore PublicKey.
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

    /// Bytes of the public key
    public lazy var bytes: [UInt8] = {
        Util.rustVecToBytes(PublicKey_asBytes(inner))
    }()

    deinit { PublicKey_delete(inner) }
}

/// Key pair used to sign all requests to the IronCore API endpoints.
public class DeviceSigningKeyPair: SdkObject {
    /**
     Constructs a DeviceSigningKeyPair from the provided array of bytes.

     Fails if the provided bytes are not a valid IronCore DeviceSigningKeyPair.
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

    /// Bytes of the signing key pair
    public lazy var bytes: [UInt8] = {
        Util.rustVecToBytes(DeviceSigningKeyPair_asBytes(inner))
    }()

    deinit { DeviceSigningKeyPair_delete(inner) }
}

/**
 ID of a user.

 Must be unique within the user's segment and match the regex `^[a-zA-Z0-9_.$#|@/:;=+'-]+$`.
 */
public class UserId: SdkObject {
    /**
     Constructs a `UserId` from the provided String.

     Fails if the provided ID is not valid.
     */
    public convenience init?(_ id: String) {
        switch Util.toResult(UserId_validate(Util.swiftStringToRust(id))) {
        case let .success(id):
            self.init(id)
        case .failure:
            return nil
        }
    }

    /// ID of the user
    public lazy var id: String = {
        Util.rustStringToSwift(UserId_getId(inner))
    }()

    deinit { UserId_delete(inner) }
}

extension UserId: CustomStringConvertible {
    public var description: String {
        id
    }
}

extension UserId: Equatable {
    public static func == (lhs: UserId, rhs: UserId) -> Bool {
        Util.intToBool(private_UserId_rustEq(lhs.inner, rhs.inner))
    }
}

/**
 ID of a group.

 Must be unique within the group's segment and match the regex `^[a-zA-Z0-9_.$#|@/:;=+'-]+$`.
 */
public class GroupId: SdkObject {
    /**
     Constructs a `GroupId` from the provided String.

     Fails if the provided ID is not valid.
     */
    public convenience init?(_ id: String) {
        switch Util.toResult(GroupId_validate(Util.swiftStringToRust(id))) {
        case let .success(id):
            self.init(id)
        case .failure:
            return nil
        }
    }

    /// ID of the group
    public lazy var id: String = {
        Util.rustStringToSwift(GroupId_getId(inner))
    }()

    deinit { GroupId_delete(inner) }
}

extension GroupId: CustomStringConvertible {
    public var description: String {
        id
    }
}

extension GroupId: Equatable {
    public static func == (lhs: GroupId, rhs: GroupId) -> Bool {
        Util.intToBool(private_GroupId_rustEq(lhs.inner, rhs.inner))
    }
}

/// ID of a user or a group
public class UserOrGroupId: SdkObject {
    /// ID of the user or group
    public lazy var id: String = {
        Util.rustStringToSwift(UserOrGroupId_getId(inner))
    }()

    /// `true` if the ID belongs to a user
    public lazy var isUser: Bool = {
        Util.intToBool(UserOrGroupId_isUser(inner))
    }()

    /// `true` if the ID belongs to a group
    public lazy var isGroup: Bool = {
        Util.intToBool(UserOrGroupId_isGroup(inner))
    }()

    deinit { UserOrGroupId_delete(inner) }
}

/**
 ID of a device.

 Must be greater than 0.
 */
public class DeviceId: SdkObject {
    /**
     Constructs a `DeviceId` from the provided Int64.

     Fails if the provided ID is not valid.
     */
    public convenience init?(_ id: Int64) {
        switch Util.toResult(DeviceId_validate(id)) {
        case let .success(deviceId):
            self.init(deviceId)
        case .failure:
            return nil
        }
    }

    /// ID of the device
    public lazy var id: Int64 = {
        DeviceId_getId(inner)
    }()

    deinit { DeviceId_delete(inner) }
}

extension DeviceId: CustomStringConvertible {
    public var description: String {
        String(id)
    }
}

extension DeviceId: Equatable {
    public static func == (lhs: DeviceId, rhs: DeviceId) -> Bool {
        Util.intToBool(private_DeviceId_rustEq(lhs.inner, rhs.inner))
    }
}

/**
 Name of a device.

 Must be between 1 and 100 characters long.
 */
public class DeviceName: SdkObject {
    /**
     Constructs a `DeviceName` from the provided String.

     Fails if the provided name is not valid.
     */
    public convenience init?(_ name: String) {
        switch Util.toResult(DeviceName_validate(Util.swiftStringToRust(name))) {
        case let .success(deviceName):
            self.init(deviceName)
        case .failure:
            return nil
        }
    }

    /// Name of the device
    public lazy var name: String = {
        Util.rustStringToSwift(DeviceName_getName(inner))
    }()

    deinit { DeviceName_delete(inner) }
}

/**
 Signing and encryption key pairs and metadata for a device.

 Required to initialize the SDK with a set of device keys (see `IronOxide.initialize`).

 Can be generated by calling `SDK.generateNewDevice` and passing the result to `DeviceContext.init`.
 */
public class DeviceContext: SdkObject {
    /**
     Constructs a `DeviceContext` from its components.

     To instead generate a new `DeviceContext` for the user, call `SDK.generate_new_device` and pass the result to `DeviceContext.init`.
     */
    public convenience init(userId: UserId, segmentId: UInt64, devicePrivateKey: PrivateKey, signingPrivateKey: DeviceSigningKeyPair) {
        self.init(DeviceContext_new(userId.inner, Int64(segmentId), devicePrivateKey.inner, signingPrivateKey.inner))
    }

    /**
     Attempts to construct a `DeviceContext` from the provided JSON string. Expects the keys to be
      - accountId: string
      - segmentId: int
      - devicePrivateKey: Base64 encoded string
      - signingPrivateKey: Base64 encoded string
     */
    public convenience init?(deviceContextJson: String) {
        switch Util.toResult(DeviceContext_fromJsonString(Util.swiftStringToRust(deviceContextJson))) {
        case let .success(dc):
            self.init(dc)
        case .failure:
            return nil
        }
    }

    /// Constructs a `DeviceContext` from a `DeviceAddResult`, the result of `SDK.generateNewDevice`.
    public convenience init(deviceAddResult: DeviceAddResult) {
        self.init(userId: deviceAddResult.accountId, segmentId: UInt64(deviceAddResult.segmentId), devicePrivateKey: deviceAddResult.devicePrivateKey,
                  signingPrivateKey: deviceAddResult.signingPrivateKey)
    }

    /// ID of the device's owner
    public lazy var accountId: UserId = {
        UserId(DeviceContext_getAccountId(inner))
    }()

    /// ID of the segment
    public lazy var segmentId: UInt = {
        DeviceContext_getSegmentId(inner)
    }()

    /// Private encryption key of the device
    public lazy var devicePrivateKey: PrivateKey = {
        PrivateKey(DeviceContext_getDevicePrivateKey(inner))
    }()

    /// Private signing key of the device
    public lazy var signingPrivateKey: DeviceSigningKeyPair = {
        DeviceSigningKeyPair(DeviceContext_getDevicePrivateKey(inner))
    }()

    deinit { DeviceSigningKeyPair_delete(inner) }
}

/**
 Representation of an amount of time.

 Used to provide timeout durations for SDK API requests.
 */
public class Duration: SdkObject {
    /// Constructs a `Duration` representing the provided time in milliseconds
    public convenience init(millis: UInt64) {
        self.init(Duration_fromMillis(millis))
    }

    /// Constructs a `Duration` representing the provided time in seconds
    public convenience init(seconds: UInt64) {
        self.init(Duration_fromSecs(seconds))
    }

    /// Time in milliseconds
    public lazy var millis: UInt64 = {
        Duration_getMillis(inner)
    }()

    /// Time in seconds
    public lazy var seconds: UInt64 = {
        Duration_getSecs(inner)
    }()

    deinit { Duration_delete(inner) }
}

/// Claims required to form a valid `Jwt`.
public class JwtClaims: SdkObject {
    /// Unique user ID
    public lazy var sub: String = {
        Util.rustStringToSwift(JwtClaims_getSub(inner))
    }()

    /// Project ID
    public lazy var pid: Int64? = {
        Util.toOption(JwtClaims_getPid(inner))
    }()

    /// Prefixed Project ID (http://ironcore/pid)
    public lazy var prefixedPid: Int64? = {
        Util.toOption(JwtClaims_getPrefixedPid(inner))
    }()

    /// Segment ID
    public lazy var sid: String? = {
        Util.toOption(JwtClaims_getSid(inner))
    }()

    /// Prefixed Segment ID (http://ironcore/sid)
    public lazy var prefixedSid: String? = {
        Util.toOption(JwtClaims_getPrefixedSid(inner))
    }()

    /// Service key ID
    public lazy var kid: Int64? = {
        Util.toOption(JwtClaims_getKid(inner))
    }()

    /// Prefixed Service key ID (http://ironcore/kid)
    public lazy var prefixedKid: Int64? = {
        Util.toOption(JwtClaims_getPrefixedKid(inner))
    }()

    /// User ID
    public lazy var uid: String? = {
        Util.toOption(JwtClaims_getUid(inner))
    }()

    /// Prefixed User ID (http://ironcore/uid)
    public lazy var prefixedUid: String? = {
        Util.toOption(JwtClaims_getPrefixedUid(inner))
    }()

    /// Issued time (seconds)
    public lazy var iat: UInt64 = {
        JwtClaims_getIat(inner)
    }()

    /// Expiration time (seconds)
    public lazy var exp: UInt64 = {
        JwtClaims_getExp(inner)
    }()

    deinit { JwtClaims_delete(inner) }
}

/**
 IronCore JWT.

 Must be either ES256 or RS256 and have a payload similar to `JwtClaims`, but could be
 generated from an external source.
 */
public class Jwt: SdkObject {
    /**
     Constructs a `Jwt` from the provided String.

     Fails if the provided String is not a valid JWT, or if the JWT does not have a valid IronCore payload.
     */
    public convenience init?(_ jwt: String) {
        switch Util.toResult(Jwt_validate(Util.swiftStringToRust(jwt))) {
        case let .success(validJwt):
            self.init(validJwt)
        case .failure:
            return nil
        }
    }

    /// Raw JWT string
    public lazy var jwt: String = {
        Util.rustStringToSwift(Jwt_getJwt(inner))
    }()

    /// Algorithm used by the JWT
    public lazy var algorithm: String = {
        Util.rustStringToSwift(Jwt_getAlgorithm(inner))
    }()

    /// Payload of the JWT
    public lazy var claims: JwtClaims = {
        JwtClaims(Jwt_getClaims(inner))
    }()

    deinit { Jwt_delete(inner) }
}

/// Representation of bytes within Rust
class RustBytes {
    let innerMemory: ContiguousArray<Int8>

    /// Initializes with a swift array of signed bytes
    init(_ a: [Int8]) {
        innerMemory = ContiguousArray(a)
    }

    /**
     Initializes with a swift array of unsigned bytes.

     Internally stores as an array of swift bytes without changing any bits in the raw storage.
     */
    init(_ a: [UInt8]) {
        innerMemory = ContiguousArray(a.map { Int8(bitPattern: $0) })
    }

    /**
     Converts the initialized byte array into a slice that we can pass to libironoxide.

     If possible, use withSlice() instead to ensure the lifetime of the swift array and the rust slice stay in sync.
     */
    private lazy var slice: CRustSlicei8 = {
        innerMemory.withContiguousStorageIfAvailable { ptr in CRustSlicei8(data: ptr.baseAddress, len: UInt(ptr.count)) }!
    }()

    lazy var count: Int = { innerMemory.count }()

    /**
     Takes a function that needs a rust slice as input, runs that function, and returns the result.

     This is the safest way to pass a swift array to rust as a slice.
     */
    func withSlice<R>(_ body: (CRustSlicei8) throws -> R) rethrows -> R {
        try body(slice)
    }

    /// Generic method to validate that the provided bytes can be used to create the type validated by the validator function.
    func validateBytesAs(_ validator: (CRustSlicei8) -> CRustResult4232mut3232c_voidCRustString) -> Result<OpaquePointer, IronOxideError> {
        Util.toResult(validator(slice))
    }
}

extension RustBytes: Equatable {
    static func == (lhs: RustBytes, rhs: RustBytes) -> Bool {
        lhs.innerMemory == rhs.innerMemory
    }
}

/// Representation of an array of Rust objects in Swift
class RustObjects<T> {
    let innerMemory: ContiguousArray<T>

    /// Converts an array of SdkObjects to an array of the things the objects point to.
    init(array: [SdkObject], fn: (OpaquePointer) -> T) {
        innerMemory = ContiguousArray(array.map { obj in fn(obj.inner) })
    }

    /**
     Converts the array of objects into a slice that we can pass to libironoxide.

     If possible, use withSlice() instead to ensure the lifetime of the swift array and the rust slice stay in sync.
     */
    private lazy var slice: CRustObjectSlice = {
        let step = UInt(MemoryLayout<T>.stride)
        return innerMemory.withContiguousStorageIfAvailable { pt in
            CRustObjectSlice(data: UnsafeMutableRawPointer(mutating: pt.baseAddress!), len: UInt(pt.count), step: step)
        }!
    }()

    lazy var count: Int = { innerMemory.count }()

    /**
     Takes a function that needs a rust object slice as input, runs that function, and returns the result.

     This is the safest way to pass a swift array to rust as a slice.
     */
    func withSlice<R>(_ body: (CRustObjectSlice) throws -> R) rethrows -> R {
        try body(slice)
    }
}
