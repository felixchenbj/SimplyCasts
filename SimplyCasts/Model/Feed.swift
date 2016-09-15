//
//  Feed.swift
//  SimplyCasts
//
//  Created by felix on 9/4/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import Foundation
import CoreData


class Feed: NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        
        if let entity = NSEntityDescription.entityForName("Feed", inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
    func addFeedItem(value: FeedItem) {
        self.mutableOrderedSetValueForKey("items").addObject(value)
    }
    
    func indexOfFeedItem(value: FeedItem) -> Int {
        return self.mutableOrderedSetValueForKey("items").indexOfObject(value)
    }
    
    func feedItemAtIndex(index: Int) -> FeedItem? {
        return self.mutableOrderedSetValueForKey("items").objectAtIndex(index) as? FeedItem
    }
    
    func count() -> Int {
        return self.mutableOrderedSetValueForKey("items").count
    }
}
