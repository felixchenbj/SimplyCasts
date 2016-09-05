//
//  FeedParser.swift
//  SimplyCasts
//
//  Created by felix on 8/26/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import Foundation
import Fuzi
import CoreData


class FeedHelper {
    
    static func parserFeedInfoFromURL(urlString: String) -> FeedInfo? {
        guard let URL = NSURL(string: urlString) else {
            return nil
        }
        
        do {
            
            guard let data = NSData(contentsOfURL: URL) else {
                return nil
            }
            
            let document = try XMLDocument(data: data)
            
            var feedInfo = FeedInfo()
            
            /* get information about feed */
            
            // get title
            feedInfo.title = getTextFromElement(document.firstChild(xpath: RSSPath.RSSChannelTitle))
            
            // get link
            feedInfo.link = getTextFromElement(document.firstChild(xpath: RSSPath.RSSChannelItemLink))
            
            // get category
            feedInfo.category = getTextFromElement(document.firstChild(xpath: RSSPath.RSSiTunesCategory))
            
            // get image url
            feedInfo.iTunesImageURL = getTextFromElement(document.firstChild(xpath: RSSPath.RSSiTunesImage))
            
            // get pubDate
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
            if let pubDate = document.firstChild(xpath: RSSPath.RSSChannelPubDate) {
                if let dateString = getTextFromElement(pubDate) {
                    feedInfo.pubDate = formatter.dateFromString(dateString)
                }
            } else { // no pudDate, then try to get pubDate of the first item
                // get items in the feed
                let items = document.xpath(RSSPath.RSSChannelItem)
                if items.count > 0 {
                    if let item = items[0] {
                        if let pubDateString = getTextFromElement(item.firstChild(xpath: RSSPath.RSSChannelItemPubDate)) {
                            feedInfo.pubDate = formatter.dateFromString(pubDateString)
                        }
                    }
                }
            }
            
            return feedInfo
            
        } catch let error as XMLError {
            Logger.log.error(error)
            return nil
        } catch {
            Logger.log.error(error)
            return nil
        }

    }
    
    static func addFeed(context: NSManagedObjectContext, urlString: String, completionHandler: ((feed:Feed?, info: String, success: Bool) -> Void)? ) {
        
        guard let URL = NSURL(string: urlString) else {
            completionHandler?(feed: nil, info: "Could not convert the URL string to a NSURL.", success: false)
            return
        }
        
        do {
            
            guard let data = NSData(contentsOfURL: URL) else {
                completionHandler?(feed: nil, info: "Could not get the data from the URL.", success: false)
                return
            }
            
            let document = try XMLDocument(data: data)
            
            parserFeed(context, document: document, completionHandler: completionHandler)
            
        } catch let error as XMLError {
            Logger.log.error(error)
            if let completionHandler = completionHandler {
                completionHandler(feed: nil, info: "A XML error occured.", success: false)
            }
        } catch {
            Logger.log.error(error)
            completionHandler?(feed: nil, info: "A non-XML error occured.", success: false)
        }
    }
    
    static private func parserFeed(context: NSManagedObjectContext, document: XMLDocument, completionHandler: ((feed:Feed?, info: String, success: Bool) -> Void)? ) {
        
        let channels = document.xpath(RSSPath.RSSChannel)
        guard channels.count > 0 else {
            completionHandler?(feed: nil, info: "There is no channel in the feed.", success: false)
            return
        }
        
        let newFeed = Feed(context: context)
        
        /* get information about feed */
        
        // get title
        newFeed.title = getTextFromElement(document.firstChild(xpath: RSSPath.RSSChannelTitle))
        
        // get link
        newFeed.link = getTextFromElement(document.firstChild(xpath: RSSPath.RSSChannelItemLink))
        
        // get language
        newFeed.language = getTextFromElement(document.firstChild(xpath: RSSPath.RSSChannelLanguage))

        // get description
        newFeed.feedDescription = getTextFromElement(document.firstChild(xpath: RSSPath.RSSChannelDescription))
        
        // get image url
        newFeed.iTunesImageURL = getTextFromElement(document.firstChild(xpath: RSSPath.RSSiTunesImage))
        
        // get owner info
        newFeed.iTunesOwnerName = getTextFromElement(document.firstChild(xpath: RSSPath.RSSiTunesOwnerName))
        newFeed.iTunesOwnerEmail = getTextFromElement(document.firstChild(xpath: RSSPath.RSSiTunesOwnerEmail))
        
        // get category
        newFeed.category = getTextFromElement(document.firstChild(xpath: RSSPath.RSSChannelCategory))
        
        if let imageURL = newFeed.iTunesImageURL {
            if let url = NSURL(string: imageURL) {
                HTTPHelper.downloadImageFromUrl(url, completion: { (data, response, error) in
                    guard let data = data where error == nil else {
                        return
                    }
                    newFeed.iTunesImage = data
                })
            }
        }
        
        // get pubDate
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        
        if let pubDate = document.firstChild(xpath: RSSPath.RSSChannelPubDate) {
            if let dateString = getTextFromElement(pubDate) {
                newFeed.publishDate = formatter.dateFromString(dateString)
            }
        }
        
        // get items in the feed
        let items = document.xpath(RSSPath.RSSChannelItem)
        for item in items {
            let feedItem = FeedItem(context: context)
            
            feedItem.title = getTextFromElement(item.firstChild(xpath: RSSPath.RSSChannelItemTitle))
            feedItem.itemDescription = getTextFromElement(item.firstChild(xpath: RSSPath.RSSChannelItemDescription))
            feedItem.guid = getTextFromElement(item.firstChild(xpath: RSSPath.RSSChannelItemGUID))
            feedItem.link = getTextFromElement(item.firstChild(xpath: RSSPath.RSSChannelItemLink))
            feedItem.author = getTextFromElement(item.firstChild(xpath: RSSPath.RSSChannelItemAuthor))
            feedItem.enclosureURL = getTextFromElement(item.firstChild(xpath: RSSPath.RSSChannelItemEnclosure))

            if let dateString = getTextFromElement(item.firstChild(xpath: RSSPath.RSSChannelItemPubDate)) {
                feedItem.pubDate = formatter.dateFromString(dateString)
            }
        }
        
        completionHandler?(feed: newFeed, info: "Feed is parsered.", success: true)
    }
    
    static private func getTextFromElement(element: XMLElement?) -> String?{
        if let nodes = element?.childNodes(ofTypes: [.Text, .CDataSection]) {
            // only get the first node
            if nodes.count > 0 {
                let node = nodes[0]
                return node.stringValue
            }
        }
        return nil
    }
    
    static func needUpdateFeed(feed: Feed) -> Bool{
        if let link = feed.link {
            if let feedInfo = parserFeedInfoFromURL(link) {
                if let pubDate = feedInfo.pubDate {
                    if feed.publishDate?.compare(pubDate) == .OrderedAscending {
                        Logger.log.debug("Old publish date is \(feed.publishDate), new publish date is \(feedInfo.pubDate).")
                        return true
                    }
                }
            }
        }
        return false
    }
}