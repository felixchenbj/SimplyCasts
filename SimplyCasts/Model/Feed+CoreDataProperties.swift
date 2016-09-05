//
//  Feed+CoreDataProperties.swift
//  SimplyCasts
//
//  Created by felix on 9/5/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Feed {

    @NSManaged var category: String?
    @NSManaged var feedDescription: String?
    @NSManaged var iTunesImage: NSData?
    @NSManaged var language: String?
    @NSManaged var link: String?
    @NSManaged var publishDate: NSDate?
    @NSManaged var title: String?
    @NSManaged var iTunesImageURL: String?
    @NSManaged var iTunesAuthor: String?
    @NSManaged var iTunesOwnerName: String?
    @NSManaged var iTunesOwnerEmail: String?
    @NSManaged var items: NSOrderedSet?

}
