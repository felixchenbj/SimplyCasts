//
//  FeedHelperTest.swift
//  SimplyCasts
//
//  Created by felix on 8/26/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import XCTest
@testable import SimplyCasts

class FeedHelperTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testHttpFeed() {
        let helper = FeedHelper()
        
        helper.parser("http://nj.lizhi.fm/rss/12479.xml") { (info, success) in
            XCTAssert(success)
        }
    }
    
    func testHttpsFeed() {
        let helper = FeedHelper()
        helper.parser("https://ipn.li/taiyilaile/feed") { (info, success) in
            XCTAssert(success)
        }
    }

}
