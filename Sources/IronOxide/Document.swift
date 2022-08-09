import Foundation
import libironoxide

/**
 Name of a document.

 The name should be human-readable and does not have to be unique.

 Must be between 1 and 100 characters long.
 */
public class DocumentName: SdkObject {
    /**
     Constructs a `DocumentName` from a String.

     Fails if the string contains invalid characters.
     */
    public convenience init?(_ name: String) {
        switch Util.toResult(DocumentName_validate(Util.swiftStringToRust(name))) {
        case let .success(name):
            self.init(name)
        case .failure:
            return nil
        }
    }

    /// Name of the document
    public lazy var name: String = {
        Util.rustStringToSwift(DocumentName_getName(inner))
    }()

    deinit { DocumentName_delete(inner) }
}

extension DocumentName: Equatable {
    public static func == (lhs: DocumentName, rhs: DocumentName) -> Bool {
        Util.intToBool(private_DocumentName_rustEq(lhs.inner, rhs.inner))
    }
}

/// The reason a document can be viewed by the requesting user.
public enum DocumentAssociationType {
    init(_ i: UInt32) {
        let associationType = AssociationType(i)
        if associationType == AssociationType_Owner {
            self = .owner
        } else if associationType == AssociationType_FromUser {
            self = .fromUser
        } else if associationType == AssociationType_FromGroup {
            self = .fromGroup
        } else {
            self = .unknown
        }
    }

    /// User created the document.
    case owner
    /// User was directly granted access to the document.
    case fromUser
    /// User was granted access to the document via a group they are a member of.
    case fromGroup
    /// Unknown reason
    case unknown
}

/// Abbreviated document metadata.
public class DocumentListMeta: SdkObject {
    /// ID of the document
    public lazy var id: DocumentId = {
        DocumentId(DocumentListMeta_getId(inner))
    }()

    /// Name of the document
    public lazy var name: DocumentName? = {
        Util.toOption(DocumentListMeta_getName(inner)).map(DocumentName.init)
    }()

    /// How the requesting user has access to the document
    public lazy var associationType: DocumentAssociationType = {
        DocumentAssociationType(DocumentListMeta_getAssociationType(inner))
    }()

    /// Date and time when the document was created
    public lazy var created: Date = {
        Util.timestampToDate(DocumentListMeta_getCreated(inner))
    }()

    /// Date and time when the document was last updated
    public lazy var lastUpdated: Date = {
        Util.timestampToDate(DocumentListMeta_getLastUpdated(inner))
    }()

    deinit { DocumentListMeta_delete(inner) }
}

/// Metadata for each document the current user has access to.
public class DocumentListResult: SdkObject {
    /// Metadata for each document the current user has access to
    public lazy var result: [DocumentListMeta] = {
        Util.collectTo(list: DocumentListResult_getResult(inner), to: DocumentListMeta.init)
    }()

    deinit { DocumentListResult_delete(inner) }
}

/// Full metadata for a document.
public class DocumentMetadataResult: SdkObject {
    /// ID of the document
    public lazy var id: DocumentId = {
        DocumentId(DocumentMetadataResult_getId(inner))
    }()

    /// Name of the document
    public lazy var name: DocumentName? = {
        Util.toOption(DocumentMetadataResult_getName(inner)).map(DocumentName.init)
    }()

    /// How the requesting user has access to the document
    public lazy var associationType: DocumentAssociationType = {
        DocumentAssociationType(DocumentMetadataResult_getAssociationType(inner))
    }()

    /// Date and time when the document was created
    public lazy var created: Date = {
        Util.timestampToDate(DocumentMetadataResult_getCreated(inner))
    }()

    /// Date and time when the document was last updated
    public lazy var lastUpdated: Date = {
        Util.timestampToDate(DocumentMetadataResult_getLastUpdated(inner))
    }()

    /// List of users who have access to the document
    public lazy var visibleToUsers: [UserId] = {
        Util.collectTo(list: DocumentMetadataResult_getVisibleToUsers(inner), to: UserId.init)
    }()

