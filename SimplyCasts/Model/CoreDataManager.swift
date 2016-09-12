//
//  CoreDataManager.swift
//  SimplyCasts
//
//  Created by felix on 9/12/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager {
    var fetchedResultsController: NSFetchedResultsController?
    var stack: CoreDataStack!
    
    init() {
        // Get the stack
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        stack = delegate.stack
        
        setUpFetchedResultsController()
    }
    
    func setUpFetchedResultsController() {
    }
    
    func setDelegate(delegate: NSFetchedResultsControllerDelegate) {
        fetchedResultsController?.delegate = delegate
    }
    
    func executeSearch(){
        if let fc = fetchedResultsController{
            do{
                try fc.performFetch()
            }catch let e as NSError{
                Logger.log.error("Error while trying to perform a search: \n\(e)\n\(self.fetchedResultsController)")
            }
        }
    }
    
    func fetchedObjectsCount() -> Int {
        if let fc = fetchedResultsController{
            if let fetchedObjects = fc.fetchedObjects {
                return fetchedObjects.count
            }
        }
        return 0
    }
    
    func getFeedAtIndex(indexPath: NSIndexPath) -> Feed? {
        return fetchedResultsController?.objectAtIndexPath(indexPath) as? Feed
    }
    
    func deleteFeedAtIndex(indexPath: NSIndexPath) {
        if let context = fetchedResultsController?.managedObjectContext,
            feed = getFeedAtIndex(indexPath) {
            context.deleteObject(feed)
        }
    }
    
    func save() {
        stack.save()
    }

}