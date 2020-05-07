import Foundation
import libironoxide
// Name of a document (Note that this is unencrypted).
public class DocumentName: SdkObject {
    public convenience init?(name: String) {
        switch Util.toResult(DocumentName_validate(Util.swiftStringToRust(name))) {
        case let .success(name):
            self.init(name)
        case .failure:
            return nil
        }
    }

    public lazy var name: String = {
        Util.rustStringToSwift(DocumentName_getName(inner))
    }()

    deinit { DocumentName_delete(inner) }
}

public enum DocumentAssociationType {
    init(_ i: UInt32) {
        let associationType = AssociationType(i)
        if associationType == Owner {
            self = .owner
        } else if associationType == FromUser {
            self = .fromUser
        } else if associationType == FromGroup {
            self = .fromGroup
        } else {
            self = .unknown
        }
    }

    case owner
    case fromUser
    case fromGroup
    case unknown
}

/**
 * Metadata about a document.
 */
public class DocumentListMeta: SdkObject {
    public lazy var id: DocumentId = {
        DocumentId(DocumentListMeta_getId(inner))
    }()

    public lazy var name: DocumentName? = {
        Util.toOption(DocumentListMeta_getName(inner)).map(DocumentName.init)
    }()

    public lazy var associationType: DocumentAssociationType = {
        DocumentAssociationType(DocumentListMeta_getAssociationType(inner))
    }()

    public lazy var created: Date = {
        Util.timestampToDate(DocumentListMeta_getCreated(inner))
    }()

    public lazy var lastUpdated: Date = {
        Util.timestampToDate(DocumentListMeta_getLastUpdated(inner))
    }()

    deinit { DocumentListMeta_delete(inner) }
}

/**
 * Documents for a user.
 */
public class DocumentListResult: SdkObject {
    public lazy var result: [DocumentListMeta] = {
        Util.collectTo(list: DocumentListResult_getResult(inner), to: DocumentListMeta.init)
    }()

    deinit { DocumentListResult_delete(inner) }
}

public class DocumentMetadataResult: SdkObject {
    public lazy var id: DocumentId = {
        DocumentId(DocumentMetadataResult_getId(inner))
    }()

    public lazy var name: DocumentName? = {
        Util.toOption(DocumentMetadataResult_getName(inner)).map(DocumentName.init)
    }()

    public lazy var associationType: DocumentAssociationType = {
        DocumentAssociationType(DocumentMetadataResult_getAssociationType(inner))
    }()

    public lazy var created: Date = {
        Util.timestampToDate(DocumentMetadataResult_getCreated(inner))
    }()

    public lazy var lastUpdated: Date = {
        Util.timestampToDate(DocumentMetadataResult_getLastUpdated(inner))
    }()

    public lazy var visibleToUsers: [UserId] = {
        Util.collectTo(list: DocumentMetadataResult_getVisibleToUsers(inner), to: UserId.init)
    }()

    public lazy var visibleToGroups: [GroupId] = {
        Util.collectTo(list: DocumentMetadataResult_getVisibleToGroups(inner), to: GroupId.init)
    }()

    deinit { DocumentMetadataResult_delete(inner) }
}

public class SucceededResult: SdkObject {
    public lazy var users: [UserId] = {
        Util.collectTo(list: SucceededResult_getUsers(inner), to: UserId.init)
    }()

    public lazy var groups: [GroupId] = {
        Util.collectTo(list: SucceededResult_getGroups(inner), to: GroupId.init)
    }()

    deinit { SucceededResult_delete(inner) }
}

public class FailedResult: SdkObject {
    public lazy var users: [UserId] = {
        Util.collectTo(list: FailedResult_getUsers(inner), to: UserId.init)
    }()

    public lazy var groups: [GroupId] = {
        Util.collectTo(list: FailedResult_getGroups(inner), to: GroupId.init)
    }()

    deinit { FailedResult_delete(inner) }
}

