//
//  Constants.swift
//  VirtualTourist
//
//  Created by felix on 8/18/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit


struct Constants {
    // MARK: URLs
    static let ApiScheme = "http"
    static let ApiSecureScheme = "https"
    
    struct HTTPMethod {
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
    }
    
    static let ApiHost = "itunes.apple.com"
    static let ApiPath = "/search"
    
    static let buildinFeeds = [ "http://www.bbc.co.uk/programmes/p042jdq5/episodes/downloads.rss",
                                "https://ipn.li/taiyilaile/feed",
                                "http://nj.lizhi.fm/rss/12479.xml",
                                "http://www.bbc.co.uk/programmes/p02pnn9d/episodes/downloads.rss",
                                "http://feed.thisamericanlife.org/talpodcast?format=xml"
                                ]
    
    
    static let AudioPlayer_Step = 10
}