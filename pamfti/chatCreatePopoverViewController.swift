//
//  chatCreatePopoverViewController.swift
//  pamfti
//
//  Created by David A on 11/20/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase

class chatCreatePopoverViewController: UIViewController,  UITextViewDelegate {
  
    var postID:String!
    var univName:String!
    var creDate:String = ""
    var creNum:Int = 0
    var eventTypeNum = 0
    var userName: String!
    var userFullName = ""
    var userID = ""
    
    @IBOutlet weak var btnSendMessage: UIButton!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var txtUserEntry: UITextView!
    var postType = "standard"
    var passedTopic:topicObject?
    var passedTopicID:String?

    
    var postDelegate:chatCustomDelegate?
    
    
    var handle: DatabaseHandle?
    var ref:DatabaseReference?
    
    @IBAction func btnClose(_ sender: Any) {
        removeAnimate();
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = txtUserEntry.text ?? ""
        
        
        let isDeleting = (range.length > 0) && text.isEmpty
        if isDeleting == true {
            // trim last character
            // you may want to drop based on the range.length, however you'll need
            // to determine if the character is an emoji and adjust the number of characters
            // as range.length returns a length > 1 for emojis
            let newStr = String(currentText.dropLast())
            return newStr.count <= 120
            
        }
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 120 // Change limit based on your requirement.
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        self.showAnimate()
        
        ref = Database.database().reference()
        
        
        if let univName = UserDefaults.standard.object(forKey: "Username") as? String{
            userName = univName
        }
        
      /*  userFullName = (Auth.auth().currentUser?.displayName!)!
        userID = (Auth.auth().currentUser?.uid)!
        */
        
      
        userFullName = (Auth.auth().currentUser?.displayName!)!
        userID = (Auth.auth().currentUser?.uid)!
        userName = (Auth.auth().currentUser?.displayName!)!
        
        txtUserEntry.becomeFirstResponder()
        
        btnSendMessage.contentHorizontalAlignment = .right
        btnSendMessage.addTarget(self, action: #selector(sendPost), for: .touchUpInside)
        
        viewPopup.layer.cornerRadius = 5
        viewPopup.clipsToBounds = true
        viewPopup.layer.borderWidth = 1
        // viewPopup.layer.borderColor = #colorLiteral(red: 0.9750739932, green: 0.9750967622, blue: 0.9750844836, alpha: 1)
        viewPopup.layer.borderColor =  #colorLiteral(red: 0.3278279901, green: 0.3278364539, blue: 0.3278318942, alpha: 1)

    }
    

    @objc func sendPost() {
        

        
        if( self.txtUserEntry.text?.isEmpty)!{
            
            let alert = UIAlertController(title: "", message: "Enter text", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
                // self.canvas.image = nil
            }
            
            alert.addAction(okAction)
            present(alert, animated: true, completion:nil)
            
        }
       /* else if(!checkForTerms(postText: txtUserEntry.text!)){
            
            
        }
            */
            
        else{
            
            
            let postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
            
            let post1Ref = ref?.childByAutoId()
            let postID = (post1Ref?.key)!
            
            
            
            
            
            
            
            
            let post:[String : AnyObject] = [
                //"eventTitle":txtEventName.text! as AnyObject,
                "postCreatorID":userID as AnyObject,
                "postText":txtUserEntry.text as AnyObject,
                "postID":postID as AnyObject,
              
                 "postTime":postTime as AnyObject,
                 "postTimeInverse":-postTime as AnyObject,
                 "postUserName":userName as AnyObject,
                 "postType":"CHAT_IOS" as AnyObject,
                 "postDescription":"NONE" as AnyObject,
                 "creatorName":userFullName as AnyObject,
                 "ratingBlend":0 as AnyObject,
                 "textCount":0 as AnyObject,
                 "replyCount":0 as AnyObject,

                
                 "postVisibilityStartTime":0 as AnyObject,
                 "postVisibilityEndTime":0 as AnyObject,
                 "postIsActive":true as AnyObject,
                 "postIsFlagged":false as AnyObject,
                 "originalTopicID":passedTopic?.topicID as AnyObject,
                 "chatVersionType":1 as AnyObject,
                "postMediaLink":"none" as AnyObject


                
            
          
       
                
            ]
            
            
            let inboxPost:[String : AnyObject] = [
                //"eventTitle":txtEventName.text! as AnyObject,
                "postCreatorID":userID as AnyObject,
                "postText":txtUserEntry.text as AnyObject,
                "postID":postID as AnyObject,
                
                "postTime":postTime as AnyObject,
                "postTimeInverse":-postTime as AnyObject,
                "postUserName":userName as AnyObject,
                "postType":"CHAT_IOS" as AnyObject,
                "postDescription":"NONE" as AnyObject,
                "creatorName":userFullName as AnyObject,
                "ratingBlend":0 as AnyObject,
                "textCount":0 as AnyObject,
                "replyCount":0 as AnyObject,
                "upCount":0 as AnyObject,
                "downCount":0 as AnyObject,
                
                "postVisibilityStartTime":0 as AnyObject,
                "postVisibilityEndTime":0 as AnyObject,
                "postIsActive":true as AnyObject,
                "postIsFlagged":false as AnyObject,
                "originalTopicID":passedTopic?.topicID as AnyObject,
                "chatVersionType":1 as AnyObject,
                "postMediaLink":"none" as AnyObject,
                "topicObject":passedTopic?.toFBObject() as AnyObject,

                
                
                
                
                
                
                
            ]
            
            self.view.endEditing(true);
            
            //ref?.child("b").childByAutoId().setValue("yo")
            txtUserEntry.text = ""
            
            
            
            var tID = passedTopic?.topicID.description
            // ref?.child("Users").child((passedObject?.postCreatorID)!).child("POSTS").child((passedObject?.postID)!).child("CHATS").child(postID).setValue(post)
            ref?.child("CHATS").child(tID!).child(postID).setValue(post)
           // ref?.child("USER_CHAT_CREATE_HISTORY").child(userID).child(postID).setValue(inboxPost)

            // self.collectionTexts.reloadData()
            
            self.postDelegate?.reloadChatCollectionview()
            
            removeAnimate()
            
            
        }
        
    }
    
    
 
    
    
    
    
    func checkForTerms(postText: String)->Bool{
        
        var myStringArr = postText.lowercased().components(separatedBy: " ")
        
        var elements = ["obama", "trump", "suicide", "kill", "9/11", "clinton", "nigger", "niggers", "jews", "blacks", "shoot", "nigga", "death", "cunt", "republican", "democrat", "liberal", "conservative"]
        
        var isValid = true
        var bannedWordString:String
        
        
        for item in myStringArr {
            // Do this
            
            if elements.contains(item) {
                print("Array contains 3")
                
                isValid = false
                bannedWordString = item
                print("word: " + item)
                
                
                
                let refreshAlert = UIAlertController(title: "Banned Word", message: "Do not use: " + bannedWordString, preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                    return isValid
                    
                }))
                
                
                present(refreshAlert, animated: true, completion: nil)
                
                
                
                
                
            }
            
        }
        
        print("isValid: " + isValid.description)
        
        
        return isValid
    }
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    

}
