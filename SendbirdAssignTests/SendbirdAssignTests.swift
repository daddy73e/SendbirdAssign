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
    
    

}
