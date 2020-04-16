import libironoxide

/**
 * Represents an asymmetric public key that wraps the underlying bytes of the key.
 */
public struct PublicKey {
    let inner: OpaquePointer
    init(_ pk: OpaquePointer) {
        inner = pk
    }

    public func asBytes() -> [UInt8] {
        let pk = PublicKey_asBytes(inner)
        return Array(UnsafeBufferPointer(start: pk.data, count: Int(pk.len))).map(UInt8.init)
    }
}
