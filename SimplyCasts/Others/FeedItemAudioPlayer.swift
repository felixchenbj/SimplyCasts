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
    }
    
    weak var feed: Feed?
    
    func initDataAndStartToPlay(feed: Feed, startIndex: Int = 0) {
        guard self.feed != feed else {
            return
        }
        self.feed = feed
        
        var audioItems = [AudioItem]()
        
        if let items = feed.items?.array as? [FeedItem] {
            for item in items {
                if let enclosureURL = item.enclosureURL {
                    if let fileURL = NSURL(string: enclosureURL) {
                        audioItems.append( AudioItem(mediumQualitySoundURL: fileURL)! )
                    }
                }
            }
        }
        
        if mode.contains(.Shuffle) {
            addItemsToQueue(audioItems)
        } else {
            playItems(audioItems, startAtIndex: startIndex)
        }
    }

    func getCurrentFeedItem() -> FeedItem?{
        if let currentItemIndexInQueue = currentItemIndexInQueue {
            return feed?.feedItemAtIndex(currentItemIndexInQueue)
        } else {
            return nil
        }
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
private extension Array {
    func shuffled() -> [Element] {
        return sort { e1, e2 in
            random() % 2 == 0
        }
    }
}