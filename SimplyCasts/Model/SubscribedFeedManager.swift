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
}
