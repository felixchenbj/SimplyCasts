//
//  FeedItem.swift
//  SimplyCasts
//
//  Created by felix on 9/4/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import Foundation
import CoreData


class FeedItem: NSManagedObject {

    convenience init(context: NSManagedObjectContext) {
        
        if let entity = NSEntityDescription.entityForName("FeedItem", inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
        } else {
            fatalError("Unable to find Entity name!")
        }
    }

}
