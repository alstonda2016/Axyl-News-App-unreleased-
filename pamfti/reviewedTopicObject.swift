//
//  reviewedTopicObject.swift
//  pamfti
//
//  Created by David A on 11/22/18.
//  Copyright © 2018 David A. All rights reserved.
//

import Foundation

class reviewedTopicObject {
    var reviewText:String = ""
    var reviewAuthor:String = ""
    var reviewAuthorName:String = ""
    
    var reviewTime:CLong = 0
    var reviewTimeInverse:CLong = 0

    
    
    
    //Normal Post
    init(
        ReviewText:String,
        ReviewAuthor:String,
        ReviewAuthorName:String,
        
        ReviewTime:CLong
        ) {
        self.reviewText = ReviewText
        self.reviewAuthor = ReviewAuthor
        self.reviewAuthorName = ReviewAuthorName
        
        self.reviewTime = ReviewTime
        self.reviewTimeInverse = -ReviewTime

        
    }
    
    
    
    func toFBObject() -> Any {
        return [
            "reviewText":reviewText as AnyObject,
            "reviewAuthor":reviewAuthor as AnyObject,
            "reviewAuthorName":reviewAuthorName as AnyObject,
            "reviewTime": reviewTime as AnyObject,
            "reviewTimeInverse":reviewTimeInverse as AnyObject

            
            
        ]
        
    }
    
    
    
    
}
