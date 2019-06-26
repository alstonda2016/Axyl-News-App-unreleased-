//
//  profileInboxObject.swift
//  pamfti
//
//  Created by David A on 11/22/18.
//  Copyright © 2018 David A. All rights reserved.
//

import Foundation
class profileInboxObject {
    
    
    var postIsActive:Bool = true
    var postCreatorID:String = ""
    var postText:String = ""
    var postID:String = ""
    
    var postTime:CLong = 0
    var postTimeInverse:CLong = 0
    var postUserName:String = ""
    var postType:String = ""
    var postDescription:String = ""
    var creatorName:String = ""
    var ratingBlend:Int = 0
    var postVisibilityStartTime:CLong = 0
    var postVisibilityEndTime:CLong = 0
    var textCount: Int = 0
    var replyCount: Int = 0
    var postIsFlagged:Bool = false
    var upCount: Int = 0
    var downCount: Int = 0
    var topicObject:topicObject!

    
    var postMediaLink:String = "none"
    //CHatVersionType MUST be the same type as the postVersionType
    var chatVersionType: Int = 1
    var originalTopicID:String = ""
    
    
    
    //INBOX Post
    //postV1
    init(
          PostText:String,
          PostID:String ,
          
          PostTime:CLong ,
          PostTimeInverse:CLong ,
         ReplyCount:Int ,
         RatingBlend:Int,  PostFlaggedStatus:Bool, OriginalTopicID: String, UpCount:Int, DownCount:Int, TopicObject:topicObject ) {
        self.postText = PostText
        self.postID = PostID
        self.postTime = PostTime
        self.postTimeInverse = PostTimeInverse
 
        self.ratingBlend = RatingBlend
        self.replyCount = ReplyCount

        self.postIsFlagged = PostFlaggedStatus
        self.originalTopicID = OriginalTopicID
        
        self.upCount = UpCount
        self.downCount = DownCount
        self.topicObject = TopicObject
        
        
        
    }
    
    //Normal Post
    //postV1
    init( PostCreatorID:String ,
          PostText:String,
          PostID:String ,
          
          PostTime:CLong ,
          PostTimeInverse:CLong ,
          PostUserName:String ,
          PostType:String ,
          PostDESCRIPTION:String,
          CreatorName:String,  RatingBlend:Int, PostVisStart:CLong, PostVisEnd:CLong, TextCount:Int,  PostFlaggedStatus:Bool, OriginalTopicID: String, UpCount:Int, DownCount:Int, TopicObject:topicObject ) {
        self.postCreatorID = PostCreatorID
        self.postText = PostText
        self.postID = PostID
        self.postTime = PostTime
        self.postTimeInverse = PostTimeInverse
        self.postUserName = PostUserName
        self.postType = PostType
        self.postDescription = PostDESCRIPTION
        self.creatorName = CreatorName
        self.ratingBlend = RatingBlend
        self.postVisibilityStartTime = PostVisStart
        self.postVisibilityEndTime =  PostVisEnd
        self.textCount = TextCount
        self.postIsFlagged = PostFlaggedStatus
        self.originalTopicID = OriginalTopicID
        
        self.upCount = UpCount
        self.downCount = DownCount
        self.topicObject = TopicObject

        
        
    }
    
    func toFBObject() -> Any {
        return [
            "postIsActive":postIsActive as AnyObject,
            
            "postCreatorID":postCreatorID as AnyObject,
            "postText":postText as AnyObject,
            "postID":postID as AnyObject,
            
            "postTime":postTime as AnyObject,
            "postTimeInverse":postTimeInverse as AnyObject,
            "postUserName":postUserName as AnyObject,
            "postType":postType as AnyObject,
            "postDescription":postDescription as AnyObject,
            "creatorName":creatorName as AnyObject,
            "ratingBlend":ratingBlend as AnyObject,
            "postVisibilityStartTime":postVisibilityStartTime as AnyObject,
            "postVisibilityEndTime":postVisibilityEndTime as AnyObject,
            "textCount":textCount as AnyObject,
            "replyCount":replyCount as AnyObject,
            "postMediaLink":postMediaLink as AnyObject,
            "chatVersionType":chatVersionType as AnyObject,
            "originalTopicID":originalTopicID as AnyObject,
            "upCount":upCount as AnyObject,
            "downCount":downCount as AnyObject,
            "topicObject":topicObject as AnyObject,

            "postIsFlagged":postIsFlagged as AnyObject
            
            
            ] as Any
        
        
        
        
        
        
    }
    
    
    
}
