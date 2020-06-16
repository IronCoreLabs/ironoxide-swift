//
//  TodoList.swift
//  encrypted-todos
//
//  Copyright © 2020 IronCore Labs. All rights reserved.
//

import IronOxide
import os.log
import UIKit

// Represents an encrypted Todo list which holds the list ID, (unencrypted) name, updated timestamp, and
// the encrypted todo list content bytes. Note that storing the name of the list in plaintext can cause
// information leakage. Think carefully when storing unencrypted data next to encrypted data, as in this
// example.
class TodoList: NSObject, NSCoding {
    // MARK: Properties

    var id: String
    var name: String
    var updated: Date
    var encryptedContent: [UInt8]

    // MARK: Archiving Paths

    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("encryptedTodos")

    // MARK: Types

    struct PropertyKey {
        static let id = "id"
        static let name = "name"
        static let updated = "updated"
        static let encryptedContent = "encryptedContent"
    }

    // MARK: Initialization

    init(id: String, name: String, updated: Date, encryptedContent: [UInt8]) {
        self.id = id
        self.name = name
        self.updated = updated
        self.encryptedContent = encryptedContent
    }

    init(name: String, encryptResult: IronOxide.DocumentEncryptResult) {
        self.name = name
        id = encryptResult.id.id
        updated = encryptResult.lastUpdated
        encryptedContent = encryptResult.encryptedData
    }

    // MARK: NSCoding

    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(updated, forKey: PropertyKey.updated)
        aCoder.encode(encryptedContent, forKey: PropertyKey.encryptedContent)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: PropertyKey.id) as? String else {
            os_log("Unable to decode the ID for the TodoList object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for the TodoList object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let updated = aDecoder.decodeObject(forKey: PropertyKey.updated) as? Date else {
            os_log("Unable to decode the date for the TodoList object.", log: OSLog.default, type: .debug)
            return nil
        }
        guard let encryptedContent = aDecoder.decodeObject(forKey: PropertyKey.encryptedContent) as? [UInt8] else {
            os_log("Unable to decode the encrypted content for the TodoList object.", log: OSLog.default, type: .debug)
            return nil
        }
        self.init(id: id, name: name, updated: updated, encryptedContent: encryptedContent)
    }
}
