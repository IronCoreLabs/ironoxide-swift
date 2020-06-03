import Foundation
import libironoxide

/**
 Name of a group.

 Must be between 1 and 100 characters long.
 */
public class GroupName: SdkObject {
    /**
     Constructs a `GroupName` from the provided String.

     Fails if the string contains invalid characters.
     */
    public convenience init?(_ name: String) {
        switch Util.toResult(DeviceName_validate(Util.swiftStringToRust(name))) {
        case let .success(groupName):
            self.init(groupName)
        case .failure:
            return nil
        }
    }

    /// Name of the group
    public lazy var name: String = {
        Util.rustStringToSwift(GroupName_getName(inner))
    }()

    deinit { GroupName_delete(inner) }
}

extension GroupName: Equatable {
    public static func == (lhs: GroupName, rhs: GroupName) -> Bool {
        Util.intToBool(private_GroupName_rustEq(lhs.inner, rhs.inner))
    }
}

/// Options for group creation.
public class GroupCreateOpts: SdkObject {
    /**
     Default `GroupCreateOpts` for common use cases.

     The group will be assigned an ID and have an empty name. The user who creates the group will be the owner of the group
     as well as the only admin and member of the group. The group's private key will not be marked for rotation.
     */
    public convenience init() {
        self.init(GroupCreateOpts_default())
    }

    /**
     Constructs a `GroupCreateOpts`.

     - parameters:
         - id: The provided ID will be used as the group's ID. If `nil`, the server will assign the group's ID.
         - name: The provided name will be used as the group's name. If `nil`, the name will be empty.
         - add_as_admin: Whether the creating user should be added as a group admin.
         - add_as_member: Whether the creating user should be added as a group member.
         - owner: The provided user will be the owner of the group. If `nil`, the creating user will be the group owner.
         - admins: The list of users to be added as group admins.
         - members: The list of users to be added as group members.
         - needs_rotation: Whether the group's private key should be marked for rotation.
     */
    public convenience init(
        id: GroupId?,
        name: GroupName?,
        addAsAdmin: Bool,
        addAsMember: Bool,
        owner: UserId?,
        admins: [UserId],
        members: [UserId],
        needsRotation: Bool
    ) {
        let idPtr = Util.buildOptionOf(id, CRustClassOptGroupId.init)
        let namePtr = Util.buildOptionOf(name, CRustClassOptGroupName.init)
        let addAsAdminPtr = Util.boolToInt(addAsAdmin)
        let addAsMemberPtr = Util.boolToInt(addAsMember)
        let ownerPtr = Util.buildOptionOf(owner, CRustClassOptUserId.init)
        let needsRotationPtr = Util.boolToInt(needsRotation)
        self.init(RustObjects(array: admins, fn: UserId_getId).withSlice { adminsSlice in
            RustObjects(array: members, fn: UserId_getId).withSlice { membersSlice in
                GroupCreateOpts_create(idPtr, namePtr, addAsAdminPtr, addAsMemberPtr, ownerPtr, adminsSlice, membersSlice, needsRotationPtr)
            }
        })
    }

    deinit { GroupCreateOpts_delete(inner) }
}

/// A list of group users.
public class GroupUserList: SdkObject {
    /// Users associated with the group
    public lazy var list: [UserId] = {
        Util.collectTo(list: GroupUserList_getList(inner), to: UserId.init)
    }()

    deinit { GroupUserList_delete(inner) }
}

/// Full metadata for a newly created group.
public class GroupCreateResult: SdkObject {
    /// ID of the group
    public lazy var groupId: GroupId = {
        GroupId(GroupCreateResult_getId(inner))
    }()

    /// Name of the group
    public lazy var groupName: GroupName? = {
        Util.toOption(GroupCreateResult_getName(inner)).map(GroupName.init)
    }()

    /// Public key for encrypting to the group
    public lazy var groupMasterPublicKey: PublicKey = {
        PublicKey(GroupCreateResult_getGroupMasterPublicKey(inner))
    }()

    /// `true` if the calling user is a group administrator
    public lazy var isAdmin: Bool = {
        Util.intToBool(GroupCreateResult_isAdmin(inner))
    }()

    /// `true` if the calling user is a group member
    public lazy var isMember: Bool = {
        Util.intToBool(GroupCreateResult_isMember(inner))
    }()

