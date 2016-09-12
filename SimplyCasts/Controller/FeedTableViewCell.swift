//
//  FeedTableViewCell.swift
//  SimplyCasts
//
//  Created by felix on 9/5/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var feedInfo: FeedInfo? {
        didSet {
            if let feedInfo = feedInfo {
                titleLabel.text = feedInfo.title
                ownerLabel.text = feedInfo.ownerName
                
                if let imageURL = feedInfo.iTunesImageURL {
                    if let url = NSURL(string: imageURL) {
                        FunctionsHelper.performUIUpdatesOnMain({
                            self.feedImageView.image = nil
                            self.activityIndicator.startAnimating()
                        })
                        getImageData(url)
                    }
                }
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
                
                Logger.log.debug(response?.suggestedFilename ?? url.lastPathComponent ?? "")
                Logger.log.debug("Download finished.")
                self.feedImageView.image = UIImage(data: data)
                
                self.activityIndicator.stopAnimating()
            })
        }
    }
}
