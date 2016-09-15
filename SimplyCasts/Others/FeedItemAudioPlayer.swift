//
//  FeedItemAudioPlayer.swift
//  SimplyCasts
//
//  Created by felix on 9/14/16.
//  Copyright © 2016 Felix Chen. All rights reserved.
//

import AVFoundation
import KDEAudioPlayer

class FeedItemAudioPlayer: AudioPlayer {
    
    static var sharedAudioPlayer = FeedItemAudioPlayer()
    
    private var subscribedFeedItemManager: SubscribedFeedItemManager?
    private override init() {
        super.init()
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            Logger.log.error(error.localizedDescription)
        }
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    weak var feedItem: FeedItem? {
        willSet {
            if feedItem != newValue {
                stop()
            }
        }
        didSet {
            if let feedItem = feedItem {
                if let feed = feedItem.feed {
                    subscribedFeedItemManager = SubscribedFeedItemManager(feed: feed)
                    
                    subscribedFeedItemManager?.executeSearch()
                }
            }
        }
    }
    
    func play() {
        if let feedItem = feedItem {
            stop()
            if let fileURL = NSURL(string: feedItem.enclosureURL!) {
                let item = AudioItem(mediumQualitySoundURL: fileURL)
                playItem(item!)
            }
        }
    }
    
    func playNext() -> FeedItem? {
        guard let feedItem = feedItem else {
            return nil
        }
        if let subscribedFeedItemManager = subscribedFeedItemManager {
            
            let count = subscribedFeedItemManager.fetchedObjectsCount()
            if let index = subscribedFeedItemManager.indexOfObject(feedItem) {
                if index.row < count - 1 {
                    let nextIndex = NSIndexPath(forRow: index.row + 1, inSection: index.section)
                    
                    let next = subscribedFeedItemManager.getObjectAtIndex(nextIndex) as? FeedItem
                    self.feedItem = next
                    play()
                    return next
                }
            }
        }
        return nil
    }

    func playPrevious() -> FeedItem? {
        guard let feedItem = feedItem else {
            return nil
        }
        if let subscribedFeedItemManager = subscribedFeedItemManager {
            if let index = subscribedFeedItemManager.indexOfObject(feedItem) {
                if index.row > 0 {
                    let previousIndex = NSIndexPath(forRow: index.row - 1, inSection: index.section)
                    let previous = subscribedFeedItemManager.getObjectAtIndex(previousIndex) as? FeedItem
                    self.feedItem = previous
                    play()
                    return previous
                }
            }
        }
        return nil
    }
    
    func fastForward(seconds: Int) {
        if let currentItemProgression = currentItemProgression {
            seekToTime(currentItemProgression + NSTimeInterval(seconds))
        }
    }
    
    func rewind(seconds: Int) {
        if let currentItemProgression = currentItemProgression {
            seekToTime(currentItemProgression - NSTimeInterval(seconds))
        }
    }
}
