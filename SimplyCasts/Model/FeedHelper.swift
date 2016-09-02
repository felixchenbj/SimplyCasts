//
//  FeedParser.swift
//  SimplyCasts
//
//  Created by felix on 8/26/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import Foundation
import FeedKit

class FeedHelper {
    
    
    func parser(urlString: String) {
        
        let URL = NSURL(string: urlString)
        
        if let URL = URL {
            FeedParser(URL: URL)?.parse({ (result) in
                switch result {
                case .RSS(let rssFeed):
                    
                    print(rssFeed.title)
                    print(rssFeed.description)
                    print(rssFeed.categories)
                    print(rssFeed.docs)
                    print(rssFeed.generator)
                    print(rssFeed.managingEditor)
                    print(rssFeed.pubDate)
                    print(rssFeed.lastBuildDate)
                    print(rssFeed.textInput)
                    print(rssFeed.webMaster)
                    print(rssFeed.image)
                    
                case .Failure(let error):
                    Logger.log.error("Failed to parse the feed: \(urlString), error is, \(error)")
                default:
                    Logger.log.error("Only rss feed is good for this app.")
                }
                
            })
        }
    }
}