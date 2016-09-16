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
    
    func getObjectAtIndex(indexPath: NSIndexPath) -> AnyObject? {
        return fetchedResultsController?.objectAtIndexPath(indexPath)
    }
    
    func deleteObjectAtIndex(indexPath: NSIndexPath) {
        if let context = fetchedResultsController?.managedObjectContext,
            object = getObjectAtIndex(indexPath) {
            context.deleteObject(object as! NSManagedObject)
        }
    }
    
    func deleteObject(object: AnyObject) {
        if let context = fetchedResultsController?.managedObjectContext,
            _ = indexOfObject(object) {
            context.deleteObject(object as! NSManagedObject)
        }
    }
    
    func indexOfObject(object: AnyObject) -> NSIndexPath? {
        return fetchedResultsController?.indexPathForObject(object)
    }
    
    func save() {
        stack.save()
    }
    
    func getStack() -> CoreDataStack{
        return stack
    }

}