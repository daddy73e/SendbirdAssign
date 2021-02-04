//
//  SendbirdAssignTests.swift
//  SendbirdAssignTests
//
//  Created by ygsong on 2021/01/29.
//

import XCTest
@testable import SendbirdAssign

class SendbirdAssignTests: XCTestCase {

    override func setUp() {
        super.setUp()
        DBManager.instance.createTable()
//        DBManager.instance.createTableTemp()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
    
    }
    
    func testRequestSearch() {
        var resultObject:SearchResponse?
        let expectation = XCTestExpectation(description: "ApiManager Search TaskExpectation")
        
        ApiManager.instance.reqSearchBook(name: "mongodb", page: 0) {
            resultObject = $0
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
        print(resultObject ?? "")
        
        XCTAssertNotNil(resultObject)
    }
    
    func testRequestDetail() {
        var resultObject:Book?
        let expectation = XCTestExpectation(description: "ApiManager Detail TaskExpectation")
        
        ApiManager.instance.reqDetailInfo(isbn13: "9781617294136", completion: {
            resultObject = $0
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 2.0)
        print(resultObject ?? "")
        XCTAssertNotNil(resultObject)
    }
    
    func testDB() {
        testDBReadAll()
        
        print("--------------------- insert ---------------------")
        let note0 = Note(isbn13: "9700000000001", content: "content 971")
        let note1 = Note(isbn13: "9700000000002", content: "content 972")
        let note2 = Note(isbn13: "9700000000003", content: "content 973")
        DBManager.instance.insertNote(note: note0) { (isSuccess) in }
        DBManager.instance.insertNote(note: note1) { (isSuccess) in }
        DBManager.instance.insertNote(note: note2) { (isSuccess) in }
        print("--------------------- insert Result ---------------------")
        testDBReadAll()
        
        print("")
        print("--------------------- upate ---------------------")
        DBManager.instance.updateNote(note: Note(isbn13: "9700000000001",
                                                 content: "update 971")) { (isSuccess) in }
        print("--------------------- update Result ---------------------")
        testDBReadAll()
        
        print("")
        print("--------------------- delete ---------------------")
        DBManager.instance.deleteNote(isbn13: "9700000000003") { (isSucces) in }
        print("--------------------- delete Result ---------------------")
        testDBReadAll()
    }
    
    func testDBInsert() {
        testDBReadAll()
        
        let note0 = Note(isbn13: "9781617294136", content: "TEST 00000000000000000")
        let note1 = Note(isbn13: "9781617291609", content: "TEST 11111111111111111")
        
        DBManager.instance.insertNote(note: note0) { (isSuccess) in
            print("Insert DB Note1 result = \(isSuccess)")
            print("")
        }
        
        DBManager.instance.insertNote(note: note1) { (isSuccess) in
            print("Insert DB Note2 result = \(isSuccess)")
            print("")
        }
        
        testDBReadAll()
    }
    
    func testDBReadAll() {
        DBManager.instance.readNotes { (notes) in
            if notes?.count == 0 {
                print("")
                print("Empty DB")
                print("")
            }
        }
    }
    
    func testDBReadNote() {
        testDBReadAll()
        DBManager.instance.readNote(isbn13:"9781617294136") { (note) in
            if let note = note {
                print("Note = \(note)")
                print("")
            }
        }
    }
    
    func testDeleteNote() {
        testDBReadAll()
        DBManager.instance.deleteNote(isbn13: "9781617294136") { (isSuccess) in
            print("Delete DB result = \(isSuccess)")
            print("")
        }
        testDBReadAll()
    }

    func testUpdateNote() {
        testDBReadAll()
        let isbn13 = "9781617291609"
        let content = "Update DB Update DBUpdate DB"
        DBManager.instance.updateNote(note: Note(isbn13: isbn13,
                                                 content: content)) { (isSuccess) in
            print("Update DB id = \(isbn13) result = \(isSuccess)")
            print("")
        }
        testDBReadAll()
    }
    
}
