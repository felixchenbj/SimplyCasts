//
//  SubscribedFeedItemManager.swift
//  SimplyCasts
//
//  Created by felix on 9/12/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import CoreData

class SubscribedFeedItemManager: CoreDataManager {
    
    init(feed: Feed) {
        super.init()
        
        setUpFeedItemResultsController(feed)
    }
    
    private func setUpFeedItemResultsController(feed: Feed) {
        let fr = NSFetchRequest(entityName: "FeedItem")
        let pred = NSPredicate(format: "feed = %@", argumentArray: [feed])
        
        fr.predicate = pred
        fr.sortDescriptors = [NSSortDescriptor(key: "pubDate", ascending: false)]
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr,
                                                            managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
}