//
//  forumChatObject.swift
//  pamfti
//
//  Created by David A on 11/19/18.
//  Copyright © 2018 David A. All rights reserved.
//

import Foundation
class forumChatObject {
    var chatName:String = ""
    var chatID:String = ""
    var chatCreatorID:String = ""

    var strChatURL:String = ""
    var strChatPicSource:String = ""
    var chatCreationTime:CLong = 0
    var chatCreationTimeInverse:CLong = 0
    var chatTextCount:Int = 0
    var chatTextCountInverse:Int = 0

    
    
    
    
    
    
    
    //Normal Post
    init( ChatName:String,
          StrChatPicSource:String,
          ChatCreatorID:String,
          StrChatURL:String,
          ChatID:String,
          
          ChatTextCount:CLong,
          ChatCreationTimeInverse:CLong,
          
          ChatCreationTime:Int,
        ChatTextCountInverse:Int

        ) {
        self.chatName = ChatName
        self.strChatPicSource = StrChatPicSource
        self.chatCreatorID = ChatCreatorID
        self.strChatURL = StrChatURL
        
        self.chatID = ChatID
        self.chatTextCount = ChatTextCount
        self.chatCreationTimeInverse = ChatCreationTimeInverse
        self.chatCreationTime = ChatCreationTime
        self.chatTextCountInverse = ChatTextCountInverse

        
    }
    
    
    
    func toFBObject() -> Any {
        return [
            "chatName":chatName as AnyObject,
            "chatID":chatID as AnyObject,
            "chatCreatorID":chatCreatorID as AnyObject,
            "strChatURL":strChatURL as AnyObject,
            
            "strChatPicSource":strChatPicSource as AnyObject,
            "chatCreationTime": chatCreationTime as AnyObject,
            "chatCreationTimeInverse": chatCreationTimeInverse as AnyObject,
            "chatTextCount": chatTextCount as AnyObject,
            "chatTextCountInverse": chatTextCountInverse as AnyObject



        ]
        
    }
 
    
}
