//
//  SubscribedFeedViewController.swift
//  SimplyCasts
//
//  Created by felix on 9/5/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import CoreData

class SubscribedFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, MiniPlayerToolbarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var miniPlayerToolbar: MiniPlayerToolbar!

    var subscribedFeedManager: SubscribedFeedManager!
    
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        subscribedFeedManager = SubscribedFeedManager()
        subscribedFeedManager.setDelegate(self)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.center = self.view.center
        activityIndicator.backgroundColor = UIColor.grayColor()
        activityIndicator.layer.cornerRadius = 5.0
        activityIndicator.layer.masksToBounds = true
        self.view.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        subscribedFeedManager.executeSearch()
        tableView.reloadData()
        
        miniPlayerToolbar.setupMiniPlayer()
        miniPlayerToolbar.delegate = self
    }
    
    func miniPlayerToolbar(miniPlayerToolbar: MiniPlayerToolbar, tappedImageView: UIImageView) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewControllerWithIdentifier("AudioPlayViewController") as! AudioPlayViewController
        
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribedFeedManager.fetchedObjectsCount()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewControllerWithIdentifier("FeedDetailViewController") as! FeedDetailViewController
        resultVC.feed = subscribedFeedManager.getObjectAtIndex(indexPath) as? Feed
        
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("subscribedFeedTableViewCell", forIndexPath: indexPath) as! SubscribedFeedTableViewCell
        
        cell.feed = subscribedFeedManager.getObjectAtIndex(indexPath) as? Feed
        
        cell.layer.cornerRadius = 10.0
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 4.0
        cell.layer.borderColor = self.view.backgroundColor?.CGColor
        
        cell.stack = subscribedFeedManager.getStack()

        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 80.0
    }
    
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let refresh = UITableViewRowAction(style: .Normal, title: "Refresh") { action, index in
            FunctionsHelper.performUIUpdatesOnMain({ 
                tableView.editing = false
                self.activityIndicator.startAnimating()
            })
            FunctionsHelper.performTasksOnBackground({
                if let feedInCell = self.subscribedFeedManager.getObjectAtIndex(indexPath) as? Feed {
                    
                    if let url = feedInCell.feedURL {
                        self.subscribedFeedManager.deleteObject(feedInCell)
                        self.subscribedFeedManager.subscribeNewFeed( url, completionHandler: { (feed, info, success) in
                            FunctionsHelper.performUIUpdatesOnMain({
                                self.subscribedFeedManager.executeSearch()
                                self.subscribedFeedManager.save()
                                tableView.reloadData()
                                self.activityIndicator.stopAnimating()
                            })
                        })
                    }
                }
            })
        }
        refresh.backgroundColor = UIColor.orangeColor()
        
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            self.subscribedFeedManager.deleteObjectAtIndex(indexPath)
            self.subscribedFeedManager.save()
        }
        delete.backgroundColor = UIColor.redColor()
        return [refresh, delete]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //subscribedFeedManager.deleteObjectAtIndex(indexPath)
    }
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
                                     atIndex sectionIndex: Int,
                                             forChangeType type: NSFetchedResultsChangeType) {
        
        let set = NSIndexSet(index: sectionIndex)
        
        switch (type){
            
        case .Insert:
            tableView.insertSections(set, withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteSections(set, withRowAnimation: .Fade)
            
        default:
            // irrelevant in our case
            break
            
        }
    }
    
    func controller(controller: NSFetchedResultsController,
                    didChangeObject anObject: AnyObject,
                                    atIndexPath indexPath: NSIndexPath?,
                                                forChangeType type: NSFetchedResultsChangeType,
                                                              newIndexPath: NSIndexPath?) {
        switch(type){
            
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
}
