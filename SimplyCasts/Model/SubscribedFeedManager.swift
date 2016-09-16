//
//  SubscribedFeedManager.swift
//  SimplyCasts
//
//  Created by felix on 9/12/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import CoreData

class SubscribedFeedManager: CoreDataManager {

    override func setUpFetchedResultsController() {
        // Create a fetchrequest
        let fr = NSFetchRequest(entityName: "Feed")
        fr.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr,
                                                              managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
        
    func subscribeNewFeed(feedInfo: FeedInfo, completionHandler: ((feed:Feed?, info: String, success: Bool) -> Void)? ) {
        if let link = feedInfo.feedURL {
            subscribeNewFeed(link, completionHandler: completionHandler)
        }
    }
    
    func subscribeNewFeed(feedURL: String, completionHandler: ((feed:Feed?, info: String, success: Bool) -> Void)? ) {
        
        if isSubscribed(feedURL) {
            completionHandler?(feed: nil, info: "This feed is already subscribed.", success: false)
        } else {
            FeedHelper.addFeed(stack.context, urlString: feedURL, completionHandler: completionHandler)
        }
    }
    
    func isSubscribed(feedURL: String) -> Bool{
        executeSearch()
        
        if let fc = fetchedResultsController{
            if let fetchedObjects = fc.fetchedObjects {
                for object in fetchedObjects {
                    if let feed = object as? Feed {
                        if let link = feed.feedURL {
                            if feedURL == link {
                                return true
                            }
                        }
                    }
                }
            }
        }
        return false
    }
}
