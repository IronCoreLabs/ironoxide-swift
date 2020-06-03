import libironoxide

/**
 Struct that represents an initialized IronOxide SDK.

 Contains properties and methods for all SDK functionality
 */
public class SDK {
    let ironoxide: OpaquePointer
    /// Document API
    public let document: DocumentOperations
    /// Group API
    public let group: GroupOperations
    /// User API
    public let user: UserOperations
    /// Search API
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
