//
//  DBHelper.swift
//  LoginRegisterWithSQLite
//
//  Created by SaiKiran Panuganti on 30/03/21.
//  Copyright © 2021 SaiKiran Panuganti. All rights reserved.
//

import Foundation
import SQLite3

enum InsertResult {
    case loggedIn
    case registration
    case failed
}


class DBHelper {
    
    init(){
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error opening database")
            return nil
        }
        else {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    
    func createTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS Users(Id INTEGER PRIMARY KEY,uid TEXT,password TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Users table created.")
            } else {
                print("Users table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id : Int, uid : String, password : String, completion :((InsertResult) -> Void)) {
        let users = read()
        print(users)
        for user in users {
            if user.userId == uid {
                print("user details are : ", user.id, user.userId, user.password)
                completion(InsertResult.loggedIn)
                return
            }
        }
        let insertStatementString = "INSERT INTO Users (Id, uid, password) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            //sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (uid as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (password as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row. ", uid, password)
                completion(InsertResult.registration)
            }else {
                print("Could not insert row.")
                completion(InsertResult.failed)
            }
        }else {
            print("INSERT statement could not be prepared.")
            completion(InsertResult.failed)
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [User] {
        let queryStatementString = "SELECT * FROM Users;"
        var queryStatement: OpaquePointer? = nil
        var users : [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let uid = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let password = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                users.append(User(id: Int(id), userId: uid, password: password))
//                print("Query Result:")
                print(sqlite3_step(queryStatement))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return users
    }
    
    func deleteByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM Users WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    func printOnConsole() {
     
    }
    
}
