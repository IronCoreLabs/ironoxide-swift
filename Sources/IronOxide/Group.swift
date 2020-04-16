import libironoxide

public struct GroupOperations {
    let ironoxide: OpaquePointer

    init(_ instance: OpaquePointer) {
        ironoxide = instance
    }

    public func list() {}

    public func getMetadata() {}

    public func create() {}

    public func updateName() {}

    public func delete() {}

    public func addMembers() {}

    public func removeMembers() {}

    public func addAdmins() {}

    public func removeAdmins() {}

    public func rotatePrivateKey() {}
}