    /// Owner of the group
    public lazy var owner: UserId = {
        UserId(GroupCreateResult_getOwner(inner))
    }()

    /// List of all group administrators
    public lazy var adminList: GroupUserList = {
        GroupUserList(GroupCreateResult_getAdminList(inner))
    }()

    /// List of all group members
    public lazy var memberList: GroupUserList = {
        GroupUserList(GroupCreateResult_getMemberList(inner))
    }()

    /// Date and time of when the group was created
    public lazy var created: Date = {
        Util.timestampToDate(GroupCreateResult_getCreated(inner))
    }()

    /// Date and time of when the group was last updated
    public lazy var lastUpdated: Date = {
        Util.timestampToDate(GroupCreateResult_getLastUpdated(inner))
    }()

    /**
     Whether the group's private key needs rotation.

     Can only be accessed by a group administrator.

     - returns:
        - `Bool` - Indicates whether the group's private key needs rotation.
        - `nil` - The calling user does not have permission to view this.
     */
    public lazy var needsRotation: Bool? = {
        Util.toOption(GroupCreateResult_getNeedsRotation(inner)).map(Util.nullableBooleanToBool)
    }()

    deinit { GroupCreateResult_delete(inner) }
}

/// Full metadata for a group.
public class GroupGetResult: SdkObject {
    /// ID of the group
    public lazy var groupId: GroupId = {
        GroupId(GroupGetResult_getId(inner))
    }()

    /// Name of the group
    public lazy var groupName: GroupName? = {
        Util.toOption(GroupGetResult_getName(inner)).map(GroupName.init)
    }()

    /// Public key for encrypting to the group
    public lazy var groupMasterPublicKey: PublicKey = {
        PublicKey(GroupGetResult_getGroupMasterPublicKey(inner))
    }()

    /// `true` if the calling user is a group administrator
    public lazy var isAdmin: Bool = {
        Util.intToBool(GroupGetResult_isAdmin(inner))
    }()

    /// `true` if the calling user is a group member
    public lazy var isMember: Bool = {
        Util.intToBool(GroupGetResult_isMember(inner))
    }()

    /// List of all group administrators
    public lazy var adminList: GroupUserList? = {
        Util.toOption(GroupGetResult_getAdminList(inner)).map(GroupUserList.init)
    }()

    /// List of all group members
    public lazy var memberList: GroupUserList? = {
        Util.toOption(GroupGetResult_getMemberList(inner)).map(GroupUserList.init)
    }()

    /// Date and time of when the group was created
    public lazy var created: Date = {
        Util.timestampToDate(GroupGetResult_getCreated(inner))
    }()

    /// Date and time of when the group was last updated
    public lazy var lastUpdated: Date = {
        Util.timestampToDate(GroupGetResult_getLastUpdated(inner))
    }()

    /**
     Whether the group's private key needs rotation.

     Can only be accessed by a group administrator.

     - returns:
        - `Bool` - Indicates whether the group's private key needs rotation.
        - `nil` - The calling user does not have permission to view this.
     */
    public lazy var needsRotation: Bool? = {
        Util.toOption(GroupGetResult_getNeedsRotation(inner)).map(Util.nullableBooleanToBool)
    }()

    deinit { GroupGetResult_delete(inner) }
}

/// Abbreviated group metadata.
public class GroupMetaResult: SdkObject {
    /// ID of the group
    public lazy var id: GroupId = {
        GroupId(GroupMetaResult_getId(inner))
    }()

    /// Name of the group
    public lazy var name: GroupName? = {
        Util.toOption(GroupMetaResult_getName(inner)).map(GroupName.init)
    }()

    /// `true` if the calling user is a group administrator
    public lazy var isAdmin: Bool = {
        Util.intToBool(GroupMetaResult_isAdmin(inner))
    }()

    /// `true` if the calling user is a group member
    public lazy var isMember: Bool = {
        Util.intToBool(GroupMetaResult_isMember(inner))
    }()

    /// Date and time of when the group was created
    public lazy var created: Date = {
        Util.timestampToDate(GroupMetaResult_getCreated(inner))
    }()

    /// Date and time of when the group was last updated
    public lazy var lastUpdated: Date = {
        Util.timestampToDate(GroupMetaResult_getLastUpdated(inner))
    }()

