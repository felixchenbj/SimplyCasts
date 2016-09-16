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
    
    var delegate: MiniPlayerToolbarDelegate?
    
    @IBOutlet weak var feedItemImageView: UIImageView!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var feedItemTitle: UILabel!
    @IBOutlet weak var playButton: RoundButton!
    
    @IBAction func previous(sender: AnyObject) {
    }
    
    @IBAction func rewind(sender: AnyObject) {
        player.rewind(Constants.AudioPlayer_Step)
    }
    
    @IBAction func play(sender: AnyObject) {
        player.play()
    }
    
    @IBAction func fastForward(sender: AnyObject) {
        player.fastForward(Constants.AudioPlayer_Step)
    }
    
    @IBAction func next(sender: AnyObject) {
    }
    
    // MUST be called before use the miniplayer
    func setupMiniPlayer() {
        player.delegate = self
        
        if let feedItem = player.feedItem {
            if let data = feedItem.feed?.iTunesImage {
                feedItemImageView.image = UIImage(data: data)
            }
        }
        updatePlayButton()
        
        if let currentProgression = player.currentItemProgression, duration = player.currentItemDuration {
            progressView.progress = Float(currentProgression / duration)
        }
        feedItemTitle.text = player.feedItem?.title
        
        feedItemImageView.userInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(MiniPlayerToolbar.imageTapped))
        feedItemImageView.addGestureRecognizer(tapRecognizer)
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
        updatePlayButton()
    }
    
    func updatePlayButton() {
        if player.state == .Playing {
            playButton.setImage(pauseImage, forState: .Normal)
        } else {
            playButton.setImage(playImage, forState: .Normal)
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
}
