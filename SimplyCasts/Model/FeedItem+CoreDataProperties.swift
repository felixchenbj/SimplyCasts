//
//  FeedItem+CoreDataProperties.swift
//  SimplyCasts
//
//  Created by felix on 9/13/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension FeedItem {

    @NSManaged var author: String?
    @NSManaged var enclosurePath: String?
    @NSManaged var enclosureURL: String?
    @NSManaged var guid: String?
    @NSManaged var itemDescription: String?
    @NSManaged var link: String?
    @NSManaged var pubDate: NSDate?
    @NSManaged var title: String?
    @NSManaged var duration: NSNumber?
    @NSManaged var feed: Feed?

}
