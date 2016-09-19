//
//  MiniPlayerToolbar.swift
//  SimplyCasts
//
//  Created by felix on 9/15/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import UIKit
import KDEAudioPlayer

@IBDesignable
class MiniPlayerToolbar: UIView, AudioPlayerDelegate {
    var view: UIView!
    var player = FeedItemAudioPlayer.sharedAudioPlayer
    var playImage = UIImage(named: "play")
    var pauseImage = UIImage(named: "pause")
    
    var repeatAllImage = UIImage(named: "repeatAll")
    var repeatImage = UIImage(named: "repeat")
    
    var delegate: MiniPlayerToolbarDelegate?
    
    @IBOutlet weak var feedItemImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var feedItemTitle: UILabel!
    @IBOutlet weak var playButton: RoundButton!
    
    @IBOutlet weak var shuffleButton: RoundButton!
    @IBOutlet weak var repeatModeButton: RoundButton!
    
    
    @IBAction func previous(sender: AnyObject) {
        player.previous()
        updateUI()
    }
    
    @IBAction func rewind(sender: AnyObject) {
        player.rewind(Constants.AudioPlayer_Step)
    }
    
    @IBAction func play(sender: AnyObject) {
        if let _ = player.getCurrentFeedItem() {
            if player.state == .Playing {
                player.pause()
            } else {
                player.resume()
            }
            
            updatePlayButton()
        }
    }
    
    @IBAction func fastForward(sender: AnyObject) {
        player.fastForward(Constants.AudioPlayer_Step)
    }
    
    @IBAction func next(sender: AnyObject) {
        player.next()
        updateUI()
    }
    
    @IBAction func shuffleButtonPressed(sender: AnyObject) {
        if player.mode.contains(.Shuffle) {
            player.mode.remove(.Shuffle)
        } else {
            player.mode.insert(.Shuffle)
        }
        
        player.rebuildItemList()
        
        updateUI()
    }
    
    @IBAction func repeatButtonPressed(sender: AnyObject) {
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
    
    // MUST be called before use the miniplayer
    func setupMiniPlayer() {
        updateUI()
        
        player.delegate = self

        feedItemImageView.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MiniPlayerToolbar.imageTapped))
        feedItemImageView.addGestureRecognizer(tapRecognizer)
    }
    
    func updateUI() {
        if let feedItem = player.getCurrentFeedItem() {
            if let data = feedItem.feed?.iTunesImage {
                feedItemImageView.image = UIImage(data: data)
            }
        }
        updatePlayButton()
        updateModeButtons()
        
        if let currentProgression = player.currentItemProgression, duration = player.currentItemDuration {
            progressView.progress = Float(currentProgression / duration)
        }
        feedItemTitle.text = player.getCurrentFeedItem()?.title
    }
    
    func imageTapped() {
        if player.state == .Playing || player.state == .Paused {
            delegate?.miniPlayerToolbar(self, tappedImageView: feedItemImageView)
        }
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, didUpdateProgressionToTime time: NSTimeInterval, percentageRead: Float) {
        progressView.progress  = Float(percentageRead / 100)
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, toState to: AudioPlayerState) {
        Logger.log.debug("from \(from) to \(to)")
        updatePlayButton()
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, willStartPlayingItem item: AudioItem) {
        if let feedItem = player.getCurrentFeedItem() {
            delegate?.miniPlayerToolbar(self, willStartPlayingItem: feedItem)
        }
    }
    
    func updatePlayButton() {
        if player.state == .Playing {
            playButton.setImage(pauseImage, forState: .Normal)
        } else {
            playButton.setImage(playImage, forState: .Normal)
        }
    }
    
    
    private func updateModeButtons() {
        if player.mode.contains(.Shuffle) {
            shuffleButton.selected = true
        } else {
            shuffleButton.selected = false
        }
        
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

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        view = loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        view = loadViewFromNib()
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName(), bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view);
        return view
    }
    private func nibName() -> String {
        return String(self.dynamicType)
    }
}

protocol MiniPlayerToolbarDelegate {
    func miniPlayerToolbar(miniPlayerToolbar: MiniPlayerToolbar, tappedImageView: UIImageView)
    func miniPlayerToolbar(miniPlayerToolbar: MiniPlayerToolbar, willStartPlayingItem item: FeedItem)
}

extension MiniPlayerToolbarDelegate {
    func miniPlayerToolbar(miniPlayerToolbar: MiniPlayerToolbar, tappedImageView: UIImageView) {
        
    }
    func miniPlayerToolbar(miniPlayerToolbar: MiniPlayerToolbar, willStartPlayingItem item: FeedItem) {
        
    }
}
