/**
 * Struct that represents an initialized IronOxide SDK. Contains properties and methods for all SDK functionality
 */
public struct SDK {
    var ironoxide: OpaquePointer
    public let document: DocumentOperations
    public let group: GroupOperations
    public let user: UserOperations
    public let search: SearchOperations

    init(_ instance: OpaquePointer) {
        ironoxide = instance
        document = DocumentOperations(ironoxide)
        group = GroupOperations(ironoxide)
        user = UserOperations(ironoxide)
        search = SearchOperations(ironoxide)
    }

    public func clearPolicyCache() {}
}
