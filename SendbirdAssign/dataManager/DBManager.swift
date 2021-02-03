//
//  DBManager.swift
//  SendbirdAssign
//
//  Created by ygsong on 2021/02/03.
//

import UIKit
import SQLite3

class DBManager:NSObject {
    static let instance = {
        return DBManager()
    }()
    
    private override init() { }
    
    let createTableString = """
    CREATE TABLE Notes(
    id INT PRIMARY KEY NOT NULL,
    content CHAR(255));
    """
    
    private func openDB() -> OpaquePointer? {
        var pointer:OpaquePointer? = nil
        let result = sqlite3_open(self.dbPath(), &pointer)
        if result == SQLITE_OK {
            return pointer
        }
        return nil
    }
    
    private func closeDB(_ pointer:OpaquePointer?) {
        if let pointer = pointer {
            sqlite3_close(pointer)
        }
    }
    
    private func dbPath() -> String {
        return try! FileManager.default
            .url(for: FileManager.SearchPathDirectory.documentDirectory,
                 in: FileManager.SearchPathDomainMask.userDomainMask,
                 appropriateFor: nil, create: false)
            .appendingPathComponent("sendbird.db").path
    }
    
    public func createTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(openDB(), createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            // 3
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Contact table created.")
            } else {
                print("Contact table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    public func insertNote(note:Note,
                           completion: @escaping (Bool) -> Void) {
        var insertStatement: OpaquePointer? = nil
        let insertStatementString = "INSERT INTO Notes (id, content) VALUES (?, ?);"
        
        if sqlite3_prepare_v2(openDB(), insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            let id:Int32 = Int32(note.isbn13) ?? 0
            sqlite3_bind_int(insertStatement, 1, id)
            sqlite3_bind_text(insertStatement, 2, note.content, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                completion(true)
            } else {
                completion(false)
            }
        } else {
            completion(false)
        }
        sqlite3_finalize(insertStatement)
    }
    
    public func updateNote(note:Note,
                           completion: @escaping (Bool) -> Void) {
        let updateStatementString = "UPDATE Notes SET content = '\(note.content)' WHERE Id = \(note.isbn13);"
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(openDB(), updateStatementString, -1, &updateStatement, nil) ==
            SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                completion(true)
            } else {
                completion(false)
            }
        } else {
            completion(false)
        }
        sqlite3_finalize(updateStatement)
    }
    
    public func deleteNote(isbn13:String,
                           completion: @escaping (Bool) -> Void) {
        let deleteStatementStirng = "DELETE FROM Notes WHERE id = " + isbn13
        var deleteStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(openDB(), deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                completion(true)
            } else {
                completion(false)
            }
        } else {
            completion(false)
        }
        sqlite3_finalize(deleteStatement)
    }
    
    
    public func readNotes(completion: @escaping ([Note]?) -> Void ) {
        let queryStatementString = "SELECT * FROM Notes;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(openDB(), queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            var notes = [Note]()
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let isbn13 = "\(sqlite3_column_int(queryStatement, 0))"
                let content = String(cString: sqlite3_column_text(queryStatement, 1))
                let note = Note(isbn13: isbn13, content: content)
                notes.append(note)
            }
            completion(notes)
        } else {
            completion(nil)
        }
        
        sqlite3_finalize(queryStatement)
    }
    
}