public class DocumentEncryptResult: SdkObject {
    public lazy var id: DocumentId = {
        DocumentId(DocumentEncryptResult_getId(inner))
    }()

    public lazy var name: DocumentName? = {
        Util.toOption(DocumentEncryptResult_getName(inner)).map(DocumentName.init)
    }()

    public lazy var created: Date = {
        Util.timestampToDate(DocumentEncryptResult_getCreated(inner))
    }()

    public lazy var lastUpdated: Date = {
        Util.timestampToDate(DocumentEncryptResult_getLastUpdated(inner))
    }()

    public lazy var changed: SucceededResult = {
        SucceededResult(DocumentEncryptResult_getChanged(inner))
    }()

    public lazy var errors: FailedResult = {
        FailedResult(DocumentEncryptResult_getErrors(inner))
    }()

    public lazy var encryptedData: [UInt8] = {
        Util.rustVecToBytes(DocumentEncryptResult_getEncryptedData(inner))
    }()

    deinit { DocumentEncryptResult_delete(inner) }
}

public class Category: SdkObject {
    public convenience init?(s: String) {
        switch Util.toResult(Category_validate(Util.swiftStringToRust(s))) {
        case let .success(category):
            self.init(category)
        case .failure:
            return nil
        }
    }

    public lazy var value: String = {
        Util.rustStringToSwift(Category_getValue(inner))
    }()

    deinit { Category_delete(inner) }
}

public class Sensitivity: SdkObject {
    public convenience init?(s: String) {
        switch Util.toResult(Sensitivity_validate(Util.swiftStringToRust(s))) {
        case let .success(sensitivity):
            self.init(sensitivity)
        case .failure:
            return nil
        }
    }

    public lazy var value: String = {
        Util.rustStringToSwift(Sensitivity_getValue(inner))
    }()

    deinit { Sensitivity_delete(inner) }
}

public class DataSubject: SdkObject {
    public convenience init?(s: String) {
        switch Util.toResult(DataSubject_validate(Util.swiftStringToRust(s))) {
        case let .success(dataSubject):
            self.init(dataSubject)
        case .failure:
            return nil
        }
    }

    public lazy var value: String = {
        Util.rustStringToSwift(DataSubject_getValue(inner))
    }()

    deinit { DataSubject_delete(inner) }
}

public class PolicyGrant: SdkObject {
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

    public convenience init() {
        self.init(PolicyGrant_default())
    }

    deinit { PolicyGrant_delete(inner) }
}

public class DocumentEncryptOpts: SdkObject {
    public convenience init() {
        self.init(DocumentEncryptOpts_default())
    }

    public convenience init(
        id: DocumentId?,
        documentName: DocumentName?,
        grantToAuthor: Bool,
        userGrants: [UserId],
        groupGrants: [GroupId],
        policyGrant: PolicyGrant?
    ) {
        self.init(DocumentEncryptOpts_create(Util.buildOptionOf(id, CRustClassOptDocumentId.init),
                                             Util.buildOptionOf(documentName, CRustClassOptDocumentName.init),
                                             Util.boolToInt(grantToAuthor),
                                             RustObjects(array: userGrants, fn: UserId_getId).slice,
                                             RustObjects(array: groupGrants, fn: GroupId_getId).slice,
                                             Util.buildOptionOf(policyGrant, CRustClassOptPolicyGrant.init)))
    }

    deinit { DocumentEncryptOpts_delete(inner) }
}

public class DocumentDecryptResult: SdkObject {
    public lazy var id: DocumentId = {
        DocumentId(DocumentDecryptResult_getId(inner))
    }()

    public lazy var name: DocumentName? = {
        Util.toOption(DocumentDecryptResult_getName(inner)).map(DocumentName.init)
    }()

    public lazy var decryptedData: [UInt8] = {
        Util.rustVecToBytes(DocumentDecryptResult_getDecryptedData(inner))
    }()

