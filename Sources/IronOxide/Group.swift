import Foundation
import libironoxide

/**
 * Readable group name.
 */
public class GroupName: SdkObject {
    /**
     * Create a GroupName from the provided string. Will fail if the string contains invalid characters
     */
    public convenience init?(_ name: String) {
        switch Util.toResult(DeviceName_validate(Util.swiftStringToRust(name))) {
        case let .success(groupName):
            self.init(groupName)
        case .failure:
            return nil
        }
    }

    public lazy var name: String = {
        Util.rustStringToSwift(GroupName_getName(inner))
    }()

    deinit { GroupName_delete(inner) }
}

/**
 * Options that can be specified creating a group.
 */
public class GroupCreateOpts: SdkObject {
    public convenience init() {
        self.init(GroupCreateOpts_default())
    }

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
        let adminsPtr = Util.arrayToRustSlice(array: admins, fn: UserId_getId)
        let membersPtr = Util.arrayToRustSlice(array: members, fn: UserId_getId)
        let needsRotationPtr = Util.boolToInt(needsRotation)
        self.init(GroupCreateOpts_create(idPtr, namePtr, addAsAdminPtr, addAsMemberPtr, ownerPtr, adminsPtr, membersPtr, needsRotationPtr))
    }

    deinit { GroupCreateOpts_delete(inner) }
}

public class GroupUserList: SdkObject {
    public lazy var list: [UserId] = {
        Util.collectTo(list: GroupUserList_getList(inner), to: UserId.init)
    }()

    deinit { GroupUserList_delete(inner) }
}

/**
 * Metadata for a newly created group.
 */
public class GroupCreateResult: SdkObject {
    public lazy var groupId: GroupId = {
        GroupId(GroupCreateResult_getId(inner))
    }()

    public lazy var groupName: GroupName? = {
        Util.toOption(GroupCreateResult_getName(inner)).map(GroupName.init)
    }()

    public lazy var groupMasterPublicKey: PublicKey = {
        PublicKey(GroupCreateResult_getGroupMasterPublicKey(inner))
    }()

    public lazy var isAdmin: Bool = {
        Util.intToBool(GroupCreateResult_isAdmin(inner))
    }()

    public lazy var isMember: Bool = {
        Util.intToBool(GroupCreateResult_isMember(inner))
    }()

    public lazy var owner: UserId = {
        UserId(GroupCreateResult_getOwner(inner))
    }()

    public lazy var adminList: GroupUserList = {
        GroupUserList(GroupCreateResult_getAdminList(inner))
    }()

    public lazy var memberList: GroupUserList = {
        GroupUserList(GroupCreateResult_getAdminList(inner))
    }()

    public lazy var created: Date = {
        Util.timestampToDate(GroupCreateResult_getCreated(inner))
    }()

    public lazy var lastUpdated: Date = {
        Util.timestampToDate(GroupCreateResult_getLastUpdated(inner))
    }()

    public lazy var needsRotation: Bool? = {
        Util.toOption(GroupCreateResult_getNeedsRotation(inner)).map(Util.nullableBooleanToBool)
    }()

    deinit { GroupCreateResult_delete(inner) }
}

/**
 * Metadata for a group
 */
public class GroupMetaResult: SdkObject {
    public lazy var id: GroupId = {
        GroupId(GroupMetaResult_getId(inner))
    }()

    public lazy var name: GroupName? = {
        Util.toOption(GroupMetaResult_getName(inner)).map(GroupName.init)
    }()

    public lazy var isAdmin: Bool = {
        Util.intToBool(GroupMetaResult_isAdmin(inner))
    }()

    public lazy var isMember: Bool = {
        Util.intToBool(GroupMetaResult_isMember(inner))
    }()

    public lazy var created: Date = {
        Util.timestampToDate(GroupMetaResult_getCreated(inner))
    }()

    public lazy var lastUpdated: Date = {
        Util.timestampToDate(GroupMetaResult_getLastUpdated(inner))
    }()

    public lazy var needsRotation: Bool? = {
        Util.toOption(GroupMetaResult_getNeedsRotation(inner)).map(Util.nullableBooleanToBool)
    }()

    deinit { GroupMetaResult_delete(inner) }
}

public class GroupListResult: SdkObject {
    public lazy var result: [GroupMetaResult] = {
        Util.collectTo(list: GroupListResult_getResult(inner), to: GroupMetaResult.init)
    }()

    deinit { GroupListResult_delete(inner) }
}

/**
 * Result from requesting changes to a group's membership or administrators. Partial success is supported.
 */
