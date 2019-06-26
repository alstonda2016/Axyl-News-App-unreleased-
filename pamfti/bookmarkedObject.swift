//
//  bookmarkedObject.swift
//  pamfti
//
//  Created by David A on 11/26/18.
//  Copyright © 2018 David A. All rights reserved.
//

import Foundation
class bookmarkedObject {
    var strBookmarkDate:CLong = 0
    var strBookmarkDateInverse:CLong = 0
    
    var topic_Object:topicObject!
    

    //Normal Post
    init(
        StrBookmarkDate:CLong,
        StrBookmarkDateInverse:CLong,
        Topic_Object:topicObject) {
        self.strBookmarkDate = StrBookmarkDate
        self.strBookmarkDateInverse = StrBookmarkDateInverse
        self.topic_Object = Topic_Object
        
        
        
    }
    
    
    
    func toFBObject() -> Any {
        return [
            "strBookmarkDate":strBookmarkDate as AnyObject,
            "strBookmarkDateInverse":strBookmarkDateInverse as AnyObject,
            "topic_Object": topic_Object.toFBObject() as AnyObject,
            
            
            
        ]
        
    }
    
    
    
    
}
