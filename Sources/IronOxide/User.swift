import Foundation
import libironoxide

/// Options for user creation.
public class UserCreateOpts: SdkObject {
    /**
     Constructs a default `UserCreateOpts` for common use cases.

     The user will be created with their private key not marked for rotation.
     */
    public convenience init() {
        self.init(UserCreateOpts_default())
    }

    /**
     Constructs a `UserCreateOpts`.

     - parameter needsRotation: `true` if the private key for this user should be marked for rotation
     */
    public convenience init(needsRotation: Bool) {
        self.init(UserCreateOpts_create(Util.boolToInt(needsRotation)))
    }

    deinit { UserCreateOpts_delete(inner) }
}

/**
 Metadata for a newly created user.

 Includes the user's public key and whether the user's private key needs rotation.
 */
public class UserCreateResult: SdkObject {
    /// Whether the user's private key needs to be rotated
    public lazy var needsRotation: Bool = {
        Util.intToBool(UserCreateResult_getNeedsRotation(inner))
    }()

    /**
     Public key for the user

     For most use cases, this public key can be discarded as IronCore escrows the user's keys. The escrowed keys are unlocked
     by the user's password.
     */
    public lazy var userPublicKey: PublicKey = {
        PublicKey(UserCreateResult_getUserPublicKey(inner))
    }()

    deinit { UserCreateResult_delete(inner) }
}

/// Options for device creation.
public class DeviceCreateOpts: SdkObject {
    /**
     Default `DeviceCreateOpts` for common use cases.

     The device will be created with no name.
     */
    public convenience init() {
        self.init(DeviceCreateOpts_default())
    }

    /**
     Constructs a `DeviceCreateOpts`.

     - parameter deviceName: The provided name will be used as the device's name. If `nil`, the name will be empty.
     */
    public convenience init(deviceName: DeviceName?) {
        self.init(DeviceCreateOpts_create(Util.buildOptionOf(deviceName, CRustClassOptDeviceName.init)))
    }

    deinit { DeviceCreateOpts_delete(inner) }
}

/// Metadata for a user.
public class UserResult: SdkObject {
    /// ID of the user
    public lazy var accountId: UserId = {
        UserId(UserResult_getAccountId(inner))
    }()

    /// Whether the user's private key needs rotation
    public lazy var needsRotation: Bool = {
        Util.intToBool(UserResult_getNeedsRotation(inner))
    }()

    /// Segment ID for the user
    public lazy var segmentId: UInt = {
        UserResult_getSegmentId(inner)
    }()

    /// Public key of the user
    public lazy var userPublicKey: PublicKey = {
        PublicKey(UserResult_getUserPublicKey(inner))
    }()

    deinit { UserResult_delete(inner) }
}

/**
 Metadata for a newly created device.

 Can be converted into a `DeviceContext` with `DeviceContext.init`.
 */
public class DeviceAddResult: SdkObject {
    /// ID of the user who owns the device
    public lazy var accountId: UserId = {
        UserId(DeviceAddResult_getAccountId(inner))
    }()

    /// ID of the device
    public lazy var deviceId: DeviceId = {
        DeviceId(DeviceAddResult_getDeviceId(inner))
    }()

    /// Name of the device
    public lazy var name: DeviceName? = {
        Util.toOption(DeviceAddResult_getName(inner)).map(DeviceName.init)
    }()

    /**
     Private key of the device

     This is different from the user's private key.
     */
    public lazy var devicePrivateKey: PrivateKey = {
        PrivateKey(DeviceAddResult_getDevicePrivateKey(inner))
    }()

    /// Segment of the user
    public lazy var segmentId: UInt = {
        DeviceAddResult_getSegmentId(inner)
    }()

    /// The signing keypair for the device
    public lazy var signingPrivateKey: DeviceSigningKeyPair = {
        DeviceSigningKeyPair(DeviceAddResult_getSigningPrivateKey(inner))
    }()

    /// The date and time of when the device was created
    public lazy var created: Date = {
        Util.timestampToDate(DeviceAddResult_getCreated(inner))
    }()

    /// The date and time of when the device was last updated
    public lazy var lastUpdated: Date = {
        Util.timestampToDate(DeviceAddResult_getLastUpdated(inner))
    }()

    deinit { DeviceAddResult_delete(inner) }
}

/// Metadata for a device.
public class UserDevice: SdkObject {
    /// ID of the device
    public lazy var id: DeviceId = {
        DeviceId(UserDevice_getId(inner))
    }()

    /// Name of the device
    public lazy var name: DeviceName? = {
        Util.toOption(UserDevice_getName(inner)).map(DeviceName.init)
    }()

    /// Whether this is the device that was used to make the API request
    public lazy var isCurrentDevice: Bool = {
        Util.intToBool(UserDevice_isCurrentDevice(inner))
    }()

