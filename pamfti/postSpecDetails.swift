//
//  postSpecDetails.swift
//  pamfti
//
//  Created by David A on 11/20/18.
//  Copyright © 2018 David A. All rights reserved.
//

import Foundation
class postSpecDetails{
    
    
    
    var isActive:Bool = true
    var hasBeenCleared:Bool = false
    var postTime:CLong = 0
    var postRemovalTime:CLong = 0
    var postRemovalReason:Int = 0
    var postRemover:String = ""
    
    
    
    
    init( IsActive:Bool, HasBeenCleared:Bool,PostTime:CLong,
          PostRemovalTime:CLong, PostRemovalReason: Int, PostRemover:String
        ) {
        self.isActive = IsActive
        self.hasBeenCleared = HasBeenCleared
        self.postTime = PostTime
        self.postRemovalTime = PostRemovalTime
        self.postRemovalReason = PostRemovalReason
        self.postRemover = PostRemover
        
    }
    
    func initWithDict(aDict: [String: Any]) {
        
        
        self.isActive = aDict["isActive"] as! Bool
        self.hasBeenCleared = aDict["hasBeenCleared"] as! Bool
        self.postTime = aDict["postTime"] as! CLong
        self.postRemovalTime = aDict["postRemovalTime"] as! CLong
        self.postRemovalReason = aDict["postRemovalReason"] as! Int
        self.postRemover = aDict["postRemover"] as! String
        
    }
    func toFBObject() -> Any {
        return [  "isActive":isActive,
                  "hasBeenCleared":hasBeenCleared,
                  "postTime":postTime ,
                  "postRemovalTime":postRemovalTime ,
                  "postRemovalReason":postRemovalReason ,
                  "postRemover":postRemover ,
                  ]as Any
    }
    
    
    
    
}
