//
//  articleObject.swift
//  pamfti
//
//  Created by David A on 11/18/18.
//  Copyright © 2018 David A. All rights reserved.
//

import Foundation
class articleObject {
    var strURL:String = ""
    var strArticleHeadline:String = ""
    
    var articleBias:Int = 0
    
    var strPicURL:String = ""
    var strPicSource:String = ""
    var articleTopic:String = ""
    var articleID:String = ""
    var strArticleAuthor:String = ""
    var articlePublisher:String = ""
    var articlePicDisplayType:String = "norm"
    
    var articleTime:CLong = 0
    
    var rundownCount:Int = 3

    var strRundownPoint1:String = ""
    var strRundownPoint2:String = ""
    var strRundownPoint3:String = ""
    var strRundownPoint4:String = ""
    var strRundownPoint5:String = ""
    
    var proposalAuthorID:String = ""
    var proposalAuthorName:String = ""
    var isActive:Bool = true

 
    
    
    
    //Normal Post
    init(
        StrURL:String,
        StrArticleHeadline:String,
        StrPicURL:String,
        StrPicSource:String,
        ArticleBias:Int,ArticleTopic:String ,ArticleID:String, StrArticleAuthor:String, ArticleTime:CLong, ArticlePublisher:String, ArticlePicDisplayType:String, RundownCount:Int, StrRundownPoint1:String, StrRundownPoint2:String, StrRundownPoint3:String, StrRundownPoint4:String, StrRundownPoint5:String , ProposalAuthorID:String, ProposalAuthorName:String,IsActive:Bool) {
        self.strURL = StrURL
        self.strPicURL = StrPicURL
        self.strPicSource = StrPicSource
        self.articleBias = ArticleBias
        self.strArticleHeadline = StrArticleHeadline
        self.articleTopic = ArticleTopic
        self.articleID = ArticleID
        self.strArticleAuthor = StrArticleAuthor
        self.articleTime = ArticleTime
        self.articlePublisher = ArticlePublisher
        self.articlePicDisplayType = ArticlePicDisplayType
        
        self.rundownCount = RundownCount
        self.strRundownPoint1 = StrRundownPoint1
        self.strRundownPoint2 = StrRundownPoint2
        self.strRundownPoint3 = StrRundownPoint3
        self.strRundownPoint4 = StrRundownPoint4
        self.strRundownPoint5 = StrRundownPoint5
        self.proposalAuthorID = ProposalAuthorID
        self.proposalAuthorName = ProposalAuthorName
        self.isActive = IsActive


    }
    
    func toFBObject() -> Any {
        return [
            "strURL":strURL as AnyObject,
            "strPicURL":strPicURL as AnyObject,
            "strPicSource": strPicSource as AnyObject,
            "strArticleHeadline": strArticleHeadline as AnyObject,
            "articleBias": articleBias as AnyObject,
            "articleTopic": articleTopic as AnyObject,
            "articleID": articleID as AnyObject,
            "strArticleAuthor": strArticleAuthor as AnyObject,
            "articleTime": articleTime as AnyObject,
            "articlePublisher": articlePublisher as AnyObject,
            "articlePicDisplayType": articlePicDisplayType as AnyObject,
            "rundownCount": rundownCount as AnyObject,
            "strRundownPoint1": strRundownPoint1 as AnyObject,
            "strRundownPoint2": strRundownPoint2 as AnyObject,
            "strRundownPoint3": strRundownPoint3 as AnyObject,
            "strRundownPoint4": strRundownPoint4 as AnyObject,
            "strRundownPoint5": strRundownPoint5 as AnyObject,
            "proposalAuthorID": proposalAuthorID as AnyObject,
            "proposalAuthorName": proposalAuthorName as AnyObject,
            "isActive": isActive as AnyObject

        ]
        
    }
    
    
    
    
}