    /// Date and time when the device was created
    public lazy var created: Date = {
        Util.timestampToDate(UserDevice_getCreated(inner))
    }()

    /// Date and time when the device was last updated
    public lazy var lastUpdated: Date = {
        Util.timestampToDate(UserDevice_getLastUpdated(inner))
    }()

    deinit { UserDevice_delete(inner) }
}

/**
 Metadata for each device the user has authorized.

 The results are sorted based on the device's ID.
 */
public class UserDeviceListResult: SdkObject {
    /// Metadata for each device the user has authorized
    public lazy var result: [UserDevice] = {
        Util.collectTo(list: UserDeviceListResult_getResult(inner), to: UserDevice.init)
    }()

    deinit { UserDeviceListResult_delete(inner) }
}

/// User and their public encryption key
public class UserWithKey: SdkObject {
    /// ID of the user
    public lazy var id: UserId = {
        UserId(UserWithKey_getUser(inner))
    }()

    /// Public encryption key of the user
    public lazy var publicKey: PublicKey = {
        PublicKey(UserWithKey_getPublicKey(inner))
    }()

    deinit { UserWithKey_delete(inner) }
}

/// Metadata from user private key rotation.
public class UserUpdatePrivateKeyResult: SdkObject {
    /// Whether this user's private key needs further rotation
    public lazy var needsRotation: Bool = {
        Util.intToBool(UserUpdatePrivateKeyResult_getNeedsRotation(inner))
    }()

    /// Updated encrypted private key of the user
    public lazy var userMasterPrivateKey: EncryptedPrivateKey = {
        EncryptedPrivateKey(UserUpdatePrivateKeyResult_getUserMasterPrivateKey(inner))
    }()

    deinit { UserUpdatePrivateKeyResult_delete(inner) }
}

/**
 IronOxide User Operations

 # Key Terms
 - Device - The only entity in the Data Control Platform that can decrypt data. A device is authorized using a user’s private key,
     therefore a device is tightly bound to a user.
 - ID - The ID representing a user or device. It must be unique within its segment and will **not** be encrypted.
 - Password - The string used to encrypt and escrow a user's private key.
 - Rotation - Changing a user's private key while leaving their public key unchanged. This can be accomplished by calling
     `SDK.user.rotatePrivateKey`.
 */
public struct UserOperations {
    let ironoxide: OpaquePointer
    init(_ instance: OpaquePointer) {
        ironoxide = instance
    }

    /// Lists all of the devices for the current user.
    public func listDevices() -> Result<UserDeviceListResult, IronOxideError> {
        Util.toResult(IronOxide_userListDevices(ironoxide)).map(UserDeviceListResult.init)
    }

    /**
     Gets users' public keys given their IDs.

     Allows discovery of which user IDs have keys in the IronCore system to help determine if they can be added to groups
     or have documents shared with them.

     Only returns users whose keys were found in the IronCore system.

     - parameter users: List of user IDs to check
     */
    public func getPublicKey(users: [UserId]) -> Result<[UserWithKey], IronOxideError> {
        let listOfUsers = RustObjects(array: users, fn: UserId_getId)
        return listOfUsers.withSlice { users in
            Util.mapListResultTo(
                result: IronOxide_userGetPublicKey(ironoxide, users),
                to: UserWithKey.init
            )
        }
    }

    /**
     Deletes a device.

     If deleting the currently signed-in device, the SDK will need to be
     re-initialized with `IronOxide.initialize` before further use.

     Returns the ID of the deleted device.

     - parameter deviceId: ID of the device to delete. If `nil`, deletes the current device
     */
    public func deleteDevice(deviceId: DeviceId?) -> Result<DeviceId, IronOxideError> {
        let deviceIdPtr = Util.buildOptionOf(deviceId, CRustClassOptDeviceId.init)
        return Util.toResult(IronOxide_userDeleteDevice(ironoxide, deviceIdPtr))
            .map(DeviceId.init)
    }

    /**
     Rotates the current user's private key while leaving their public key the same.

     There's no black magic here! This is accomplished via multi-party computation with the IronCore webservice.

     The main use case for this is a workflow that requires that users be generated prior to the user logging in for the first time.
     In this situation, a user's cryptographic identity can be generated by a third party, like a server process, and then
     the user can take control of their keys by rotating their private key.

     - parameter password: Password to unlock the current user's private key
     */
    public func rotatePrivateKey(password: String) -> Result<UserUpdatePrivateKeyResult, IronOxideError> {
        Util.toResult(IronOxide_userRotatePrivateKey(ironoxide, Util.swiftStringToRust(password))).map(UserUpdatePrivateKeyResult.init)
    }
}
