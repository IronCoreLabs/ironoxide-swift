//
//  SDK.swift
//  ironoxide-swift
//
//  Created by Ernie Turner on 4/7/20.
//  Copyright © 2020 Ernie Turner. All rights reserved.
//

import Foundation

enum IronOxideError: Error {
    case runtimeError(String)
}

func getDocumentAssociation(_ associationId: UInt32) -> String {
    let docAssoc = AssociationType.init(associationId)
    if(docAssoc == FromGroup){
        return "From Group"
    }
    else if(docAssoc == Owner){
        return "Owner"
    }
    else if(docAssoc == FromUser){
        return "From User"
    }
    return "No Association?"
}

func printGroupInfo(_ group: OpaquePointer?) {
    let maybeName = GroupMetaResult_getName(group)
    if(maybeName.is_some == 1){
        let nameStruct = OpaquePointer(maybeName.val.data)
        print(Util.mapRustString(rustStr: GroupName_getName(nameStruct), fallbackError: "No group name"))
    }
    else{
        print("[No Name Group]")
    }
    let isAdmin = UInt8(GroupMetaResult_isAdmin(group))
    let isMember = UInt8(GroupMetaResult_isMember(group))
    let groupIdStruct = GroupMetaResult_getId(group)
    let id = GroupId_getId(groupIdStruct)
    print("   ID: \(Util.mapRustString(rustStr: id, fallbackError: "Could not get group ID"))")
    print("   isAdmin: \(isAdmin)")
    print("   isMember: \(isMember)")
    print("   Created: \(GroupMetaResult_getCreated(group))")
    print("   Updated: \(GroupMetaResult_getLastUpdated(group))")
}

func printDocInfo(_ doc: OpaquePointer?){
    let maybeName = DocumentListMeta_getName(doc)
    if(maybeName.is_some == 1){
        let nameStruct = OpaquePointer(maybeName.val.data)
        print(Util.mapRustString(rustStr: DocumentName_getName(nameStruct), fallbackError: "No document name"))
    }
    else{
        print("[No Doc Name]")
    }
    let docIdStruct = DocumentListMeta_getId(doc)
    let id = DocumentId_getId(docIdStruct)
    print("   ID: \(Util.mapRustString(rustStr: id, fallbackError: "Could not get document ID"))")
    print("   Association: \(getDocumentAssociation(DocumentListMeta_getAssociationType(doc)))")
    print("   Created: \(DocumentListMeta_getCreated(doc))")
    print("   Updated: \(DocumentListMeta_getLastUpdated(doc))")
}


class SDK {
    static func initializeWithJson(_ json: String) -> Result<OpaquePointer, IronOxideError> {
        return Util.mapRustResult(rustRes: DeviceContext_fromJsonString(Util.makeRustString(json)), fallbackError: "Unknown device context create failure")
            .flatMap({(device) in
                Util.mapRustResult(rustRes: IronOxide_initialize(device, IronOxideConfig_default()), fallbackError: "Unknown init failure")
            })
    }
    
    static func groupList(_ ironoxide: OpaquePointer) -> Result<Void, IronOxideError> {
        Util.printWithTime("======GROUP LIST======")
        return Util.mapRustResult(rustRes: IronOxide_groupList(ironoxide), fallbackError: "Group list failed for some reason")
            .map({(groupResult) in
                var groupListVec = GroupListResult_getResult(groupResult)
                print("Number of groups: \(groupListVec.len)")
                for _ in 0..<groupListVec.len {
                    print("in loop?")
                    printGroupInfo(OpaquePointer(groupListVec.data))
                    groupListVec.data = groupListVec.data + UnsafeMutableRawPointer.Stride(groupListVec.step)
                }
            })
    }
    
    static func groupGet(ironoxide: OpaquePointer, groupId: String) -> Result<Void, IronOxideError> {
        Util.printWithTime("======GROUP GET======")
        return IdType.groupId(groupId)
            .flatMap({(groupId) in
                Util.mapRustResult(rustRes: IronOxide_groupGetMetadata(ironoxide, groupId), fallbackError: "Group Get failed for some reason")
            })
            .map({(groupMetaResult) in
                let maybeGroupName = GroupGetResult_getName(groupMetaResult)
                if(maybeGroupName.is_some == 1){
                    let nameStruct = OpaquePointer(maybeGroupName.val.data)
                    print(Util.mapRustString(rustStr: GroupName_getName(nameStruct), fallbackError: "No group name"))
                }
                else {
                    print("Name: {No Name}")
                }
                print("Is Admin: \(GroupGetResult_isAdmin(groupMetaResult))")
                print("Is Member: \(GroupGetResult_isMember(groupMetaResult))")
                print("Created: \(GroupGetResult_getCreated(groupMetaResult))")
                print("Updated: \(GroupGetResult_getCreated(groupMetaResult))")
            })
            //Recover from failure if this group didn't exist so we run the rest of the operation
            .flatMapError({(_) in
                print("Group \(groupId) didn't exist.")
                return Result.success(())
            })
    }
    
