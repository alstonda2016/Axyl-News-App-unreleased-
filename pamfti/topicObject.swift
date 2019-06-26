//
//  topicObject.swift
//  pamfti
//
//  Created by David A on 11/18/18.
//  Copyright © 2018 David A. All rights reserved.
//

import Foundation
class topicObject {
    var topicName:String = ""
    var topicID:String = ""
    
    var strPicURL:String = ""
    var strPicSource:String = ""
    var topicCategory:String = ""
    
    var topicCreationTime:CLong = 0
    var topicCreationTimeInverse:CLong = 0
    var topicRanking:Int = 0
    var topicClickCount:Int = 0

    var isActive:Bool = true
    var isOngoing:Bool = true

    
    
    
    
    
    
    //Normal Post
    init( TopicName:String,
          StrPicURL:String,
          TopicID:String,
          TopicCreationTime:CLong,
          TopicCreationTimeInverse:CLong,
          
          StrPicSource:String,
          TopicCategory:String,IsActive:Bool, IsOngoing:Bool
        ) {
        self.topicName = TopicName
        self.topicID = TopicID
        self.topicCreationTime = TopicCreationTime
        self.topicCreationTimeInverse = TopicCreationTimeInverse
        
        self.strPicURL = StrPicURL
        self.strPicSource = StrPicSource
        self.topicCategory = TopicCategory
        
        //Just making this 0 cause this constructor isn't currently used when writing to the database
        self.topicRanking = 0
        self.isActive = IsActive
        self.isOngoing = IsOngoing

        
    }
    
    
    
    func toFBObject() -> Any {
        return [
            "topicName":topicName as AnyObject,
            "topicCategory":topicCategory as AnyObject,
            
            "topicID":topicID as AnyObject,
            "topicCreationTime":topicCreationTime as AnyObject,
            "topicCreationTimeInverse":topicCreationTimeInverse as AnyObject,
            
            "topicRanking":topicRanking as AnyObject,

            "strPicURL":strPicURL as AnyObject,
            "strPicSource": strPicSource as AnyObject,
            "isActive": isActive as AnyObject,
            "isOngoing": isOngoing as AnyObject


        ]
        
    }
    
    
    
    
}
