//
//  FeedParser.swift
//  SimplyCasts
//
//  Created by felix on 8/26/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import Foundation
import Fuzi

class FeedHelper {
    
    
    func parser(urlString: String, completionHandler: ((info: String, success: Bool) -> Void)? ) {
        
        guard let URL = NSURL(string: urlString) else {
            if let completionHandler = completionHandler {
                completionHandler(info: "Could not convert the URL string to a NSURL.", success: false)
            }
            return
        }
        
        do {
            
            guard let data = NSData(contentsOfURL: URL) else {
                if let completionHandler = completionHandler {
                    completionHandler(info: "Could not get the data from the URL.", success: false)
                }
                return
            }
            
            let document = try XMLDocument(data: data)
            
            parserFeed(document, completionHandler: completionHandler)
            
        } catch let error as XMLError {
            Logger.log.error(error)
            if let completionHandler = completionHandler {
                completionHandler(info: "A XML error occured.", success: false)
            }
        } catch {
            Logger.log.error(error)
            if let completionHandler = completionHandler {
                completionHandler(info: "A non-XML error occured.", success: false)
            }
        }
        
    }
    
    func parserFeed(document: XMLDocument, completionHandler: ((info: String, success: Bool) -> Void)? ) {
        
        let channels = document.xpath(RSSPath.RSSChannel)
        guard channels.count > 0 else {
            completionHandler?(info: "There is no channel in the feed.", success: false)
            return
        }
        
        let title = document.firstChild(xpath: RSSPath.RSSChannelTitle)
        print(getTextFromElement(title))
    }
    
    func getTextFromElement(element: XMLElement?) -> String?{
        if let nodes = element?.childNodes(ofTypes: [.Text, .CDataSection]) {
            // only get the first node
            if nodes.count > 0 {
                let node = nodes[0]
                return node.stringValue
            }
        }
        return nil
    }
}