    /**
     Whether the group's private key needs rotation.

     Can only be accessed by a group administrator.

     - returns:
        - `Bool` - Indicates whether the group's private key needs rotation.
        - `nil` - The calling user does not have permission to view this.
     */
    public lazy var needsRotation: Bool? = {
        Util.toOption(GroupMetaResult_getNeedsRotation(inner)).map(Util.nullableBooleanToBool)
    }()

    deinit { GroupMetaResult_delete(inner) }
}

/// Metadata for each group the user is an admin or a member of.
public class GroupListResult: SdkObject {
    /// Metadata for each group that the requesting user is an admin or a member of
    public lazy var result: [GroupMetaResult] = {
        Util.collectTo(list: GroupListResult_getResult(inner), to: GroupMetaResult.init)
    }()

    deinit { GroupListResult_delete(inner) }
}

/**
 Successful and failed changes to a group's member or admin lists.

 Partial success is supported.
 */
public class GroupAccessEditResult: SdkObject {
    /// Users whose access was successfully modified
    public lazy var succeeded: [UserId] = {
        Util.collectTo(list: GroupAccessEditResult_getSucceeded(inner), to: UserId.init)
    }()

    /// Errors resulting from failure to modify a user's access
    public lazy var failed: [GroupAccessEditErr] = {
        Util.collectTo(list: GroupAccessEditResult_getFailed(inner), to: GroupAccessEditErr.init)
    }()

    deinit { GroupAccessEditResult_delete(inner) }
}

/// A failure when attempting to change a group's member or admin lists.
public class GroupAccessEditErr: SdkObject {
    /// The user who was unable to be added/removed from the group.
    public lazy var user: UserId = {
        UserId(GroupAccessEditErr_getUser(inner))
    }()

    /// The error encountered when attempting to add/remove the user from the group.
    public lazy var error: String = {
        Util.rustStringToSwift(GroupAccessEditErr_getError(inner))
    }()

    deinit { GroupAccessEditErr_delete(inner) }
}

/// Metadata returned after rotating a group's private key.
public class GroupUpdatePrivateKeyResult: SdkObject {
    /// The ID of the group
    public lazy var groupId: GroupId = {
        GroupId(GroupUpdatePrivateKeyResult_getId(inner))
    }()

    /// `true` if this group's private key requires additional rotation
    public lazy var needsRotation: Bool = {
        Util.intToBool(GroupUpdatePrivateKeyResult_getNeedsRotation(inner))
    }()

    deinit { GroupUpdatePrivateKeyResult_delete(inner) }
}

/**
 IronOxide Group Operations

 # Key Terms
 - ID     - The ID representing a group. It must be unique within the group's segment and will **not** be encrypted.
 - Name   - The human-readable name of a group. It does not need to be unique and will **not** be encrypted.
 - Member - A user who is able to encrypt and decrypt data using the group.
 - Admin  - A user who is able to manage the group's member and admin lists. An admin cannot encrypt or decrypt data using the group
            unless they first add themselves as group members or are added by another admin.
 - Owner  - The user who owns the group. The owner has the same permissions as a group admin, but is protected from being removed as
            a group admin.
 - Rotation - Changing a group's private key while leaving its public key unchanged. This can be accomplished by calling
     `SDK.group.rotatePrivateKey`.
 */
public struct GroupOperations {
    let ironoxide: OpaquePointer

    init(_ instance: OpaquePointer) {
        ironoxide = instance
    }

    /// Lists all of the groups that the current user is an admin or a member of.
    public func list() -> Result<GroupListResult, IronOxideError> {
        Util.toResult(IronOxide_groupList(ironoxide)).map(GroupListResult.init)
    }

    /**
     Gets the full metadata for a group.

     The encrypted private key for the group will not be returned.

     - parameter groupId: ID of the group to retrieve
     */
    public func getMetadata(groupId: GroupId) -> Result<GroupGetResult, IronOxideError> {
        Util.toResult(IronOxide_groupGetMetadata(ironoxide, groupId.inner)).map(GroupGetResult.init)
    }

