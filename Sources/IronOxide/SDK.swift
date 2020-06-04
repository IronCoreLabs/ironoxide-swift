import libironoxide

/**
 Struct that represents an initialized IronOxide SDK.

 Contains properties and methods for all SDK functionality
 */
public class SDK {
    let ironoxide: OpaquePointer
    /**
     Encrypted documents give your application the ability to keep information secure no matter where it lives.
     Your users' data is encrypted end-to-end, from the point where the data was initially generated until it gets to your
     user's device to be used.
     */
    public let document: DocumentOperations
    /**
     The `group` namespace provides methods to manage your cryptographic groups. These methods can be used to retrieve existing groups,
     create new groups, and manage the administrators and members of your group.
     */
    public let group: GroupOperations
    /// The `user` namespace provides methods to act upon the currently authorized user.
    public let user: UserOperations
    /**
     The `search` namespace provides methods to create and manage encrypted blind search indexes.
     This provides the ability to index and search over encrypted data without having to decrypt the data first.
     Indexes are encrypted to a specific group so that every member of the group has the ability to initialize the search index and query against it.
     */
    public let search: SearchOperations

    init(_ instance: OpaquePointer) {
        ironoxide = instance
        document = DocumentOperations(ironoxide)
        group = GroupOperations(ironoxide)
        user = UserOperations(ironoxide)
        search = SearchOperations(ironoxide)
    }

    /**
     Clears all entries from the policy cache.

     Returns the number of entries cleared from the cache.
     */
    public func clearPolicyCache() -> UInt {
        IronOxide_clearPolicyCache(ironoxide)
    }

    deinit { IronOxide_delete(ironoxide) }
}
