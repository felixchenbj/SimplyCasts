//
//  AddFeedViewController.swift
//  SimplyCasts
//
//  Created by felix on 9/5/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import CoreData
import KDEAudioPlayer

class AddFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var nothingFoundLabel: UILabel!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var subscribedFeedManager: SubscribedFeedManager!
    
    var searchResults = [FeedInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        searchBar.showsCancelButton = true
        
        nothingFoundLabel.hidden = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        activityIndicator.center = self.view.center
        activityIndicator.backgroundColor = UIColor.grayColor()
        activityIndicator.layer.cornerRadius = 5.0
        activityIndicator.layer.masksToBounds = true
        
        self.view.addSubview(activityIndicator)
        activityIndicator.stopAnimating()
        
        subscribedFeedManager = SubscribedFeedManager()
        
        subscribedFeedManager.executeSearch()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedTableViewCell", forIndexPath: indexPath) as! FeedTableViewCell
        
        let result = searchResults[indexPath.row]
        cell.feedInfo = result
        
        cell.layer.cornerRadius = 6.0
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = tableView.backgroundColor?.CGColor
        
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {

        let subscribe = UITableViewRowAction(style: .Normal, title: "Subscribe") { action, index in
            FunctionsHelper.performUIUpdatesOnMain({
                tableView.editing = false
                self.activityIndicator.startAnimating()
            })
            
            let feedInfo = self.searchResults[indexPath.row]
            
            FunctionsHelper.performTasksOnBackground({
                self.subscribedFeedManager.subscribeNewFeed( feedInfo, completionHandler: { (feed, info, success) in
                    FunctionsHelper.performUIUpdatesOnMain({
                        self.activityIndicator.stopAnimating()
                        if success {
                            FunctionsHelper.popupAnOKAlert(self, title: "Subscribe", message: "Successfully!", handler: nil)
                            self.subscribedFeedManager.save()
                        } else {
                            FunctionsHelper.popupAnOKAlert(self, title: "Subscribe", message: "Failed!", handler: nil)
                        }
                    })
                })
            })
        }
        subscribe.backgroundColor = UIColor.orangeColor()
        return [subscribe]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let reachability = Reachability.reachabilityForInternetConnection()
        if !reachability.isReachable() {
            FunctionsHelper.popupAnOKAlert(self, title: "Network", message: "Network connection is not available!", handler: nil)
            return
        }
        
        if !searchBar.text!.isEmpty {
            activityIndicator.startAnimating()
            FeedHelper.searchFeed(searchBar.text!) { (info, results, success) in
                FunctionsHelper.performUIUpdatesOnMain({
                    if success {
                        if let results = results {
                            self.searchResults.removeAll()
                            
                            Logger.log.debug("Found \(results.count) podcasts.")
                            self.searchResults = results
                            
                            if results.count == 0 {
                                self.nothingFoundLabel.hidden = false
                            } else {
                                self.nothingFoundLabel.hidden = true
                            }
                            self.activityIndicator.stopAnimating()
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        nothingFoundLabel.hidden = true
    }
}
