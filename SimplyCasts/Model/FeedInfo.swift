//
//  FeedInfo.swift
//  SimplyCasts
//
//  Created by felix on 9/5/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import Foundation


struct FeedInfo {
    var title: String?
    var ownerName: String?
    var category: String?
    var feedURL: String?
    var pubDate: NSDate?
    var iTunesImageURL: String?
    
    var items: [FeedItemInfo]?
}

struct FeedItemInfo {
    var title: String?
    var itemDescription: String?
    var author: String?
    var pubDate: NSDate?
    var enclosureURL: String?
    
    var feedInfo: FeedInfo?
}