    /// List of groups that have access to the document
    public lazy var visibleToGroups: [GroupId] = {
        Util.collectTo(list: DocumentMetadataResult_getVisibleToGroups(inner), to: GroupId.init)
    }()

    deinit { DocumentMetadataResult_delete(inner) }
}

/// Successful document grants or revocations.
public class SucceededResult: SdkObject {
    /// Users who successfully had their access changed
    public lazy var users: [UserId] = {
        Util.collectTo(list: SucceededResult_getUsers(inner), to: UserId.init)
    }()

    /// Groups that successfully had their access changed
    public lazy var groups: [GroupId] = {
        Util.collectTo(list: SucceededResult_getGroups(inner), to: GroupId.init)
    }()

    deinit { SucceededResult_delete(inner) }
}

/// Failed document grants or revocations.
public class FailedResult: SdkObject {
    /// Users who failed to have their access changed
    public lazy var users: [UserId] = {
        Util.collectTo(list: FailedResult_getUsers(inner), to: UserId.init)
    }()

    /// Groups that failed to have their access changed
    public lazy var groups: [GroupId] = {
        Util.collectTo(list: FailedResult_getGroups(inner), to: GroupId.init)
    }()

    deinit { FailedResult_delete(inner) }
}

/// Encrypted document bytes and metadata.
public class DocumentEncryptResult: SdkObject {
    /// ID of the document
    public lazy var id: DocumentId = {
        DocumentId(DocumentEncryptResult_getId(inner))
    }()

    /// Name of the document
    public lazy var name: DocumentName? = {
        Util.toOption(DocumentEncryptResult_getName(inner)).map(DocumentName.init)
    }()

    /// Date and time when the document was created
    public lazy var created: Date = {
        Util.timestampToDate(DocumentEncryptResult_getCreated(inner))
    }()

    /// Date and time when the document was last updated
    public lazy var lastUpdated: Date = {
        Util.timestampToDate(DocumentEncryptResult_getLastUpdated(inner))
    }()

    /// Users and groups the document was successfully encrypted to
    public lazy var grants: SucceededResult = {
        SucceededResult(DocumentEncryptResult_getChanged(inner))
    }()

    /// Errors resulting from failure to encrypt
    public lazy var accessErrors: FailedResult = {
        FailedResult(DocumentEncryptResult_getErrors(inner))
    }()

    /// Bytes of encrypted document data
    public lazy var encryptedData: [UInt8] = {
        Util.rustVecToBytes(DocumentEncryptResult_getEncryptedData(inner))
    }()

    deinit { DocumentEncryptResult_delete(inner) }
}

/// One dimension of a policy rule
public class Category: SdkObject {
    /// Constructs a `Category` from the given String
    public convenience init?(s: String) {
        switch Util.toResult(Category_validate(Util.swiftStringToRust(s))) {
        case let .success(category):
            self.init(category)
        case .failure:
            return nil
        }
    }

    /// Category of a policy
    public lazy var value: String = {
        Util.rustStringToSwift(Category_getValue(inner))
    }()

    deinit { Category_delete(inner) }
}

/// One dimension of a policy rule
public class Sensitivity: SdkObject {
    /// Constructs a `Sensitivity` from the given String
    public convenience init?(s: String) {
        switch Util.toResult(Sensitivity_validate(Util.swiftStringToRust(s))) {
        case let .success(sensitivity):
            self.init(sensitivity)
        case .failure:
            return nil
        }
    }

    /// Sensitivity of a policy
    public lazy var value: String = {
        Util.rustStringToSwift(Sensitivity_getValue(inner))
    }()

    deinit { Sensitivity_delete(inner) }
}

/// One dimension of a policy rule
public class DataSubject: SdkObject {
    /// Constructs a `DataSubject` from the given String
    public convenience init?(s: String) {
        switch Util.toResult(DataSubject_validate(Util.swiftStringToRust(s))) {
        case let .success(dataSubject):
            self.init(dataSubject)
        case .failure:
            return nil
        }
    }

