//
//  SubscribedFeedTableViewCell.swift
//  SimplyCasts
//
//  Created by felix on 9/5/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit

class SubscribedFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var stack: CoreDataStack?
    
    var feed: Feed? {
        didSet {
            if let feed = feed {
                if let data = feed.iTunesImage {
                    self.feedImageView.image = UIImage(data: data)
                    self.activityIndicator.stopAnimating()
                } else {
                    if let imageURL = feed.iTunesImageURL {
                        if let url = NSURL(string: imageURL) {
                            FunctionsHelper.performUIUpdatesOnMain({
                                self.feedImageView.image = nil
                                self.activityIndicator.startAnimating()
                            })
                            getImageData(url)
                        }
                    }
                }
                
                titleLabel.text = feed.title
                ownerLabel.text = feed.iTunesOwnerName
                descriptionLabel.text = feed.feedDescription
            }
        }
    }
    
    private func getImageData(url: NSURL){
        HTTPHelper.downloadImageFromUrl(url) { (data, response, error)  in
            FunctionsHelper.performUIUpdatesOnMain({
                guard let data = data where error == nil else {
                    self.activityIndicator.stopAnimating()
                    return
                }
                self.feedImageView.image = UIImage(data: data)
                self.feed?.iTunesImage = data
                self.activityIndicator.stopAnimating()
                
                self.stack?.save()
            })
        }
    }

}