    public lazy var created: Date = {
        Util.timestampToDate(DocumentDecryptResult_getCreated(inner))
    }()

    public lazy var lastUpdated: Date = {
        Util.timestampToDate(DocumentDecryptResult_getLastUpdated(inner))
    }()

    deinit { DocumentDecryptResult_delete(inner) }
}

public class DocumentEncryptUnmanagedResult: SdkObject {
    public lazy var id: DocumentId = {
        DocumentId(DocumentEncryptUnmanagedResult_getId(inner))
    }()

    public lazy var encryptedDeks: [UInt8] = {
        Util.rustVecToBytes(DocumentEncryptUnmanagedResult_getEncryptedDeks(inner))
    }()

    public lazy var changed: SucceededResult = {
        SucceededResult(DocumentEncryptUnmanagedResult_getChanged(inner))
    }()

    public lazy var errors: FailedResult = {
        FailedResult(DocumentEncryptUnmanagedResult_getErrors(inner))
    }()

    public lazy var encryptedData: [UInt8] = {
        Util.rustVecToBytes(DocumentEncryptUnmanagedResult_getEncryptedData(inner))
    }()

    deinit { DocumentEncryptUnmanagedResult_delete(inner) }
}

public class DocumentDecryptUnmanagedResult: SdkObject {
    public lazy var id: DocumentId = {
        DocumentId(DocumentDecryptUnmanagedResult_getId(inner))
    }()

    public lazy var decryptedData: [UInt8] = {
        Util.rustVecToBytes(DocumentDecryptUnmanagedResult_getDecryptedData(inner))
    }()

    public lazy var accessVia: UserOrGroupId = {
        UserOrGroupId(DocumentDecryptUnmanagedResult_getAccessViaUserOrGroup(inner))
    }()

    deinit { DocumentDecryptUnmanagedResult_delete(inner) }
}

public class DocumentAccessResult: SdkObject {
    public lazy var changed: SucceededResult = {
        SucceededResult(DocumentAccessResult_getChanged(inner))
    }()

    public lazy var errors: FailedResult = {
        FailedResult(DocumentAccessResult_getErrors(inner))
    }()

    deinit { DocumentAccessResult_delete(inner) }
}

public struct AdvancedDocumentOperations {
    let ironoxide: OpaquePointer
    init(_ instance: OpaquePointer) {
        ironoxide = instance
    }

    public func encryptUnmanaged(bytes: [UInt8],
                                 options: DocumentEncryptOpts = DocumentEncryptOpts()) -> Result<DocumentEncryptUnmanagedResult, IronOxideError> {
        Util.toResult(IronOxide_advancedDocumentEncryptUnmanaged(ironoxide, RustBytes(bytes).slice, options.inner)).map(DocumentEncryptUnmanagedResult.init)
    }

    public func decryptUnmanaged(encryptedBytes: [UInt8], encryptedDeks: [UInt8]) -> Result<DocumentDecryptUnmanagedResult, IronOxideError> {
        Util.toResult(IronOxide_advancedDocumentDecryptUnmanaged(ironoxide, RustBytes(encryptedBytes).slice, RustBytes(encryptedDeks).slice))
            .map(DocumentDecryptUnmanagedResult.init)
    }
}

public struct DocumentOperations {
    let ironoxide: OpaquePointer
    let advanced: AdvancedDocumentOperations

    init(_ instance: OpaquePointer) {
        ironoxide = instance
        advanced = AdvancedDocumentOperations(ironoxide)
    }

    public func list() -> Result<DocumentListResult, IronOxideError> {
        Util.toResult(IronOxide_documentList(ironoxide)).map(DocumentListResult.init)
    }

    public func getMetadata(documentId: DocumentId) -> Result<DocumentMetadataResult, IronOxideError> {
        Util.toResult(IronOxide_documentGetMetadata(ironoxide, documentId.inner)).map(DocumentMetadataResult.init)
    }