    /// DataSubject of a policy
    public lazy var value: String = {
        Util.rustStringToSwift(DataSubject_getValue(inner))
    }()

    deinit { DataSubject_delete(inner) }
}

/**
 Document access granted by a policy.

 For use with `SDK.document.encrypt`.

 The triple (`category`, `sensitivity`, `dataSubject`) maps to a single policy rule. Each policy
 rule may generate any number of users/groups.
 */
public class PolicyGrant: SdkObject {
    /**
     Constructs a `PolicyGrant`.

     - parameters:
        - category: Category for the policy
        - sensitivity: Sensitivity for the policy
        - dataSubject: Subject for the policy
        - substituteUser: Replaces `%USER%` in a matched policy rule
     */
    public convenience init?(
        category: Category?,
        sensitivity: Sensitivity?,
        dataSubject: DataSubject?,
        substituteUser: UserId?
    ) {
        self.init(PolicyGrant_create(Util.buildOptionOf(category, CRustClassOptCategory.init),
                                     Util.buildOptionOf(sensitivity, CRustClassOptSensitivity.init),
                                     Util.buildOptionOf(dataSubject, CRustClassOptDataSubject.init),
                                     Util.buildOptionOf(substituteUser, CRustClassOptUserId.init)))
    }

    /// Constructs an empty policy
    public convenience init() {
        self.init(PolicyGrant_default())
    }

    deinit { PolicyGrant_delete(inner) }
}

/**
 Parameters that can be provided when encrypting a new document.

 Document IDs must be unique to the segment. If no ID is provided, one will be generated for it.
 If no name is provided, the document's name will be left empty. Neither the document's ID nor name will
 be encrypted.
 */
public class DocumentEncryptOpts: SdkObject {
    /**
     Constructs a `DocumentEncryptOpts` with common values.

     The document will have a generated ID and no name. Only the document's author will be able to
     read and decrypt it.
     */
    public convenience init() {
        self.init(DocumentEncryptOpts_default())
    }

    /**
     Constructs a `DocumentEncryptOpts`.

     - parameters:
         - id: ID to use for the document.
         - documentName: Name to use for the document.
         - grantToAuthor: `true` if the calling user should have access to decrypt this document
         - userGrants: List of users that should have access to read and decrypt this document
         - groupGrants: List of groups that should have access to read and decrypt this document
         - policyGrant: Policy to determine which users and groups will have access to read and decrypt this document.
     */
    public convenience init(
        id: DocumentId?,
        documentName: DocumentName?,
        grantToAuthor: Bool,
        userGrants: [UserId],
        groupGrants: [GroupId],
        policyGrant: PolicyGrant?
    ) {
        self.init(RustObjects(array: userGrants, fn: UserId_getId).withSlice { userSlice in
            RustObjects(array: groupGrants, fn: GroupId_getId).withSlice { groupSlice in
                DocumentEncryptOpts_create(Util.buildOptionOf(id, CRustClassOptDocumentId.init),
                                           Util.buildOptionOf(documentName, CRustClassOptDocumentName.init),
                                           Util.boolToInt(grantToAuthor),
                                           userSlice,
                                           groupSlice,
                                           Util.buildOptionOf(policyGrant, CRustClassOptPolicyGrant.init))
            }
        })
    }

    deinit { DocumentEncryptOpts_delete(inner) }
}

/// Decrypted document bytes and metadata.
public class DocumentDecryptResult: SdkObject {
    /// ID of the document
    public lazy var id: DocumentId = {
        DocumentId(DocumentDecryptResult_getId(inner))
    }()

    /// Name of the document
    public lazy var name: DocumentName? = {
        Util.toOption(DocumentDecryptResult_getName(inner)).map(DocumentName.init)
    }()

    /// Bytes of decrypted document data
    public lazy var decryptedData: [UInt8] = {
        Util.rustVecToBytes(DocumentDecryptResult_getDecryptedData(inner))
    }()

    /// Date and time when the document was created
    public lazy var created: Date = {
        Util.timestampToDate(DocumentDecryptResult_getCreated(inner))
    }()

