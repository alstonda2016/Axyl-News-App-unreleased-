//
//  historyArticleObject.swift
//  pamfti
//
//  Created by David A on 11/21/18.
//  Copyright © 2018 David A. All rights reserved.
//

import Foundation

class historyArticleObject {
    var strHistoryDate:CLong = 0
    var strHistoryDateInverse:CLong = 0

    var article_Object:articleObject!

    
    
    
    
    
    
    //Normal Post
    init(
        StrHistoryDate:CLong,
        StrHistoryDateInverse:CLong,
        Article_Object:articleObject) {
        self.strHistoryDate = StrHistoryDate
        self.strHistoryDateInverse = StrHistoryDateInverse
        self.article_Object = Article_Object
   
        
        
    }
    
    
    
    func toFBObject() -> Any {
        return [
            "strHistoryDate":strHistoryDate as AnyObject,
            "strHistoryDateInverse":strHistoryDateInverse as AnyObject,
            "article_Object": article_Object.toFBObject() as AnyObject,
     
            
            
        ]
        
    }
    
    
    
    
}
