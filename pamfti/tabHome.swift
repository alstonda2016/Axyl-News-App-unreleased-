//
//  tabHome.swift
//  pamfti
//
//  Created by David A on 11/21/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


class tabHome: UITabBarController, UITabBarControllerDelegate, UIPopoverControllerDelegate {
    var isLocEnabled = false

    var ref:DatabaseReference?
    var isFirstTimeAccount:Bool?
    var userFullName = ""
    var userID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.delegate = self
        
        
        userFullName = (Auth.auth().currentUser?.displayName!)!
        userID = (Auth.auth().currentUser?.uid)!
        
      
        


        
        let user = Auth.auth().currentUser
        ref = Database.database().reference()
        //self.tabBarController?.delegate = self
        
        print("AAAAAAAAAA")
        print(self.description)
        print(self.description)
        print(self.description)
        print(self.description)
        print(self.description)
        print(self.description)
        print(self.description)
        print("AAAAAAAAAA")
        
        
        //    8/13
        //IF ERRORS OCCUR (EXTRA TAB APPEARS), MOVE THIS TO VIEWDIDLOAD
        
        self.ref?.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            if let item = snapshot.value as? [String: AnyObject]{
                
                
                
                var isValidPost:Bool = true
                var uName:String? = ""
                var uRating:CLong? = 0
                var userFullName:String? = ""
                var userAllowedAccessDate:CLong? = 0
                var userAccessLevel:String? = ""
                var userNecessaryAlertType:String? = ""
                var userNecessaryAlertType2:String? = ""
                var userStrikes:Int? = 0
                var showUserStrikeAlert:Bool? = false
                
                /*
                 uName = item["userName"]
                 uRating = item["userRating"]
                 userFullName = item["userFullName"]
                 userAllowedAccessDate = item["userAllowedAccessDate"]
                 userAccessLevel = item["userAccessLevel"]
                 userNecessaryAlertType = item["userNecessaryAlertType"]
                 userNecessaryAlertType2 = item["userNecessaryAlertType2"]
                 userStrikes = item["userStrikes"]
                 
                 showUserStrikeAlert = item["showUserStrikeAlert"]
                 
                 
                 */
                
                
                
                
                if(item["userStrikes"] == nil){
                }
                else{
                    
                    userStrikes = item["userStrikes"] as! Int
                    var uStrikes = 0
                    //let uStrikes = item["userStrikes"] as! Int
                    
                    if item["userStrikes"] is Int{
                        //everything about the value works.
                        let uStrikes = item["userStrikes"] as! Int
                        userStrikes = item["userStrikes"] as! Int
                        
                    }
                    else{
                        uStrikes = 0
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                    
                    
                    // let uStrikes = userStrikes as! Int
                    
                    print("STRIKES")
                    print("STRIKES")
                    print("STRIKES")
                    print("STRIKES")
                    print(uStrikes.description)
                    print("STRIKES")
                    print("STRIKES")
                    print("STRIKES")
                    
                    //bannedUser
                    if(uStrikes > 2){
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "bannedUserViewController")
                        self.present(newViewController, animated: true, completion: nil)
                        
                    }
                    
                    
                }
                
                
                
                     /*
                
                if(item["userName"] == nil){
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "usernameCreateViewController")
                    self.present(newViewController, animated: true, completion: nil)
                    
                }
                else{
                    var uName = ""
                    if item["userName"] is String{
                        //everything about the value works.
                        uName = item["userName"] as! String
                        
                        
                    }
                    else{uName = ""}
                    
                    
                    UserDefaults.standard.set(uName, forKey: "Username")
                }
                
             if(   isFirstTimeUserVar.isFirstTimeUser == true){
                 
                 
                 let popOverVC = self.storyboard?.instantiateViewController(withIdentifier: "newUserTutorialViewController") as! newUserTutorialViewController
                 self.addChildViewController(popOverVC)
                 // popOverVC.delegate = self
                 popOverVC.view.frame = self.view.frame
                 self.view.addSubview(popOverVC.view)
                 
                 
                 
                 
                 }
                 */
                
                
                if(item["userRating"] == nil){
                    UserDefaults.standard.set(0, forKey: "userRating")
                    
                    
                    
                }
                else{
                    var uRating = 0
                    if item["userRating"] is CLong{
                        //everything about the value works.
                        uRating = item["userRating"] as! CLong
                        
                        
                    }
                    
                    UserDefaults.standard.set(uRating, forKey: "userRating")
                    
                }
                
                
                
                if(item["userAllowedAccessDate"] == nil){
                    
                    UserDefaults.standard.set(0, forKey: "userAllowedAccessDate")
                    
                    
                }
                else{
                    var userAllowedAccessDate = 0
                    if item["userAllowedAccessDate"] is CLong{
                        //everything about the value works.
                        userAllowedAccessDate = item["userAllowedAccessDate"] as! CLong
                        
                        
                    }
                    
                    
                    UserDefaults.standard.set(userAllowedAccessDate, forKey: "userAllowedAccessDate")
                    
                }
                
                
                
                if(item["userAccessLevel"] != nil){
                    //If access level exists in database
                    
                    var unameString = "NORMAL"
                    userAccessLevel = "NORMAL"
                    if item["userAccessLevel"] is String{
                        //everything about the value works.
                        userAccessLevel = item["userAccessLevel"] as! String
                        unameString = userAccessLevel as! String
                        
                        
                    }
                    
                    
                    
                    
                    else{
                        //if value isn't an offer, set value
                        //UserDefaults.standard.set("normal", forKey: "userAccessLevel")
                        UserDefaults.standard.set(userAccessLevel as! String, forKey: "userAccessLevel")
                        
                        
                        
                        
                        
                        
                    }
                }
                else{
                    //If accesslevel doesn't exist, set to normal
                    self.ref?.child("Users").child(self.userID).child("userAccessLevel").setValue("NORMAL")
                    UserDefaults.standard.set("NORMAL", forKey: "userAccessLevel")
                    
                }
                
                
                
            }
            
        })
        
        
        
        
        
        
        
        /*
         ref?.child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
         
         if snapshot.exists(){
         
         print("true rooms exist")
         
         let uName = snapshot.value as! String
         print(uName)
         print(uName)
         print(uName)
         print(uName)
         print(uName)
         print(uName)
         print(uName)
         
         UserDefaults.standard.set(uName, forKey: "WaiveUsername")
         
         /*
         - Enable create button here
         Stuff like the upvote/downvote features SHOULD already have a username attached
         */
         
         
         }else{
         
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let newViewController = storyBoard.instantiateViewController(withIdentifier: "usernameCreateViewController")
         self.present(newViewController, animated: true, completion: nil)            }
         
         
         })
         
         
         
         */
        
        
        
        
        
        //UITabBar.appearance().layer.borderWidth = 1
        //UITabBar.appearance().clipsToBounds = true
        //self.selectedIndex = 0;
        //UITabBar.appearance().layer.borderColor = #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1)
        
        
        self.tabBarController?.hidesBottomBarWhenPushed = true
        
        
        
        
        
        // setupMiddleButton()
        
    
        
        
        
        print("BBBBBBBBB")
        print(self.description)
        print(self.description)
        print(self.description)
        print(self.description)
        print(self.description)
        print(self.description)
        print(self.description)
        print("BBBBBBBBB")
        
        
        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        
        
    
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    

    

    
}
