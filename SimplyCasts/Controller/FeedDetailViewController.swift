//
//  FeedDetailViewController.swift
//  SimplyCasts
//
//  Created by felix on 9/8/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import CoreData

class FeedDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MiniPlayerToolbarDelegate {
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedDescription: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var miniPlayerToolbar: MiniPlayerToolbar!
    var subscribedFeedItemManager: SubscribedFeedItemManager?
    
    var fetchedResultsController: NSFetchedResultsController?
    
    var stack: CoreDataStack!
    
    weak var feed: Feed? {
        didSet {
            if let feed = feed {
                subscribedFeedItemManager = SubscribedFeedItemManager(feed: feed)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let subscribedFeedItemManager = subscribedFeedItemManager {
            return subscribedFeedItemManager.fetchedObjectsCount()
        }
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewControllerWithIdentifier("AudioPlayViewController") as! AudioPlayViewController
        
        FeedItemAudioPlayer.sharedAudioPlayer.feedItem = subscribedFeedItemManager?.getObjectAtIndex(indexPath) as? FeedItem
        
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedItemDetailTableCell", forIndexPath: indexPath)
    
        if let subscribedFeedItemManager = subscribedFeedItemManager {
            if let item = subscribedFeedItemManager.getObjectAtIndex(indexPath) as? FeedItem {
                cell.textLabel?.text = item.title
                
                cell.detailTextLabel?.attributedText = item.itemDescription?.utf8Data?.attributedString
            }
        }
        cell.layer.cornerRadius = 4.0
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = tableView.backgroundColor?.CGColor
        
        return cell
    }
    
    func miniPlayerToolbar(miniPlayerToolbar: MiniPlayerToolbar, tappedImageView: UIImageView) {
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        let resultVC = storyboard.instantiateViewControllerWithIdentifier("AudioPlayViewController") as! AudioPlayViewController
        
        self.navigationController?.pushViewController(resultVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let data = feed?.iTunesImage {
            feedImageView.image = UIImage(data: data)
        }
        
        if let itemDescription = feed?.feedDescription{
            if let attributedString = itemDescription.utf8Data?.attributedString {
                let newAttributedString = NSMutableAttributedString(attributedString: attributedString)
                
                let range = NSMakeRange(0, newAttributedString.length)
                
                newAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: range)
                newAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18), range: range)
                newAttributedString.addAttribute(NSStrokeColorAttributeName, value: UIColor.whiteColor(), range: range)
                newAttributedString.addAttribute(NSStrokeWidthAttributeName, value: -4, range: range)
                
                feedDescription.attributedText = newAttributedString
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let subscribedFeedItemManager = subscribedFeedItemManager {
            subscribedFeedItemManager.executeSearch()
            tableView.reloadData()
        }
        miniPlayerToolbar.setupMiniPlayer()
        miniPlayerToolbar.delegate = self
    }
}