public class GroupAccessEditResult: SdkObject {
    public lazy var succeeded: [UserId] = {
        Util.collectTo(list: GroupAccessEditResult_getSucceeded(inner), to: UserId.init)
    }()

    public lazy var failed: [GroupAccessEditErr] = {
        Util.collectTo(list: GroupAccessEditResult_getFailed(inner), to: GroupAccessEditErr.init)
    }()

    deinit { GroupAccessEditResult_delete(inner) }
}

/**
 * A failure to edit a group's administrator or membership lists
 */
public class GroupAccessEditErr: SdkObject {
    public lazy var user: UserId = {
        UserId(GroupAccessEditErr_getUser(inner))
    }()

    public lazy var error: String = {
        Util.rustStringToSwift(GroupAccessEditErr_getError(inner))
    }()

    deinit { GroupAccessEditErr_delete(inner) }
}

/**
 * Result of rotating a group's private key.
 */
public class GroupUpdatePrivateKeyResult: SdkObject {
    public lazy var groupId: GroupId = {
        GroupId(GroupUpdatePrivateKeyResult_getId(inner))
    }()

    public lazy var needsRotation: Bool = {
        Util.intToBool(GroupUpdatePrivateKeyResult_getNeedsRotation(inner))
    }()

    deinit { GroupUpdatePrivateKeyResult_delete(inner) }
}

public struct GroupOperations {
    let ironoxide: OpaquePointer

    init(_ instance: OpaquePointer) {
        ironoxide = instance
    }

    /**
     * List all of the groups that the current user is either an admin or member of.
     */
    public func list() -> Result<GroupListResult, IronOxideError> {
        Util.toResult(IronOxide_groupList(ironoxide)).map(GroupListResult.init)
    }

    /**
     * Get the full metadata for a specific group given its ID.
     */
    public func getMetadata(groupId: GroupId) -> Result<GroupMetaResult, IronOxideError> {
        Util.toResult(IronOxide_groupGetMetadata(ironoxide, groupId.inner)).map(GroupMetaResult.init)
    }

    /**
     * Create a group
     */
    public func create(groupCreateOpts: GroupCreateOpts = GroupCreateOpts()) -> Result<GroupCreateResult, IronOxideError> {
        Util.toResult(IronOxide_groupCreate(ironoxide, groupCreateOpts.inner)).map(GroupCreateResult.init)
    }

    /**
     * Update a group name to a new value or clear its value.
     */
    public func updateName(groupId: GroupId, groupName: GroupName?) -> Result<GroupMetaResult, IronOxideError> {
        let namePtr = groupName == nil ? CRustClassOptGroupName() : CRustClassOptGroupName(p: UnsafeMutableRawPointer(groupName!.inner))
        return Util.toResult(IronOxide_groupUpdateName(ironoxide, groupId.inner, namePtr)).map(GroupMetaResult.init)
    }

    /**
     * Delete a group given its ID
     */
    public func delete(groupId: GroupId) -> Result<GroupId, IronOxideError> {
        Util.toResult(IronOxide_groupDelete(ironoxide, groupId.inner)).map(GroupId.init)
    }

    /**
     * Add the users as members of a group.
     */
    public func addMembers(groupId: GroupId, users: [UserId]) -> Result<GroupAccessEditResult, IronOxideError> {
        groupChangeMembership(groupId, users, IronOxide_groupAddMembers)
    }

    /**
     * Remove a list of users as members from the group.
     */
    public func removeMembers(groupId: GroupId, users: [UserId]) -> Result<GroupAccessEditResult, IronOxideError> {
        groupChangeMembership(groupId, users, IronOxide_groupRemoveMembers)
    }

    /**
     * Add the users as admins of a group.
     */
    public func addAdmins(groupId: GroupId, users: [UserId]) -> Result<GroupAccessEditResult, IronOxideError> {
        groupChangeMembership(groupId, users, IronOxide_groupAddAdmins)
    }

    /**
     * Remove a list of users as admins from the group
     */
    public func removeAdmins(groupId: GroupId, users: [UserId]) -> Result<GroupAccessEditResult, IronOxideError> {
        groupChangeMembership(groupId, users, IronOxide_groupRemoveAdmins)
    }

    /**
     * Rotate the provided group's private key, but leave the public key the same.
     * There's no black magic here! This is accomplished via multi-party computation with the
     * IronCore webservice.
     * Note: You must be an admin of the group in order to rotate its private key.
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
        let listOfUsers = Util.arrayToRustSlice(array: users, fn: UserId_getId)
        return Util.toResult(fn(ironoxide, groupId.inner, listOfUsers)).map(GroupAccessEditResult.init)
    }
}
