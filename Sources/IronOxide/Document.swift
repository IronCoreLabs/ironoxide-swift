import Foundation
import libironoxide

public class DocumentName: SdkObject {
    public convenience init?(_ name: String) {
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

public class DocumentId: SdkObject {
    /**
     * Create a new DocumentId from the provided String. Will fail if the document ID is not valid.
     */
    public convenience init?(_ id: String) {
        switch Util.toResult(DocumentId_validate(Util.swiftStringToRust(id))) {
        case let .success(deviceId):
            self.init(deviceId)
        case .failure:
            return nil
        }
    }

    public lazy var id: String = {
        Util.rustStringToSwift(DocumentId_getId(inner))
    }()

    deinit { DocumentId_delete(inner) }
}

public class DocumentAssociationType {
    let inner: UInt32

    init(_ res: UInt32) {
        inner = res
    }
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

    deinit { PolicyGrant_delete(inner) }
}

public class DocumentEncryptOpts: SdkObject {
    public convenience init?(
        id: DocumentId,
        documentName: DocumentName,
        grantToAuthor: Bool,
        userGrants: [UserId],
        groupGrants: [GroupId],
        policyGrant: PolicyGrant?
    ) {
        self.init(DocumentEncryptOpts_create(Util.buildOptionOf(id, CRustClassOptDocumentId.init),
                                             Util.buildOptionOf(documentName, CRustClassOptDocumentName.init),
                                             Util.boolToInt(grantToAuthor),
                                             Util.arrayToRustSlice(array: userGrants, fn: UserId_getId),
                                             Util.arrayToRustSlice(array: groupGrants, fn: GroupId_getId),
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
        Util.toBytes(DocumentDecryptResult_getDecryptedData(inner))
    }()

    public lazy var created: Date = {
        Util.timestampToDate(DocumentDecryptResult_getCreated(inner))
    }()

    public lazy var lastUpdated: Date = {
        Util.timestampToDate(DocumentDecryptResult_getLastUpdated(inner))
    }()

    deinit { DocumentDecryptResult_delete(inner) }
}

public class DocumentAccessResult: SdkObject {
    deinit { DocumentAccessResult_delete(inner) }
}

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

    public func list() -> Result<DocumentListResult, IronOxideError> {
        Util.toResult(IronOxide_documentList(ironoxide)).map(DocumentListResult.init)
    }

    public func getMetadata(documentId: DocumentId) -> Result<DocumentMetadataResult, IronOxideError> {
        Util.toResult(IronOxide_documentGetMetadata(ironoxide, documentId.inner)).map(DocumentMetadataResult.init)
    }

    public func getIdFromBytes(bytes: [UInt8]) -> Result<DocumentId, IronOxideError> {
        Util.toResult(IronOxide_documentGetIdFromBytes(ironoxide, Util.bytesToSlice(bytes))).map(DocumentId.init)
    }

    public func encrypt(bytes: [UInt8], options: DocumentEncryptOpts) -> Result<DocumentEncryptResult, IronOxideError> {
        Util.toResult(IronOxide_documentEncrypt(ironoxide, Util.bytesToSlice(bytes), options.inner)).map(DocumentEncryptResult.init)
    }

    public func updateBytes(documentId: DocumentId, newBytes: [UInt8]) -> Result<DocumentEncryptResult, IronOxideError> {
        Util.toResult(IronOxide_documentUpdateBytes(ironoxide, documentId.inner, Util.bytesToSlice(newBytes))).map(DocumentEncryptResult.init)
    }

    public func decrypt(encryptedBytes: [UInt8]) -> Result<DocumentDecryptResult, IronOxideError> {
        Util.toResult(IronOxide_documentDecrypt(ironoxide, Util.bytesToSlice(encryptedBytes))).map(DocumentDecryptResult.init)
    }

    public func updateName(documentId: DocumentId, newName: DocumentName?) -> Result<DocumentMetadataResult, IronOxideError> {
        Util.toResult(IronOxide_documentUpdateName(ironoxide, documentId.inner, Util.buildOptionOf(newName, CRustClassOptDocumentName.init)))
            .map(DocumentMetadataResult.init)
    }

    public func grantAccess(documentId: DocumentId, users: [UserId], groups: [GroupId]) -> Result<DocumentAccessResult, IronOxideError> {
        Util.toResult(IronOxide_documentGrantAccess(ironoxide, documentId.inner,
                                                    Util.arrayToRustSlice(array: users, fn: UserId_getId),
                                                    Util.arrayToRustSlice(array: groups, fn: GroupId_getId))).map(DocumentAccessResult.init)
    }

    public func revokeAccess(documentId: DocumentId, users: [UserId], groups: [GroupId]) -> Result<DocumentAccessResult, IronOxideError> {
        Util.toResult(IronOxide_documentRevokeAccess(ironoxide, documentId.inner,
                                                     Util.arrayToRustSlice(array: users, fn: UserId_getId),
                                                     Util.arrayToRustSlice(array: groups, fn: GroupId_getId))).map(DocumentAccessResult.init)
    }
}
