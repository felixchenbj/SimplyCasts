//
//  RSSPath.swift
//  SimplyCasts
//
//  Created by felix on 9/4/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

struct RSSPath {
    static let RSS                                = "/rss"
    static let RSSChannel                         = "/rss/channel"
    static let RSSChannelTitle                    = "/rss/channel/title"
    
    static let RSSChannelLink                     = "/rss/channel/link"
    static let RSSChannelDescription              = "/rss/channel/description"
    static let RSSChannelLanguage                 = "/rss/channel/language"
    
    static let RSSChannelCategory                 = "/rss/channel/category"
    
    // itunes tags
    static let RSSiTunesCategory                  = "/rss/channel/itunes:category"
    static let RSSiTunesOwnerName                 = "/rss/channel/itunes:owner/itunes:name"
    static let RSSiTunesOwnerEmail                = "/rss/channel/itunes:owner/itunes:email"
    static let RSSiTunesImage                     = "/rss/channel/itunes:image"
}
