//
//  AddFeedViewController.swift
//  SimplyCasts
//
//  Created by felix on 9/5/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import CoreData

class AddFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var stack: CoreDataStack!
    
    var searchResults = [FeedInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        searchBar.showsCancelButton = true
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feedTableViewCell", forIndexPath: indexPath) as! FeedTableViewCell
        
        let result = searchResults[indexPath.row]
        cell.feedInfo = result
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let subscribe = UITableViewRowAction(style: .Normal, title: "Subscribe") { action, index in
            print("subscribe button tapped")
            
            tableView.editing = false
        }
        subscribe.backgroundColor = UIColor.orangeColor()
        return [subscribe]
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if !searchBar.text!.isEmpty {
            FeedHelper.searchFeed(searchBar.text!) { (info, results, success) in
                FunctionsHelper.performUIUpdatesOnMain({
                    if success {
                        if let results = results {
                            self.searchResults.removeAll()
                            
                            print(results.count)
                            self.searchResults = results
                            
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
    }
}
