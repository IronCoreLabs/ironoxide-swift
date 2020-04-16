import libironoxide

public struct SearchOperations {
    let ironoxide: OpaquePointer
    init(_ instance: OpaquePointer) {
        ironoxide = instance
    }

    public func createBlindIndex() {}
}