    /// Date and time when the document was last updated
    public lazy var lastUpdated: Date = {
        Util.timestampToDate(DocumentDecryptResult_getLastUpdated(inner))
    }()

    deinit { DocumentDecryptResult_delete(inner) }
}

/**
 Encrypted document bytes and metadata.

 Unmanaged encryption does not store document access information with the webservice,
 but rather returns the access information as `encryptedDeks`. Both the `encryptedData` and
 `encryptedDeks` must be used to decrypt the document.
 */
public class DocumentEncryptUnmanagedResult: SdkObject {
    /// ID of the document
    public lazy var id: DocumentId = {
        DocumentId(DocumentEncryptUnmanagedResult_getId(inner))
    }()

    /// Bytes of EDEKs of users/groups that have been granted access to `encryptedData`
    public lazy var encryptedDeks: [UInt8] = {
        Util.rustVecToBytes(DocumentEncryptUnmanagedResult_getEncryptedDeks(inner))
    }()

    /// Users and groups the document was successfully encrypted to
    public lazy var changed: SucceededResult = {
        SucceededResult(DocumentEncryptUnmanagedResult_getChanged(inner))
    }()

    /// Errors resulting from failure to encrypt
    public lazy var errors: FailedResult = {
        FailedResult(DocumentEncryptUnmanagedResult_getErrors(inner))
    }()

    /// Bytes of encrypted document data
    public lazy var encryptedData: [UInt8] = {
        Util.rustVecToBytes(DocumentEncryptUnmanagedResult_getEncryptedData(inner))
    }()

    deinit { DocumentEncryptUnmanagedResult_delete(inner) }
}

/// Decrypted document bytes and metadata.
public class DocumentDecryptUnmanagedResult: SdkObject {
    /// ID of the document
    public lazy var id: DocumentId = {
        DocumentId(DocumentDecryptUnmanagedResult_getId(inner))
    }()

    /// Bytes of decrypted document data
    public lazy var decryptedData: [UInt8] = {
        Util.rustVecToBytes(DocumentDecryptUnmanagedResult_getDecryptedData(inner))
    }()

    /**
     User or group that granted access to the encrypted data

     More specifically, the user or group associated with the EDEK that was chosen and transformed by the webservice.
     */
    public lazy var accessVia: UserOrGroupId = {
        UserOrGroupId(DocumentDecryptUnmanagedResult_getAccessViaUserOrGroup(inner))
    }()

    deinit { DocumentDecryptUnmanagedResult_delete(inner) }
}

/**
 Successful and failed changes to a document's access list.

 Both grant and revoke support partial success.
 */
public class DocumentAccessResult: SdkObject {
    /// Users and groups whose access was successfully changed.
    public lazy var changed: SucceededResult = {
        SucceededResult(DocumentAccessResult_getChanged(inner))
    }()

    /// Users and groups whose access failed to be changed.
    public lazy var errors: FailedResult = {
        FailedResult(DocumentAccessResult_getErrors(inner))
    }()

    deinit { DocumentAccessResult_delete(inner) }
}

/**
 IronOxide Advanced Document Operations

 # Key Terms
 - EDEKs - Encrypted document encryption keys produced by unmanaged document encryption and required for unmanaged
      document decryption.
 */
public struct AdvancedDocumentOperations {
    let ironoxide: OpaquePointer
    init(_ instance: OpaquePointer) {
        ironoxide = instance
    }

    /**
     Encrypts the provided document bytes without being managed by the IronCore service.

     The webservice is still needed for looking up public keys and evaluating policies, but no
     document is created and the EDEKs are not stored. An additional burden is put on the caller
     in that both the encrypted data and the EDEKs must be provided for decryption.

     - parameters:
         - bytes: Bytes of the document to encrypt
         - options: Document encryption parameters
     */
    public func encryptUnmanaged(
        bytes: [UInt8],
        options: DocumentEncryptOpts = DocumentEncryptOpts()
    ) -> Result<DocumentEncryptUnmanagedResult, IronOxideError> {
        Util.toResult(RustBytes(bytes).withSlice { rustSlice in
            IronOxide_advancedDocumentEncryptUnmanaged(ironoxide, rustSlice, options.inner)
        }).map(DocumentEncryptUnmanagedResult.init)
    }

