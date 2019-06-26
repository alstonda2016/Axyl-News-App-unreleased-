//
//  reportChatObject.swift
//  pamfti
//
//  Created by David A on 11/22/18.
//  Copyright © 2018 David A. All rights reserved.
//

import Foundation
class reportChatObject {
    
    var postReportReason:Int = 0
    var postObject:topicChatPostObject?
    var postReporterID:String?
    var postIsFlagged:Bool?

    
    
    
    
    //Normal Post
    init( PostReportReason:Int ,
          PostObject:topicChatPostObject,PostReporterID:String, PostIsFlagged:Bool  ) {
        self.postReportReason = PostReportReason
        self.postObject = PostObject
        self.postReporterID = PostReporterID
        self.postIsFlagged = PostIsFlagged

    }
    
    func toFBObject() -> Any {
        return [
            "postReportReason":postReportReason as AnyObject,
            "postReporterID":postReporterID as AnyObject,
            "postIsFlagged":postIsFlagged as AnyObject,
            "postObject": postObject!.toFBObject() as AnyObject] as Any
        
        
    }
    
    
    
    
}
