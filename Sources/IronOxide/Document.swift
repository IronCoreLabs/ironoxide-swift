import libironoxide

public struct AdvancedDocumentOperations {
    let ironoxide: OpaquePointer
    init(_ instance: OpaquePointer) {
        ironoxide = instance
    }

    public func encryptUnmanaged() {}

    public func decryptUnmanaged() {}
}

public struct DocumentOperations {
    let ironoxide: OpaquePointer
    let advanced: AdvancedDocumentOperations

    init(_ instance: OpaquePointer) {
        ironoxide = instance
        advanced = AdvancedDocumentOperations(ironoxide)
    }

    public func list() {}

    public func getMetadata() {}

    public func getIdFromBytes() {}

    public func encrypt() {}

    public func updateBytes() {}

    public func decrypt() {}

    public func updateName() {}

    public func grantAccess() {}

    public func revokeAccess() {}
}
