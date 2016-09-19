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
    
    func rebuildItemList() {
        if let currentItem = currentItem, currentItemIndexInQueue = currentItemIndexInQueue, items = items {
            if mode.contains(.Shuffle) {
                var audioItems = items.map {  $0 }
                if mode.contains(.Shuffle) {
                    audioItems.removeAtIndex(currentItemIndexInQueue)
                    
                    audioItems = audioItems.shuffled()
                    audioItems.insert(currentItem, atIndex: 0)
                    
                    playItems(audioItems)
                }
            } else {
                if let feed = self.feed {
                    
                    var startIndex = 0
                    var audioItems = [AudioItem]()
                    var index = 0
                    if let items = feed.items?.array as? [FeedItem] {
                        for item in items {
                            if let enclosureURL = item.enclosureURL {
                                if let fileURL = NSURL(string: enclosureURL) {
                                    audioItems.append( AudioItem(mediumQualitySoundURL: fileURL)! )
                                    
                                    if currentItem.mediumQualityURL.URL.absoluteString == fileURL.absoluteString {
                                        startIndex = index
                                        Logger.log.debug("Start index is \(startIndex)")
                                    }
                                }
                            }
                            index += 1
                        }
                    }
                    playItems(audioItems, startAtIndex: startIndex)
                }
            }
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