    /**
     Decrypts a document not managed by the IronCore service.

     Requires the encrypted data and EDEKs returned from `encryptUnmanaged`.

     The webservice is still needed to transform a chosen EDEK so it can be decrypted by the caller's private key.

     - parameters:
        - encryptedBytes: Bytes of the encrypted document
        - encryptedDeks: EDEKs associated with the encrypted document
     */
    public func decryptUnmanaged(encryptedBytes: [UInt8], encryptedDeks: [UInt8]) -> Result<DocumentDecryptUnmanagedResult, IronOxideError> {
        Util.toResult(RustBytes(encryptedBytes).withSlice { bytesSlice in
            RustBytes(encryptedDeks).withSlice { deksSlice in
                IronOxide_advancedDocumentDecryptUnmanaged(ironoxide, bytesSlice, deksSlice)
            }
        }).map(DocumentDecryptUnmanagedResult.init)
    }
}

/**
 IronOxide Document Operations

 # Key Terms
 - ID     - The ID representing a document. It must be unique within the document's segment and will **not** be encrypted.
 - Name   - The human-readable name of a document. It does not need to be unique and will **not** be encrypted.
 */
public struct DocumentOperations {
    let ironoxide: OpaquePointer
    let advanced: AdvancedDocumentOperations

    init(_ instance: OpaquePointer) {
        ironoxide = instance
        advanced = AdvancedDocumentOperations(ironoxide)
    }

    /// Lists metadata for all of the encrypted documents that the calling user can read or decrypt.
    public func list() -> Result<DocumentListResult, IronOxideError> {
        Util.toResult(IronOxide_documentList(ironoxide)).map(DocumentListResult.init)
    }

    /**
     Returns the metadata for an encrypted document.

     This will not return the encrypted document bytes, as they are not stored by IronCore.

     - parameter documentId: ID of the document to retrieve
     */
    public func getMetadata(documentId: DocumentId) -> Result<DocumentMetadataResult, IronOxideError> {
        Util.toResult(IronOxide_documentGetMetadata(ironoxide, documentId.inner)).map(DocumentMetadataResult.init)
    }

    /**
     Returns the document ID from the bytes of an encrypted document.

     This is the same ID returned by `DocumentEncryptResult.id`.

     Fails if the provided bytes are not an encrypted document or have no header.

     - parameter bytes: Bytes of the encrypted document
     */
    public func getIdFromBytes(bytes: [UInt8]) -> Result<DocumentId, IronOxideError> {
        Util.toResult(RustBytes(bytes).withSlice { rustSlice in IronOxide_documentGetIdFromBytes(ironoxide, rustSlice) })
            .map(DocumentId.init)
    }

    /**
     Encrypts the provided document bytes.

     Returns a `DocumentEncryptResult` which contains document metadata as well as the `encryptedData`,
     which is the only thing that must be passed to `SDK.document.decrypt` in order to decrypt the document.

     Metadata about the document will be stored by IronCore, but the encrypted bytes of the document will not. To encrypt
     without any document information being stored by IronCore, consider using `SDK.document.advanced.encryptUnmanaged` instead.

     - parameters:
        - bytes: Bytes of the document to encrypt
        - options: Document encryption parameters
     */
    public func encrypt(bytes: [UInt8], options: DocumentEncryptOpts = DocumentEncryptOpts()) -> Result<DocumentEncryptResult, IronOxideError> {
        Util.toResult(RustBytes(bytes).withSlice { rustSlice in IronOxide_documentEncrypt(ironoxide, rustSlice, options.inner) })
            .map(DocumentEncryptResult.init)
    }

