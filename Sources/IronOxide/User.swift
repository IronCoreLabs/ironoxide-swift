import Foundation
import libironoxide

/**
 * Options that can be specified creating a user.
 */
public struct UserCreateOpts {
    let inner: OpaquePointer
    public init() {
        inner = UserCreateOpts_default()
    }

    /**
     * Create a UserCreateOpts instance with a flag denoting if the provided user needs rotation
     */
    public init(needsRotation: Bool?) {
        inner = UserCreateOpts_create(needsRotation == true ? 1 : 0)
    }
}

/**
 * Keypair for a newly created user.
 */
public struct UserCreateResult {
    let inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public func getNeedsRotation() -> Bool {
        UserCreateResult_getNeedsRotation(inner) == 1
    }

    public func getUserPublicKey() -> PublicKey {
        PublicKey(UserCreateResult_getUserPublicKey(inner))
    }
}

/**
 * Options to specify when creating a new device
 */
public struct DeviceCreateOpts {
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
}

/**
 * IDs and public key for existing user on verify result
 */
public struct UserResult {
    let inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public func getAccountId() -> UserId {
        UserId(UserResult_getAccountId(inner))
    }

    public func getNeedsRotation() -> Bool {
        UserResult_getNeedsRotation(inner) == 1
    }

    public func getSegmentId() -> UInt {
        UserResult_getSegmentId(inner)
    }

    public func getUserPublicKey() -> PublicKey {
        PublicKey(UserResult_getUserPublicKey(inner))
    }
}

/**
 * Result from adding a new device
 */
public struct DeviceAddResult {
    let inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public func getAccountId() -> UserId {
        UserId(DeviceAddResult_getAccountId(inner))
    }

    public func getDeviceId() -> DeviceId {
        DeviceId(DeviceAddResult_getDeviceId(inner))
    }

    public func getName() -> DeviceName? {
        let name = DeviceAddResult_getName(inner)
        if name.is_some == 0 { return nil }
        return DeviceName(OpaquePointer(name.val.data))
    }

    public func getDevicePrivateKey() -> PrivateKey {
        PrivateKey(DeviceAddResult_getDevicePrivateKey(inner))
    }

    public func getSegmentId() -> Int64 {
        Int64(DeviceAddResult_getSegmentId(inner))
    }

    public func getSigningPrivateKey() -> DeviceSigningKeyPair {
        DeviceSigningKeyPair(DeviceAddResult_getDevicePrivateKey(inner))
    }

    public func getCreated() -> Date {
        Util.timestampToDate(DeviceAddResult_getCreated(inner))
    }

    public func getLastUpdated() -> Date {
        Util.timestampToDate(DeviceAddResult_getLastUpdated(inner))
    }
}

/**
 * Metadata about a user device.
 */
public class UserDevice {
    let inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public func getId() -> DeviceId {
        DeviceId(UserDevice_getId(inner))
    }

    public func getName() -> DeviceName? {
        let name = UserDevice_getName(inner)
        return name.is_some == 1 ? DeviceName(OpaquePointer(name.val.data)) : Optional.none
    }

    public func isCurrentDevice() -> Bool {
        UserDevice_isCurrentDevice(inner) == 1
    }

    public func getCreated() -> Date {
        Util.timestampToDate(UserDevice_getCreated(inner))
    }

    public func getLastUpdated() -> Date {
        Util.timestampToDate(UserDevice_getLastUpdated(inner))
    }
}

/**
 * Devices for a user, sorted by the device id.
 */
public struct UserDeviceListResult {
    let inner: OpaquePointer
    var deviceList: [UserDevice] = []
    init(_ res: OpaquePointer) {
        inner = res
        // Iterate over and compute the list of devices here so we don't do it every time they call `getResult`
        var devices = UserDeviceListResult_getResult(inner)
        for _ in 0 ..< devices.len {
            deviceList.append(UserDevice(OpaquePointer(devices.data)))
            devices.data += UnsafeMutableRawPointer.Stride(devices.step)
        }
    }

    public func getResult() -> [UserDevice] {
        deviceList
    }
}

/**
 * Represents a user in the IronCore service that includes their PublicKey
 */
public struct UserWithKey {
    let inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public func getId() -> UserId {
        UserId(UserWithKey_getUser(inner))
    }

    public func getPublicKey() -> PublicKey {
        PublicKey(UserWithKey_getPublicKey(inner))
    }
}

/**
 * Structure returned when rotating a users private key. Returns whether additional rotation is needed as well as the users
 * new encrypted private key.
 */
public struct UserUpdatePrivateKeyResult {
    let inner: OpaquePointer
    init(_ res: OpaquePointer) {
        inner = res
    }

    public func getNeedsRotation() -> Bool {
        UserUpdatePrivateKeyResult_getNeedsRotation(inner) == 1
    }

    public func getUserMasterPrivateKey() -> EncryptedPrivateKey {
        EncryptedPrivateKey(UserUpdatePrivateKeyResult_getUserMasterPrivateKey(inner))
    }
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
        Util.mapResultTo(
            result: IronOxide_userListDevices(ironoxide),
            to: UserDeviceListResult.init,
            fallbackError: "Failed to request list of users devices.")
    }

    /**
     * Get a list of user public keys given their IDs. Allows discovery of which user IDs have keys in the IronCore system to determine of
     * they can be added to groups or have documents shared with them.
     */
    public func getPublicKey(users: [UserId]) -> Result<[UserWithKey], IronOxideError> {
        let userIdStringList = users.map({user in UserId_getId(user.inner)})
        let step = UInt(MemoryLayout<CRustString>.stride)
        let listOfUsers = userIdStringList.withUnsafeBufferPointer({pt in
            CRustObjectSlice(data: UnsafeMutableRawPointer(mutating: pt.baseAddress!), len: UInt(userIdStringList.count), step: step)
        })

        return Util.mapListResultTo(
            result: IronOxide_userGetPublicKey(ironoxide, listOfUsers),
            to: UserWithKey.init,
            fallbackError: "Failed to get list of public keys."
        )
    }

    /**
     * Delete a user device. If deleting the currently signed in device (`null` for `deviceId`), the sdk will need to be reinitialized
     * with `IronOxide.initialize()` before further use.
     */
    public func deleteDevice(deviceId: DeviceId?) -> Result<DeviceId, IronOxideError> {
        let rustId = deviceId == nil ? Util.rustNone() : Util.rustSome(deviceId!.inner)
        return Util.mapResultTo(
            result: IronOxide_userDeleteDevice(ironoxide, rustId),
            to: DeviceId.init,
            fallbackError: "Failed to delete device.")
    }

    /**
     * Rotate the current user's private key, but leave the public key the same. There's no black magic here! This is accomplished via
     * multi-party computation with the IronCore webservice.
     */
    public func rotatePrivateKey(password: String) -> Result<UserUpdatePrivateKeyResult, IronOxideError> {
        let rPassword = Util.swiftStringToRust(password)
        return Util.mapResultTo(
            result: IronOxide_userRotatePrivateKey(ironoxide, rPassword),
            to: UserUpdatePrivateKeyResult.init,
            fallbackError: "Failed to rotate users private key.")
    }
}
