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

    var stack: CoreDataStack!
    
    
    override func setUp() {
        super.setUp()
        
        // Get the stack
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        stack = delegate.stack
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testHttpFeed() {
        FeedHelper.addFeed(stack.context, urlString: "http://www.bbc.co.uk/programmes/p042jdq5/episodes/downloads.rss") { (feed, info, success) in
            XCTAssert(success)
            print(feed?.title)
            print(feed?.link)
            print(feed?.publishDate)
            print(feed?.iTunesImageURL)
        }
    }
    
    func testHttpsFeed() {
        FeedHelper.addFeed(stack.context,urlString: "https://ipn.li/taiyilaile/feed") { (feed, info, success) in
            XCTAssert(success)
            print(feed?.title)
            print(feed?.link)
            print(feed?.publishDate)
            print(feed?.iTunesImageURL)
        }
    }

}