    /**
     Updates the contents of an existing IronCore encrypted document.

     The new contents will be encrypted, and which users and groups are granted access
     will remain unchanged.

     - parameters:
        - documentId: ID of the document to update
        - newBytes: New document bytes to encrypt
     */
    public func updateBytes(documentId: DocumentId, newBytes: [UInt8]) -> Result<DocumentEncryptResult, IronOxideError> {
        Util.toResult(RustBytes(newBytes).withSlice { rustSlice in IronOxide_documentUpdateBytes(ironoxide, documentId.inner, rustSlice) })
            .map(DocumentEncryptResult.init)
    }

    /**
     Decrypts an IronCore encrypted document.

     Requires the encrypted data returned from `SDK.document.encrypt`.

     Returns details about the document as well as its decrypted bytes.

     Fails if passed malformed data or if the calling user does not have sufficient access to the document.

     - parameter encryptedBytes: Bytes of the encrypted document
     */
    public func decrypt(encryptedBytes: [UInt8]) -> Result<DocumentDecryptResult, IronOxideError> {
        Util.toResult(RustBytes(encryptedBytes).withSlice { rustSlice in IronOxide_documentDecrypt(ironoxide, rustSlice) })
            .map(DocumentDecryptResult.init)
    }

    /**
     Modifies or removes a document's name.

     Returns the updated metadata of the document.

     - parameters:
        - documentId: ID of the document to update
        - newName: New name for the document. Provide a `DocumentName` to update to a new name or `nil` to clear the name field.
     */
    public func updateName(documentId: DocumentId, newName: DocumentName?) -> Result<DocumentMetadataResult, IronOxideError> {
        Util.toResult(IronOxide_documentUpdateName(ironoxide, documentId.inner, Util.buildOptionOf(newName, CRustClassOptDocumentName.init)))
            .map(DocumentMetadataResult.init)
    }

    /**
     Grants decryption access to a document for the provided users and/or groups.

     Returns lists of successful and failed grants.

     This operation supports partial success. If the request succeeds, then the resulting
     `DocumentAccessResult` will indicate which grants succeeded and which failed, and it
     will provide an explanation for each failure.

     - parameters:
       - documentId: ID of the document whose access is being modified.
       - users: List of users to grant access to.
       - groups: List of groups to grant access to.
     */
    public func grantAccess(documentId: DocumentId, users: [UserId], groups: [GroupId]) -> Result<DocumentAccessResult, IronOxideError> {
        modifyAccess(documentId, users, groups, IronOxide_documentGrantAccess)
    }

    /**
     Revokes decryption access to a document for the provided users and/or groups.

     Returns lists of successful and failed revocations.

     This operation supports partial success. If the request succeeds, then the resulting
     `DocumentAccessResult` will indicate which revocations succeeded and which failed, and it
     will provide an explanation for each failure.

     - parameters:
        - documentId: ID of the document whose access is being modified.
        - users: List of users to revoke access from.
        - groups: List of groups to revoke access from.
     */
    public func revokeAccess(documentId: DocumentId, users: [UserId], groups: [GroupId]) -> Result<DocumentAccessResult, IronOxideError> {
        modifyAccess(documentId, users, groups, IronOxide_documentRevokeAccess)
    }

    /**
     Helper function to reduce copy/paste in `grantAccess` and `revokeAccess`. Takes the function's documentId, users, groups, and
     IronOxide C function to call with the parameters (should only be IronOxide_documentGrantAccess or IronOxide_documentRevokeAccess).
     */
    func modifyAccess(
        _ documentId: DocumentId,
        _ users: [UserId],
        _ groups: [GroupId],
        _ fn: (OpaquePointer, OpaquePointer, CRustObjectSlice, CRustObjectSlice) -> CRustResult4232mut3232c_voidCRustString
    ) -> Result<DocumentAccessResult, IronOxideError> {
        Util.toResult(RustObjects(array: users, fn: UserId_getId).withSlice { userSlice in
            RustObjects(array: groups, fn: GroupId_getId).withSlice { groupSlice in
                fn(ironoxide, documentId.inner, userSlice, groupSlice)
            }
            }).map(DocumentAccessResult.init)
    }
}
