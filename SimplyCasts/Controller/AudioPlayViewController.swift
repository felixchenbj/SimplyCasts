//
//  AudioPlayViewController.swift
//  SimplyCasts
//
//  Created by felix on 9/13/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import KDEAudioPlayer

class AudioPlayViewController: UIViewController, AudioPlayerDelegate {
    //var feedItem: FeedItem?
    var player = FeedItemAudioPlayer.sharedAudioPlayer
    
    var playImage = UIImage(named: "play")
    var pauseImage = UIImage(named: "pause")
    
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
    @IBOutlet weak var playButton: RoundButtonWithLoading!
    @IBOutlet weak var fastForwardButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func previous(sender: AnyObject) {
    }
    
    @IBAction func rewind(sender: AnyObject) {
        player.rewind(10)
    }
    
    @IBAction func play(sender: AnyObject) {
        
        
        switch player.state {
        case .Playing:
            player.pause()
        case .Paused:
            player.resume()
        default:
            player.play()
        }

        updatePlayButton()
    }
    
    @IBAction func fastForward(sender: AnyObject) {
        player.fastForward(10)
    }
    
    @IBAction func next(sender: AnyObject) {
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let feedItem = player.feedItem {
            
            player.delegate = self
            
            setupUI(feedItem)
            updatePlayButton()
            setupSlider(feedItem)
        }
    }
    
    private func setupUI(feedItem: FeedItem) {
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
    
    private func updatePlayButton() {
        if player.state == .Playing {
            playButton.hideLoading()
            playButton.setImage(pauseImage, forState: .Normal)
        } else {
            if player.state == .Buffering || player.state == .WaitingForConnection {
                playButton.showLoading()
                playButton.setImage(nil, forState: .Normal)
            } else {
                playButton.hideLoading()
                playButton.setImage(playImage, forState: .Normal)
            }
        }
    }
    
    private func setupSlider(feedItem: FeedItem) {
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 100
        progressSlider.value = 0
        currentLabel.text = "00:00"
        
        if let duration = feedItem.duration {
            totalLabel.text = stringFromTimeInterval(NSTimeInterval(duration))
        } else {
            totalLabel.text = stringFromTimeInterval(0)
        }
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, didUpdateProgressionToTime time: NSTimeInterval, percentageRead: Float) {
        currentLabel.text = stringFromTimeInterval(time)
        progressSlider.value = percentageRead
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, toState to: AudioPlayerState) {
        updatePlayButton()
    }
    
    private func stringFromTimeInterval(interval:NSTimeInterval) -> String {
        let ti = NSInteger(interval)
        //let ms = Int((interval % 1) * 1000)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        var result:String = ""
        
        if hours > 0 {
            result = String(format: "%0.2d:", hours)
        }
        result = result + String(format: "%0.2d:%0.2d", minutes,seconds)
        return result
    }
}