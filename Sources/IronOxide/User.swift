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
    public init(_ res: OpaquePointer) {
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

    public func getCreated() -> Int64 {
        DeviceAddResult_getCreated(inner)
    }

    public func getLastUpdated() -> Int64 {
        DeviceAddResult_getLastUpdated(inner)
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

    public func listDevices() {}

    public func getPublicKey() {}

    public func deleteDevice() {}

    public func rotatePrivateKey() {}
}