    /**
     Creates a group.

     With default `GroupCreateOpts`, the group will be assigned an ID and have no name. The creating user will become the
     owner of the group and the only group member and administrator.

     - parameter groupCreateOpts: Group creation parameters
     */
    public func create(groupCreateOpts: GroupCreateOpts = GroupCreateOpts()) -> Result<GroupCreateResult, IronOxideError> {
        Util.toResult(IronOxide_groupCreate(ironoxide, groupCreateOpts.inner)).map(GroupCreateResult.init)
    }

    /**
     Modifies or removes a group's name.

     Returns the updated metadata of the group.

     - parameters:
        - groupId: ID of the group to update
        - groupName: New name for the group. Provide a `GroupName` to update to a new name or `nil` to clear the group's name
     */
    public func updateName(groupId: GroupId, groupName: GroupName?) -> Result<GroupMetaResult, IronOxideError> {
        let namePtr = Util.buildOptionOf(groupName, CRustClassOptGroupName.init)
        return Util.toResult(IronOxide_groupUpdateName(ironoxide, groupId.inner, namePtr)).map(GroupMetaResult.init)
    }

    /**
     Deletes a group.

     A group can be deleted even if it has existing members and administrators.

     **Warning: Deleting a group will prevent its members from decrypting all of the
     documents previously encrypted to the group. Caution should be used when deleting groups.**

     - parameter groupId: ID of the group to delete
     */
    public func delete(groupId: GroupId) -> Result<GroupId, IronOxideError> {
        Util.toResult(IronOxide_groupDelete(ironoxide, groupId.inner)).map(GroupId.init)
    }

    /**
     Adds members to a group.

     Returns successful and failed additions.

     - parameters:
        - groupId:  ID of the group to add members to
        - users: List of users to add as group members
     */
    public func addMembers(groupId: GroupId, users: [UserId]) -> Result<GroupAccessEditResult, IronOxideError> {
        groupChangeMembership(groupId, users, IronOxide_groupAddMembers)
    }

    /**
     Removes members from a group.

     Returns successful and failed removals.

     - parameters:
        - groupId:  ID of the group to remove members from
        - users: List of users to remove as group members
     */
    public func removeMembers(groupId: GroupId, users: [UserId]) -> Result<GroupAccessEditResult, IronOxideError> {
        groupChangeMembership(groupId, users, IronOxide_groupRemoveMembers)
    }

    /**
     Adds administrators to a group.

     Returns successful and failed additions.

     - parameters:
        - groupId:  ID of the group to add administrators to
        - users: List of users to add as group administrators
     */
    public func addAdmins(groupId: GroupId, users: [UserId]) -> Result<GroupAccessEditResult, IronOxideError> {
        groupChangeMembership(groupId, users, IronOxide_groupAddAdmins)
    }

    /**
     Removes administrators from a group.

     Returns successful and failed removals.

     - parameters:
        - groupId:  ID of the group to remove administrators from
        - users: List of users to remove as group administrators
     */
    public func removeAdmins(groupId: GroupId, users: [UserId]) -> Result<GroupAccessEditResult, IronOxideError> {
        groupChangeMembership(groupId, users, IronOxide_groupRemoveAdmins)
    }

    /**
     Rotates a group's private key while leaving its public key unchanged.

     There's no black magic here! This is accomplished via multi-party computation with the
     IronCore webservice.

     Note: You must be an administrator of a group in order to rotate its private key.

     - parameter groupId: ID of the group whose private key should be rotated
     */
    public func rotatePrivateKey(groupId: GroupId) -> Result<GroupUpdatePrivateKeyResult, IronOxideError> {
        Util.toResult(IronOxide_groupRotatePrivateKey(ironoxide, groupId.inner)).map(GroupUpdatePrivateKeyResult.init)
    }

    /// Helper function to reduce copy/paste of group membership functions. Takes the group, users, and C function to call on the group.
    func groupChangeMembership(
        _ groupId: GroupId,
        _ users: [UserId],
        _ fn: (OpaquePointer, OpaquePointer, CRustObjectSlice) -> CRustResult4232mut3232c_voidCRustString
    ) -> Result<GroupAccessEditResult, IronOxideError> {
        Util.toResult(RustObjects(array: users, fn: UserId_getId).withSlice { usersSlice in
            fn(ironoxide, groupId.inner, usersSlice)
        }).map(GroupAccessEditResult.init)
    }
}
