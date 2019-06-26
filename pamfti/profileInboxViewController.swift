//
//  profileInboxViewController.swift
//  pamfti
//
//  Created by David A on 11/21/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class profileInboxViewController: UIViewController ,  UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionInbox: UICollectionView!

    var passedID:String!
    var passedTopic:topicObject!
    
    var userID = ""
    
    var handle: DatabaseHandle?
    var isEmpty:Bool = false

    
    
    var ref:DatabaseReference?
    
    var lstArticles:[proposedArticleObject] = []
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width:  self.collectionInbox.frame.width * 0.98 , height:  181)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isEmpty){
            return 1
        }
        return lstArticles.count    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if(isEmpty){
            
            let cell:profileInboxCollectionViewCellEMPTY = collectionView.dequeueReusableCell(withReuseIdentifier: "profileInboxCollectionViewCellEMPTY", for: indexPath) as! profileInboxCollectionViewCellEMPTY
            
            
            
            
            return cell;
            
        }
        else{
        
        
        
        let cell:profileInboxCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileInboxCollectionViewCell", for: indexPath) as! profileInboxCollectionViewCell
        
    /*    let rB =  lstArticles[indexPath.row].ratingBlend
        let rC =  lstArticles[indexPath.row].replyCount
        let postText =  lstArticles[indexPath.row].postText
            */
        cell.lblInbox.text = lstArticles[indexPath.row].proposalStatus

      //  let tt =  "Topic: " + lstArticles[indexPath.row].topicObject.topicName
        cell.lblDate.text = lstArticles[indexPath.row].proposalTopicName
        
        /*
        if(rB > -1)
        {
            let dislikes = rC - rB
        
        cell.lblTotalPoints.text = "+" + rB.description
        cell.lblUpPoints.text = rB.description + " likes"
        cell.lblDownPoints.text = dislikes.description + " dislikes"

        }
        else{
            
            let likes = rC + rB
            
            // - symbol isnt necessary. it already has it
            cell.lblTotalPoints.text =  rB.description
            cell.lblUpPoints.text = likes.description + " likes"
            cell.lblDownPoints.text = rB.description + " dislikes"

            
            
        }
        
        */
        
        
        return cell
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        ref = Database.database().reference()
        
        userID = (Auth.auth().currentUser?.uid)!
        
        var strHistoryDate:CLong = 0
        var strHistoryDateInverse:CLong = 0
        
        var article_Object:articleObject!
        

        ref?.child("PROPOSED_ARTICLES_USER_HISTORY").child(userID).observe(DataEventType.value, with: { (snapshot) in
            
            
            if(snapshot.exists()){
                
                
                self.isEmpty = false
                
                
                
                
            }
            else{
                self.isEmpty = true
                
            }
            
            
            
        })
        
        
        ref?.child("PROPOSED_ARTICLES_USER_HISTORY").child(userID).queryLimited(toLast: 350).observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
                
                
                
               /*
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

                */
                
                
                //    let postID = dict["name"] as! String
                let strArticleURL = dict["strArticleURL"] as! String
                let proposalAuthorID = dict["proposalAuthorID"] as! String
                let proposalAuthorName = dict["proposalAuthorName"] as! String
                let postTime = dict["proposalTime"] as! CLong
                let postTimeInverse = dict["proposalTimeInverse"] as! CLong
                let rundownCount = dict["rundownCount"] as! Int
                
                
                let strRundownPoint1 = dict["strRundownPoint1"] as! String
                let strRundownPoint2 = dict["strRundownPoint2"] as! String
                let strRundownPoint3 = dict["strRundownPoint3"] as! String
                let strRundownPoint4 = dict["strRundownPoint4"] as! String
                let strRundownPoint5 = dict["strRundownPoint5"] as! String
                
                
                let strArticlePublisher = dict["strArticlePublisher"] as! String
                let strArticleTitle = dict["strArticleTitle"] as! String
                let postID = dict["postID"] as! String
                
                let proposalTopicName = dict["proposalTopicName"] as! String
                let proposalTopicID = dict["proposalTopicID"] as! String
                
                let proposalStatus = dict["proposalStatus"] as! String
                let proposalStatusDescription = dict["proposalStatusDescription"] as! String

                
            
                
                var topicCategory = ""
                
                var topicID = ""
                
              
                
                
                
        
                
                
                
                /*
                var inboxObject = profileInboxObject(PostText:postText,
                                                        PostID:postID ,
                                                        
                                                        PostTime:postTime ,
                                                        PostTimeInverse:postTimeInverse ,
                                                        ReplyCount:replyCount ,
                                                        RatingBlend:ratingBlend,  PostFlaggedStatus:postIsFlagged, OriginalTopicID: originalTopicID, UpCount:upCount, DownCount:downCount,TopicObject: top )
            
            */
                
            var proposalObj = proposedArticleObject(StrArticleURL: strArticleURL, ProposalAuthorID: proposalAuthorID, ProposalAuthorName: proposalAuthorName, proposalTime: postTime, RundownCount: rundownCount, StrRundownPoint1: strRundownPoint1, StrRundownPoint2: strRundownPoint2, StrRundownPoint3: strRundownPoint3, StrRundownPoint4: strRundownPoint4, StrRundownPoint5: strRundownPoint5, strArticlePublisher: strArticlePublisher, strArticleTitle: strArticleTitle, PostID: postID, proposalTopicName: proposalTopicName, proposalTopicID: proposalTopicID, ProposalStatus: proposalStatus, ProposalStatusDescription: proposalStatusDescription)
                
                
                
                
                
                
                
                
                self.lstArticles.append(proposalObj)
                //self.collectionComments.reloadData()
                self.collectionInbox?.reloadData()
                
                
                
                
            }
        })
        
        
        
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