    public func getIdFromBytes(bytes: [UInt8]) -> Result<DocumentId, IronOxideError> {
        Util.toResult(IronOxide_documentGetIdFromBytes(ironoxide, RustBytes(bytes).slice)).map(DocumentId.init)
    }

    public func encrypt(bytes: [UInt8], options: DocumentEncryptOpts = DocumentEncryptOpts()) -> Result<DocumentEncryptResult, IronOxideError> {
        Util.toResult(RustBytes(bytes).withSlice { rustSlice in IronOxide_documentEncrypt(ironoxide, rustSlice, options.inner) })
            .map(DocumentEncryptResult.init)
        // Util.toResult(IronOxide_documentEncrypt(ironoxide, RustBytes(bytes).slice, options.inner)).map(DocumentEncryptResult.init)
    }

    public func updateBytes(documentId: DocumentId, newBytes: [UInt8]) -> Result<DocumentEncryptResult, IronOxideError> {
        Util.toResult(RustBytes(newBytes).withSlice { rustSlice in IronOxide_documentUpdateBytes(ironoxide, documentId.inner, rustSlice) })
            .map(DocumentEncryptResult.init)
        // Util.toResult(IronOxide_documentUpdateBytes(ironoxide, documentId.inner, RustBytes(newBytes).slice)).map(DocumentEncryptResult.init)
    }

    public func decrypt(encryptedBytes: [UInt8]) -> Result<DocumentDecryptResult, IronOxideError> {
        Util.toResult(RustBytes(encryptedBytes).withSlice { rustSlice in IronOxide_documentDecrypt(ironoxide, rustSlice) })
            .map(DocumentDecryptResult.init)
        // Util.toResult(IronOxide_documentDecrypt(ironoxide, RustBytes(encryptedBytes).slice)).map(DocumentDecryptResult.init)
    }

    public func updateName(documentId: DocumentId, newName: DocumentName?) -> Result<DocumentMetadataResult, IronOxideError> {
        Util.toResult(IronOxide_documentUpdateName(ironoxide, documentId.inner, Util.buildOptionOf(newName, CRustClassOptDocumentName.init)))
            .map(DocumentMetadataResult.init)
    }

    public func grantAccess(documentId: DocumentId, users: [UserId], groups: [GroupId]) -> Result<DocumentAccessResult, IronOxideError> {
        // Util.toResult(IronOxide_documentGrantAccess(ironoxide, documentId.inner,
        //                                             RustObjects(array: users, fn: UserId_getId).slice,
        //                                             RustObjects(array: groups, fn: GroupId_getId).slice)).map(DocumentAccessResult.init)
        // Util.toResult(RustObjects(array: users, fn: UserId_getId).withSlice { userSlice in
        //     RustObjects(array: groups, fn: GroupId_getId).withSlice { groupSlice in
        //         IronOxide_documentGrantAccess(ironoxide, documentId.inner, userSlice, groupSlice)
        //     }
        //     }).map(DocumentAccessResult.init)
        modifyAccess(documentId, users, groups, IronOxide_documentGrantAccess)
    }

    public func revokeAccess(documentId: DocumentId, users: [UserId], groups: [GroupId]) -> Result<DocumentAccessResult, IronOxideError> {
        // Util.toResult(IronOxide_documentRevokeAccess(ironoxide, documentId.inner,
        //                                              RustObjects(array: users, fn: UserId_getId).slice,
        //                                              RustObjects(array: groups, fn: GroupId_getId).slice)).map(DocumentAccessResult.init)
        // Util.toResult(RustObjects(array: users, fn: UserId_getId).withSlice { userSlice in
        //     RustObjects(array: groups, fn: GroupId_getId).withSlice { groupSlice in
        //         IronOxide_documentRevokeAccess(ironoxide, documentId.inner, userSlice, groupSlice)
        //     }
        //     }).map(DocumentAccessResult.init)
        modifyAccess(documentId, users, groups, IronOxide_documentRevokeAccess)
    }

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
