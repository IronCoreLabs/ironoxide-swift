import libironoxide

/// Encrypted Blind Index Salt
public class EncryptedBlindIndexSalt: SdkObject {
    /// Constructs an EncryptedBlindIndexSalt from its DEKs and bytes
    public convenience init(encryptedDeks: [UInt8], encryptedSaltBytes: [UInt8]) {
        self.init(RustBytes(encryptedDeks).withSlice { deksSlice in
            RustBytes(encryptedSaltBytes).withSlice { saltSlice in
                EncryptedBlindIndexSalt_create(deksSlice, saltSlice)
            }
        })
    }

    /// Encrypted DEKs
    public lazy var encryptedDeks: [UInt8] = {
        Util.rustVecToBytes(EncryptedBlindIndexSalt_getEncryptedDeks(inner))
    }()

    /// Encrypted Salt Bytes
    public lazy var encryptedSaltBytes: [UInt8] = {
        Util.rustVecToBytes(EncryptedBlindIndexSalt_getEncryptedSaltBytes(inner))
    }()

    deinit { EncryptedBlindIndexSalt_delete(inner) }
}

/// Blind Index Search
public class BlindIndexSearch: SdkObject {
    /// Generates the list of tokens to use to find entries that match the search query, given the specified partitionId.
    public func tokenizeQuery(query: String, partitionId: String?) -> Result<[UInt32], IronOxideError> {
        tokenize(query, partitionId, BlindIndexSearch_tokenizeQuery)
    }

    /**
     Generates the list of tokens to create a search entry for `data`.

     This function will also return some random values in the array, which will make it harder for someone to know what
     the input was. Because of this, calling this function will not be the same as `tokenizeQuery`, but
     `tokenizeQuery` will always return a subset of the values returned by `tokenizeData`.
     */
    public func tokenizeData(data: String, partitionId: String?) -> Result<[UInt32], IronOxideError> {
        tokenize(data, partitionId, BlindIndexSearch_tokenizeData)
    }

    func tokenize(
        _ query: String,
        _ partitionId: String?,
        _ fn: (OpaquePointer, CRustStrView, CRustOptionCRustStrView) -> CRustResultCRustVeci32CRustString
    ) -> Result<[UInt32], IronOxideError> {
        var partitionIdPtr: CRustOptionCRustStrView
        if let id = partitionId {
            let unionStrView = CRustOptionUnionCRustStrView(data: Util.swiftStringToRust(id))
            partitionIdPtr = CRustOptionCRustStrView(val: unionStrView, is_some: 1)
        } else {
            partitionIdPtr = CRustOptionCRustStrView()
        }
        return Util.mapListResultToUInt32Array(fn(inner, Util.swiftStringToRust(query), partitionIdPtr))
    }

    deinit { BlindIndexSearch_delete(inner) }
}

/// IronOxide Search Operations
public struct SearchOperations {
    let ironoxide: OpaquePointer
    init(_ instance: OpaquePointer) {
        ironoxide = instance
    }

    /// Create an index and encrypt it to the provided groupId.
    public func createBlindIndex(groupId: GroupId) -> Result<EncryptedBlindIndexSalt, IronOxideError> {
        Util.toResult(IronOxide_createBlindIndex(ironoxide, groupId.inner)).map(EncryptedBlindIndexSalt.init)
    }

    /// Initializes the blind index search
    public func initializeSearch(encryptedSalt: EncryptedBlindIndexSalt) -> Result<BlindIndexSearch, IronOxideError> {
        Util.toResult(IronOxide_initializeBlindIndexSearch(ironoxide, encryptedSalt.inner)).map(BlindIndexSearch.init)
    }
}
