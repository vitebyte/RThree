//
//  FeedInfo+CoreDataClass.swift
//
//
//  Created by Narender Kumar on 14/04/17.
//
//

import Foundation
import CoreData

public class FeedInfo: NSManagedObject {
    
    //MARK: - Created functions for feed data
    func createFeedInfo(feed: Feed) {
        convertFeedToInfo(feed: feed)
    }
    
    func updateFeedInfo(feed: Feed) {
        convertFeedToInfo(feed: feed)
    }
    
    fileprivate func convertFeedToInfo(feed: Feed) {
        
        id = Int32(feed.feedsId!)
        title = feed.title
        desc = feed.content
        imageUrl = feed.feedsImage
        videoUrl = feed.feedsVideo
        isMarkedRead = feed.ackFlag!
        questionFlag = feed.questionFlag!
        dateTime = Helper.dateFrom(strDate: feed.createdOn!, format: "")
        userId = Int32(UserManager.shared.activeUser.userId!)
        interval = Int32(feed.feedsId!) //FIXME : remove feedId and use interval
    }
    
}
