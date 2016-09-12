//
//  FeedDetailViewController.swift
//  SimplyCasts
//
//  Created by felix on 9/8/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import CoreData

class FeedDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedDescription: UITextView!
    @IBOutlet weak var subscribeSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController?
    
    var stack: CoreDataStack!
    
    var feedInfo: FeedInfo? = nil
    weak var feed: Feed? = nil

    @IBAction func subscribeSwitchChanged(sender: UISwitch) {
        
        if sender.on {
            
        } else {
            
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getItemCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedItemDetailTableCell", forIndexPath: indexPath)
        
        if subscribed() {
            if let feed = feed {
                if let item = feed.items?[indexPath.row] as? FeedItem {
                    cell.textLabel?.text = item.title
                    cell.detailTextLabel?.text = item.itemDescription
                }
            }
        } else {
            if let feedInfo = feedInfo {
                if let item = feedInfo.items?[indexPath.row] {
                    cell.textLabel?.text = item.title
                    cell.detailTextLabel?.text = item.itemDescription
                }
            }
        }
        
        return cell
    }
    
    func getItemCount() -> Int {
        if subscribed() {
            if let feed = feed {
                return (feed.items?.count)!
            }
        } else {
            if let feedInfo = feedInfo {
                return (feedInfo.items?.count)!
            }
        }
        return 0
    }
    
    func subscribed() -> Bool {
        if let _ = feed {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        
        // Get the stack
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        stack = delegate.stack
        
        //setUpFetchedResultsController()
        //fetchedResultsController?.delegate = self
    }

    private func setUpFetchedResultsController() {
        if let feed = feed {
            // Create a fetchrequest
            let fr = NSFetchRequest(entityName: "FeedItem")
            fr.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            let pred = NSPredicate(format: "feed = %@", argumentArray: [feed])
            
            fr.predicate = pred
            
            // Create the FetchedResultsController
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fr,
                                                                  managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        }
    }
}
