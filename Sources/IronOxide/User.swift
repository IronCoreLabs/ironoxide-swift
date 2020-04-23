import Foundation
import libironoxide

/**
 * Options that can be specified creating a user.
 */
public class UserCreateOpts {
    let inner: OpaquePointer
    public init() {
        inner = UserCreateOpts_default()
    }

    /**
     * Create a UserCreateOpts instance with a flag denoting if the provided user needs rotation
     */
    public init(needsRotation: Bool) {
        inner = UserCreateOpts_create(Util.intFromBool(needsRotation))
    }

    deinit { UserCreateOpts_delete(inner) }
}

/**
 * Keypair for a newly created user.
 */
public class UserCreateResult {
    let inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public lazy var needsRotation: Bool = {
        Util.isTrue(UserCreateResult_getNeedsRotation(inner))
    }()

    public lazy var userPublicKey: PublicKey = {
        PublicKey(UserCreateResult_getUserPublicKey(inner))
    }()

    deinit { UserCreateResult_delete(inner) }
}

/**
 * Options to specify when creating a new device
 */
public class DeviceCreateOpts {
    let inner: OpaquePointer
    public init() {
        inner = DeviceCreateOpts_default()
    }

    /**
     * Create a new DeviceCreateOpts with te provided DeviceName
     */
    public init(deviceName: DeviceName) {
        inner = DeviceCreateOpts_create(Util.rustSome(deviceName.inner))
    }

    deinit { DeviceCreateOpts_delete(inner) }
}

/**
 * IDs and public key for existing user on verify result
 */
public class UserResult {
    let inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public lazy var accountId: UserId = {
        UserId(UserResult_getAccountId(inner))
    }()

    public lazy var needsRotation: Bool = {
        Util.isTrue(UserResult_getNeedsRotation(inner))
    }()

    public lazy var segmentId: UInt = {
        UserResult_getSegmentId(inner)
    }()

    public lazy var userPublicKey: PublicKey = {
        PublicKey(UserResult_getUserPublicKey(inner))
    }()

    deinit { UserResult_delete(inner) }
}

/**
 * Result from adding a new device
 */
public class DeviceAddResult {
    let inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public lazy var accountId: UserId = {
        UserId(DeviceAddResult_getAccountId(inner))
    }()

    public lazy var deviceId: DeviceId = {
        DeviceId(DeviceAddResult_getDeviceId(inner))
    }()

    public lazy var name: DeviceName? = {
        Util.toOption(DeviceAddResult_getName(inner)).map(DeviceName.init)
    }()

    public lazy var devicePrivateKey: PrivateKey = {
        PrivateKey(DeviceAddResult_getDevicePrivateKey(inner))
    }()

    public lazy var segmentId: UInt = {
        DeviceAddResult_getSegmentId(inner)
    }()

    public lazy var signingPrivateKey: DeviceSigningKeyPair = {
        DeviceSigningKeyPair(DeviceAddResult_getDevicePrivateKey(inner))
    }()

    public lazy var created: Date = {
        Util.timestampToDate(DeviceAddResult_getCreated(inner))
    }()

    public lazy var lastUpdated: Date = {
        Util.timestampToDate(DeviceAddResult_getLastUpdated(inner))
    }()

    deinit { DeviceAddResult_delete(inner) }
}

/**
 * Metadata about a user device.
 */
public class UserDevice {
    let inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public lazy var id: DeviceId = {
        DeviceId(UserDevice_getId(inner))
    }()

    public lazy var name: DeviceName? = {
        Util.toOption(UserDevice_getName(inner)).map(DeviceName.init)
    }()

    public lazy var isCurrentDevice: Bool = {
        Util.isTrue(UserDevice_isCurrentDevice(inner))
    }()

    public lazy var created: Date = {
        Util.timestampToDate(UserDevice_getCreated(inner))
    }()

    public lazy var lastUpdated: Date = {
        Util.timestampToDate(UserDevice_getLastUpdated(inner))
    }()

    deinit { UserDevice_delete(inner) }
}

/**
 * Devices for a user, sorted by the device id.
 */
public class UserDeviceListResult {
    let inner: OpaquePointer

    init(_ res: OpaquePointer) {
        inner = res
    }

    public lazy var result: [UserDevice] = {
        Util.collectTo(list: UserDeviceListResult_getResult(inner), to: UserDevice.init)
    }()

    deinit { UserDeviceListResult_delete(inner) }
}

/**
 * Represents a user in the IronCore service that includes their PublicKey
 */
public class UserWithKey {
    let inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public lazy var id: UserId = {
        UserId(UserWithKey_getUser(inner))
    }()

    public lazy var publicKey: PublicKey = {
        PublicKey(UserWithKey_getPublicKey(inner))
    }()

    deinit { UserWithKey_delete(inner) }
}

/**
 * Structure returned when rotating a users private key. Returns whether additional rotation is needed as well as the users
 * new encrypted private key.
 */
public class UserUpdatePrivateKeyResult {
    let inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public lazy var needsRotation: Bool = {
        Util.isTrue(UserUpdatePrivateKeyResult_getNeedsRotation(inner))
    }()

    public lazy var userMasterPrivateKey: EncryptedPrivateKey = {
        EncryptedPrivateKey(UserUpdatePrivateKeyResult_getUserMasterPrivateKey(inner))
    }()

    deinit { UserUpdatePrivateKeyResult_delete(inner) }
}

/**
 * All user operations that can be run once the SDK has been initialized
 */
public struct UserOperations {
    let ironoxide: OpaquePointer
    init(_ instance: OpaquePointer) {
        ironoxide = instance
    }

    /**
     * Get all the devices for the current user
     */
    public func listDevices() -> Result<UserDeviceListResult, IronOxideError> {
        Util.toResult(IronOxide_userListDevices(ironoxide)).map(UserDeviceListResult.init)
    }

    /**
     * Get a list of user public keys given their IDs. Allows discovery of which user IDs have keys in the IronCore system to determine of
     * they can be added to groups or have documents shared with them.
     */
    public func getPublicKey(users: [UserId]) -> Result<[UserWithKey], IronOxideError> {
        let userIdStringList = users.map {user in UserId_getId(user.inner)}
        let step = UInt(MemoryLayout<CRustString>.stride)
        let listOfUsers = userIdStringList.withUnsafeBufferPointer {pt in
            CRustObjectSlice(data: UnsafeMutableRawPointer(mutating: pt.baseAddress!), len: UInt(userIdStringList.count), step: step)
        }

        return Util.mapListResultTo(
            result: IronOxide_userGetPublicKey(ironoxide, listOfUsers),
            to: UserWithKey.init
        )
    }

    /**
     * Delete a user device. If deleting the currently signed in device (`null` for `deviceId`), the sdk will need to be reinitialized
     * with `IronOxide.initialize()` before further use.
     */
    public func deleteDevice(deviceId: DeviceId?) -> Result<DeviceId, IronOxideError> {
        Util.toResult(IronOxide_userDeleteDevice(ironoxide, deviceId == nil ? Util.rustNone() : Util.rustSome(deviceId!.inner)))
            .map(DeviceId.init)
    }

    /**
     * Rotate the current user's private key, but leave the public key the same. There's no black magic here! This is accomplished via
     * multi-party computation with the IronCore webservice.
     */
    public func rotatePrivateKey(password: String) -> Result<UserUpdatePrivateKeyResult, IronOxideError> {
        Util.toResult(IronOxide_userRotatePrivateKey(ironoxide, Util.swiftStringToRust(password))).map(UserUpdatePrivateKeyResult.init)
    }
}
