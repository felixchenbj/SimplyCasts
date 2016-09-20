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
    var player = FeedItemAudioPlayer.sharedAudioPlayer
    
    var playImage = UIImage(named: "play")
    var pauseImage = UIImage(named: "pause")
    
    var repeatAllImage = UIImage(named: "repeatAll")
    var repeatImage = UIImage(named: "repeat")
    
    @IBOutlet weak var feedTitleLabel: UILabel!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedItemDescriptionTextView: UITextView!
    @IBOutlet weak var feedItemTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    
    
    @IBOutlet weak var progressSlider: UISlider!
    
    @IBOutlet weak var previousButton: RoundButton!
    @IBOutlet weak var rewindButton: RoundButton!
    @IBOutlet weak var playButton: RoundButtonWithLoading!
    @IBOutlet weak var fastForwardButton: RoundButton!
    @IBOutlet weak var nextButton: RoundButton!
    @IBOutlet weak var repeatModeButton: RoundButton!
    
    @IBAction func previous(sender: AnyObject) {
        player.previous()
        updateUI()
    }
    
    @IBAction func rewind(sender: AnyObject) {
        player.rewind(Constants.AudioPlayer_Step)
    }
    
    @IBAction func play(sender: AnyObject) {
        if player.state == .Playing {
            player.pause()
        } else {
            player.resume()
        }
        updatePlayButton()
    }
    
    @IBAction func fastForward(sender: AnyObject) {
        player.fastForward(Constants.AudioPlayer_Step)
    }
    
    @IBAction func next(sender: AnyObject) {
        player.next()
        updateUI()
    }

    @IBAction func sliderValueChanged(sender: AnyObject) {
        if let currentItemDuration = player.currentItemDuration {
            player.seekToTime(Double(progressSlider.value / 100) * currentItemDuration )
        }
    }
    
    @IBAction func repeatModeButtonPressed(sender: RoundButton) {
        if player.mode.contains(.RepeatAll) {
            player.mode.remove(.RepeatAll)
            player.mode.insert(.Repeat)
        } else if player.mode.contains(.Repeat) {
            player.mode.remove(.Repeat)
        } else {
            player.mode.insert(.RepeatAll)
        }
        
        updateModeButtons()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player.delegate = self
        updateUI()
    }
    
    private func updateUI() {
        if let feedItem = player.getCurrentFeedItem() {
            setupControls(feedItem)
            updatePlayButton()
            updateModeButtons()
            setupSlider(feedItem)
        }
    }
    
    private func setupControls(feedItem: FeedItem) {
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
                
                newAttributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: range)
                newAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(20), range: range)                
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
    
    private func updateModeButtons() {
        if player.mode.contains(.RepeatAll) {
            repeatModeButton.setImage(repeatAllImage, forState: .Normal)
            repeatModeButton.selected = true
        } else if player.mode.contains(.Repeat) {
            repeatModeButton.setImage(repeatImage, forState: .Normal)
            repeatModeButton.selected = true
        } else {
            repeatModeButton.setImage(repeatAllImage, forState: .Normal)
            repeatModeButton.selected = false
        }
    }
    
    private func setupSlider(feedItem: FeedItem) {
        progressSlider.minimumValue = 0
        progressSlider.maximumValue = 100
        progressSlider.value = 0
        currentLabel.text = "00:00"
        totalLabel.text  = "00:00"
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, didUpdateProgressionToTime time: NSTimeInterval, percentageRead: Float) {
        currentLabel.text = stringFromTimeInterval(time)
        progressSlider.value = percentageRead
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, toState to: AudioPlayerState) {
        Logger.log.debug("from \(from) to \(to)")
        updatePlayButton()
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, willStartPlayingItem item: AudioItem) {
        updateUI()
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, didFindDuration duration: NSTimeInterval, forItem item: AudioItem) {
        totalLabel.text = stringFromTimeInterval(NSTimeInterval(duration))
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