    static func documentList(_ ironoxide: OpaquePointer) -> Result<Void, IronOxideError> {
        Util.printWithTime("======DOCUMENT LIST======")
        return Util.mapRustResult(rustRes: IronOxide_documentList(ironoxide), fallbackError: "Document list failed for some reason")
            .map({(docResult) in
                var docListVec = DocumentListResult_getResult(docResult)
                print("Number of documents: \(docListVec.len)")
                for _ in 0..<min(docListVec.len, 3) {
                    printDocInfo(OpaquePointer(docListVec.data))
                    docListVec.data += UnsafeMutableRawPointer.Stride(docListVec.step)
                }
            })
    }
    
    static func documentGet(ironoxide: OpaquePointer, docId: String) -> Result<Void, IronOxideError> {
        Util.printWithTime("======DOCUMENT GET======")
        return IdType.documentId(docId)
            .flatMap({(docId) in
                Util.mapRustResult(rustRes: IronOxide_documentGetMetadata(ironoxide, docId), fallbackError: "Document get failed for some reason")
            })
            .map({(doc) in
                let maybeDocName = DocumentMetadataResult_getName(doc)
                if(maybeDocName.is_some == 1){
                    let nameStruct = OpaquePointer(maybeDocName.val.data)
                    print(Util.mapRustString(rustStr: DocumentName_getName(nameStruct), fallbackError: "No doc name"))
                }
                else{
                    print("{No Doc Name}")
                }
                
                print("Doc ID: \(docId)")
                print("Association: \(getDocumentAssociation(DocumentMetadataResult_getAssociationType(doc)))")
                print("Created: \(DocumentMetadataResult_getCreated(doc))")
                print("Updated: \(DocumentMetadataResult_getLastUpdated(doc))")
            })
            //Recover from failure if this document didn't exist so we run the rest of the operation
            .flatMapError({(_) in
                print("Document \(docId) didn't exist.")
                return Result.success(())
            })
    }
    
    static func roundTripEncryptAndDecrypt(ironoxide: OpaquePointer, stringToEncrypt: String) -> Result<Void, IronOxideError> {
        Util.printWithTime("======DOCUMENT ROUNDTRIP======")
        print("Original Text: \(stringToEncrypt)")
        let encryptOps = DocumentEncryptOpts_default()
        let bytesToEncrypt = CRustSlicei8(data: stringToEncrypt.utf8.map{Int8($0)}, len: UInt(stringToEncrypt.utf8.count))
        
        return Util.mapRustResult(rustRes: IronOxide_documentEncrypt(ironoxide, bytesToEncrypt, encryptOps), fallbackError: "Document encrypt failed for some reason").flatMap({(encryptedDoc) in
            
            let docIdStruct = DocumentEncryptResult_getId(encryptedDoc)
            let id = DocumentId_getId(docIdStruct)
            print("New Doc ID: \(Util.mapRustString(rustStr: id, fallbackError: "Could not get document ID"))")
            
            let encryptedBytes = DocumentEncryptResult_getEncryptedData(encryptedDoc)
            let crust = CRustSlicei8(data: encryptedBytes.data, len: encryptedBytes.len)
            
            return Util.mapRustResult(rustRes: IronOxide_documentDecrypt(ironoxide, crust), fallbackError: "Document decrypt failed for some reason")
                .map({(decryptedDoc) in
                    let decryptedBytes = DocumentDecryptResult_getDecryptedData(decryptedDoc)
                    let stringBytes = Array(UnsafeBufferPointer(start: decryptedBytes.data, count: Int(decryptedBytes.len))).map(UInt8.init)
                    //print(stringBytes)
                    let decryptedString = String(bytes: stringBytes, encoding: String.Encoding.utf8) ?? "Could not decode decrypted bytes"
                    print("Roundtrip result: \(decryptedString)")
                })
        })
    }
    
    static func unmanagedEncrypt(ironoxide: OpaquePointer, stringToEncrypt: String) -> Result<Void, IronOxideError> {
        Util.printWithTime("======UNMANGED ENCRYPT======")
        let encryptOps = DocumentEncryptOpts_default()
        let bytesToEncrypt = CRustSlicei8(data: stringToEncrypt.utf8.map{Int8($0)}, len: UInt(stringToEncrypt.utf8.count))
        return Util.mapRustResult(rustRes: IronOxide_advancedDocumentEncryptUnmanaged(ironoxide, bytesToEncrypt, encryptOps), fallbackError: "Failed to encrypt unmanaged doc for some reason")
            .map({(encryptedDoc) in
                let docIdStruct = DocumentEncryptUnmanagedResult_getId(encryptedDoc)
                let id = DocumentId_getId(docIdStruct)
                print("New Doc ID: \(Util.mapRustString(rustStr: id, fallbackError: "Could not get document ID"))")
            })
    }
}
