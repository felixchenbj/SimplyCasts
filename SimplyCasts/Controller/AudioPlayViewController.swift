//
//  AudioPlayViewController.swift
//  SimplyCasts
//
//  Created by felix on 9/13/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit

class AudioPlayViewController: UIViewController {
    var feedItem: FeedItem?
    
    
    var playImage = UIImage(named: "play")
    var pauseImage = UIImage(named: "pause")
    
    enum PlayingState {
        case Playing
        case Paused
        case None
    }
    
    var state: PlayingState = .None
    
    @IBOutlet weak var feedTitleLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedItemDescriptionTextView: UITextView!
    @IBOutlet weak var feedItemTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    
    
    @IBOutlet weak var progressSlider: UISlider!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var rewindButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var fastForwardButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func progressSliderChanged(sender: UISlider) {
    }
    
    @IBAction func previous(sender: AnyObject) {
    }
    @IBAction func rewind(sender: AnyObject) {
    }
    @IBAction func play(sender: AnyObject) {
        
    }
    @IBAction func fastForward(sender: AnyObject) {
    }
    @IBAction func next(sender: AnyObject) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updatePlayButton()
    }
    
    
    private func setupUI() {
        if let feedItem = feedItem {
            feedTitleLabel.text = feedItem.feed?.title
            
            if let data = feedItem.feed?.iTunesImage {
                feedImageView.image = UIImage(data: data)
            }

            feedItemTitleLabel.text = feedItem.title
            
            if let author = feedItem.author {
                authorLabel.text = author
            } else {
                authorLabel.text = feedItem.feed?.author
            }
            
            if let itemDescription = feedItem.itemDescription {
                if let attributedString = itemDescription.utf8Data?.attributedString {
                    let newAttributedString = NSMutableAttributedString(attributedString: attributedString)
                    
                    let range = NSMakeRange(0, newAttributedString.length)
                    
                    newAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGrayColor(), range: range)
                    
                    newAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(18), range: range)
                    
                    newAttributedString.addAttribute(NSStrokeColorAttributeName, value: UIColor.whiteColor(), range: range)
                    
                    newAttributedString.addAttribute(NSStrokeWidthAttributeName, value: -4, range: range)
                    
                    feedItemDescriptionTextView.attributedText = newAttributedString
                }
            }
            
          

        }
    }
    
    private func updatePlayButton() {
        if state != .Playing {
            playButton.setImage(playImage, forState: .Normal)
        } else {
            playButton.setImage(pauseImage, forState: .Normal)
        }
    }
}