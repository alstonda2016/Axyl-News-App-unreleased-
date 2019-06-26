//
//  proposedArticleObject.swift
//  pamfti
//
//  Created by David A on 11/18/18.
//  Copyright © 2018 David A. All rights reserved.
//

import Foundation
class proposedArticleObject {
    var strArticleTitle:String = ""
    var strArticlePublisher:String = ""
    var strArticleURL:String = ""

    
    var proposalTopicName:String = ""
    var proposalTopicID:String = ""

    
    //
    var proposalAuthorID:String = ""
    var proposalAuthorName:String = ""

    var proposalTime:CLong = 0
    var proposalTimeInverse:CLong = 0

    var rundownCount:Int = 3
    
    var strRundownPoint1:String = ""
    var strRundownPoint2:String = ""
    var strRundownPoint3:String = ""
    var strRundownPoint4:String = ""
    var strRundownPoint5:String = ""
    var postID:String = ""

 
    var proposalStatus:String = ""
    var proposalStatusDescription:String = ""
    
    
    //Normal Post
    init(
        StrArticleURL:String,
        ProposalAuthorID:String,
        ProposalAuthorName:String,

        proposalTime:CLong, RundownCount:Int, StrRundownPoint1:String, StrRundownPoint2:String, StrRundownPoint3:String, StrRundownPoint4:String, StrRundownPoint5:String , strArticlePublisher:String, strArticleTitle:String, PostID:String, proposalTopicName:String, proposalTopicID:String,
        ProposalStatus:String, ProposalStatusDescription:String
       ) {
        self.strArticleURL = StrArticleURL
        self.proposalAuthorID = ProposalAuthorID
        self.proposalAuthorName = ProposalAuthorName

        self.proposalTime = proposalTime
        self.proposalTimeInverse = -proposalTime
        
        
        self.rundownCount = RundownCount
        self.strRundownPoint1 = StrRundownPoint1
        self.strRundownPoint2 = StrRundownPoint2
        self.strRundownPoint3 = StrRundownPoint3
        self.strRundownPoint4 = StrRundownPoint4
        self.strRundownPoint5 = StrRundownPoint5
        self.strArticlePublisher = strArticlePublisher
        self.strArticleTitle = strArticleTitle
        self.postID = PostID
        self.proposalTopicName = proposalTopicName
        self.proposalTopicID = proposalTopicID

        self.proposalStatus = ProposalStatus
        self.proposalStatusDescription = ProposalStatusDescription
        
    }
    
    
    
    func toFBObject() -> Any {
        return [
            "strArticleURL":strArticleURL as AnyObject,
            "proposalAuthorID":proposalAuthorID as AnyObject,
            "proposalAuthorName":proposalAuthorName as AnyObject,
            "proposalTime": proposalTime as AnyObject,
            "proposalTimeInverse": -proposalTime as AnyObject,
            
            "rundownCount": rundownCount as AnyObject,
            "strRundownPoint1": strRundownPoint1 as AnyObject,
            "strRundownPoint2": strRundownPoint2 as AnyObject,
            "strRundownPoint3": strRundownPoint3 as AnyObject,
            "strRundownPoint4": strRundownPoint4 as AnyObject,
            "strRundownPoint5": strRundownPoint5 as AnyObject,
            "strArticlePublisher": strArticlePublisher as AnyObject,
            "strArticleTitle": strArticleTitle as AnyObject,
            "postID": postID as AnyObject,
            "proposalTopicName": proposalTopicName as AnyObject,
            "proposalTopicID": proposalTopicID as AnyObject,
            "proposalStatus": proposalStatus as AnyObject,
            "proposalStatusDescription": proposalStatusDescription as AnyObject


           
            
        ]
        
    }
    
    
    
    
}
