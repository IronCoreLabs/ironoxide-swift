//
//  IronOxideId.swift
//  ironoxide-swift
//
//  Created by Ernie Turner on 4/7/20.
//  Copyright © 2020 Ernie Turner. All rights reserved.
//

import Foundation

class IdType {
    static func groupId(_ id: String) -> Result<OpaquePointer, IronOxideError> {
        return Util.mapRustResult(rustRes: GroupId_validate(Util.makeRustString(id)), fallbackError: "Provided group ID is invalid")
    }
    
    static func documentId(_ id: String) -> Result<OpaquePointer, IronOxideError>{
        return Util.mapRustResult(rustRes: DocumentId_validate(Util.makeRustString(id)), fallbackError: "Provided document ID is invalid")
    }
    
    static func UserId(_ id: String) -> Result<OpaquePointer, IronOxideError>{
        return Util.mapRustResult(rustRes: UserId_validate(Util.makeRustString(id)), fallbackError: "Provided user ID is invalid")
    }
}
