//
//  articleCommentCollectionViewCell.swift
//  pamfti
//
//  Created by David A on 11/20/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol CollectionCellDelegate: class {
    func reportPost(passedChatPost:topicChatPostObject)
}


class articleCommentCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var passedID:String!
    var passedTopic:topicObject!
    var userBoxLikeHistoryList:[String] = []
    var hasRunBottomWithoutAnimationOnce = false

    
    var isBookmarked:Bool = false
    @IBOutlet weak var collectionArticles: UICollectionView!
    var handle: DatabaseHandle?
    var ref:DatabaseReference?
    var userID:String?
    var userFullName:String?
    
    @IBOutlet weak var lblTextCount: UILabel!
    
    
    var delliDelli:aCustomDelegate?
    weak var delegate: CollectionCellDelegate?

    
    @IBOutlet weak var viewMakePost: UIView!
    
    

    var postChatList:[topicChatPostObject] = []
    @IBOutlet weak var txtEnterText: UITextField!
    
    @IBOutlet weak var btnGoToChatt: UIButton!
    func setupViews() {
        commentCollection.delegate = self
        commentCollection.dataSource = self
    }
    
    func runn(PPostChatList:[topicChatPostObject], PassedTopic:topicObject, likeList:[String] ) -> Void {
        
        ref = Database.database().reference()
        
        userID = (Auth.auth().currentUser?.uid)!
        userFullName = (Auth.auth().currentUser?.displayName)!
        
        postChatList = PPostChatList
        passedTopic = PassedTopic
        userBoxLikeHistoryList = likeList
    /*    if(PPostChatList.count > 1){
            self.backgroundColor = #colorLiteral(red: 0.07058823529, green: 0.007843137255, blue: 0.2509803922, alpha: 1)
        }
        else{
            self.backgroundColor = #colorLiteral(red: 0.5704988837, green: 0.2374570668, blue: 1, alpha: 1)

        }
 */
        commentCollection.reloadData()
        self.scrollToLastItem()

        if(!hasRunBottomWithoutAnimationOnce){
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) { // change 2 to desired number of seconds
            // Your code with delay
            self.hasRunBottomWithoutAnimationOnce = true
        }
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
       
        return CGSize(width:  self.commentCollection.frame.width * 0.98 , height:  161)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postChatList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        

        let cell:articleCommentNestedCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCommentNestedCollectionViewCell", for: indexPath) as! articleCommentNestedCollectionViewCell

        cell.lblText.text = postChatList[indexPath.row].postText
        cell.lblUsername.text = postChatList[indexPath.row].creatorName
        cell.lblRating.text = postChatList[indexPath.row].ratingBlend.description

        var strHasLikedPost = postChatList[indexPath.row].postID+":L"
        var strHasDislikedPost = postChatList[indexPath.row].postID+":D"
        var strHasSuperLikedPost = postChatList[indexPath.row].postID+":LL"
        var strHasSuperDislikedPost = postChatList[indexPath.row].postID+":DD"
        
        
        
       cell.btnLike.addTarget(self, action: #selector(upFunc(sender:)), for: .touchUpInside)
        cell.btnLike.tag = indexPath.row
 
        cell.btnReport.addTarget(self, action: #selector(reportFunc(sender:)), for: .touchUpInside)
        cell.btnReport.tag = indexPath.row
        cell.btnDislike.addTarget(self, action: #selector(downFunc(sender:)), for: .touchUpInside)
        cell.btnDislike.tag = indexPath.row
 
        
        
        
        if userBoxLikeHistoryList.contains(strHasLikedPost) {
            print("LikedIt")
            cell.btnLike.tintColor =   #colorLiteral(red: 0.1102850065, green: 0.6799504757, blue: 0.4359227419, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
        }
        else if userBoxLikeHistoryList.contains(strHasDislikedPost) {
            print("Disliked it")
            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            
            
        }
        else if userBoxLikeHistoryList.contains(strHasSuperLikedPost) {
            print("Superliked it")
            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.1098039216, green: 0.6784313725, blue: 0.4352941176, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
        }
        else if userBoxLikeHistoryList.contains(strHasSuperDislikedPost) {
            print("SuperDisliked it")
            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 1, green: 0.1490196078, blue: 0, alpha: 1)
            
        }
        else{
            print("Nothin")
            
            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
            
            
        }

        
        // Configure the cell
        
        return cell
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
      /*  let topicChatViewController = UIStoryboard.mainStoryboard().instantiateViewController(withIdentifier: "topicChatViewController") as! topicChatViewController
        
        topicChatViewController.passedTopic = passedTopicObj
        */
        // self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //  present(secondViewController, animated: true, completion: nil)
        
        
       // self.navigationController?.pushViewController(topicChatViewController, animated: true)
        
       // let navv = UIApplication.windows[0].rootViewController as! UINavigationController
        // navv.pushViewController(topicChatViewController, animated: true)

        
    }
    
    @IBOutlet weak var commentCollection: UICollectionView!
    
    
    
    
    
    
    
    
    @objc func reportFunc(sender : UIButton){
      
        let myIndexPath = commentCollection.indexPathForView(view: sender)
        
        
        
        let alert = UIAlertController(title: "Report", message: "Report Post?", preferredStyle: .alert)
        
        self.delegate?.reportPost(passedChatPost: postChatList[(myIndexPath?.row)!])

        
        
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @objc func upFunc(sender : UIButton) -> Void {
        
        /* let myIndexPath = IndexPath(row: sender.tag, section: 0)
         let cell = collectionPosts.cellForItem(at: myIndexPath) as! HomePostCollectionViewCell
         */
        let myIndexPath = commentCollection.indexPathForView(view: sender)
        
        
        
        
        
        
        let cell = commentCollection.cellForItem(at: myIndexPath as! IndexPath) as! pamfti.articleCommentNestedCollectionViewCell
        
        
        
        
        
        
        
        if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
        {
            userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
            
            postChatList[(myIndexPath?.row)!].ratingBlend -= 1
            cell.lblRating.text = postChatList[myIndexPath!.row].ratingBlend.description

            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":+N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":+N")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":-N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":-N")!)
            }
            
            
            
            userBoxLikeHistoryList.append((postChatList[(myIndexPath?.row)!].postID+":-N"))
            
            let uLink = "CHATS/"+passedTopic.topicID+"/"+postChatList[(myIndexPath?.row)!].postID+"/ratingBlend"
            
            
            let pID = postChatList[(myIndexPath?.row)!].postID
            
            let post:[String : AnyObject] = [
                //"eventTitle":txtEventName.text! as AnyObject,
                "rating":"-N" as AnyObject,
                "postLink": uLink   as AnyObject,
                "topicID": passedTopic.topicID  as AnyObject,
                
                "likedUserID": userID   as AnyObject,
                "postID":pID as AnyObject
                
                
                
            ]
            ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID!).setValue(post);
            
            
        }
        else if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
        {
            userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
            
            
            postChatList[(myIndexPath?.row)!].ratingBlend -= 1
            cell.lblRating.text = postChatList[myIndexPath!.row].ratingBlend.description

            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":+N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":+N")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":-N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":-N")!)
            }
            
            
            
            
            
            userBoxLikeHistoryList.append((postChatList[(myIndexPath?.row)!].postID+":-N"))
            
            let uLink = "CHATS/"+passedTopic.topicID+"/"+postChatList[(myIndexPath?.row)!].postID+"/ratingBlend"
            
            
            let pID = postChatList[(myIndexPath?.row)!].postID
            
            let post:[String : AnyObject] = [
                //"eventTitle":txtEventName.text! as AnyObject,
                "rating":"-N" as AnyObject,
                "postLink": uLink   as AnyObject,
                "topicID": passedTopic.topicID  as AnyObject,
                
                "likedUserID": userID   as AnyObject,
                "postID":pID as AnyObject
                
                
                
            ]
            ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID!).setValue(post);
            
            
            
            
        }
        else if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
        {
            userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
            
            
            postChatList[(myIndexPath?.row)!].ratingBlend += 2
            cell.lblRating.text = postChatList[myIndexPath!.row].ratingBlend.description

            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.1102850065, green: 0.6799504757, blue: 0.4359227419, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":+N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":+N")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":-N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":-N")!)
            }
            
            
            
            
            userBoxLikeHistoryList.append((postChatList[(myIndexPath?.row)!].postID+":LL"))
            
            let uLink = "CHATS/"+passedTopic.topicID+"/"+postChatList[(myIndexPath?.row)!].postID+"/ratingBlend"
            
            
            let pID = postChatList[(myIndexPath?.row)!].postID
            
            let post:[String : AnyObject] = [
                //"eventTitle":txtEventName.text! as AnyObject,
                "rating":"LL" as AnyObject,
                "postLink": uLink   as AnyObject,
                "topicID": passedTopic.topicID  as AnyObject,
                
                "likedUserID": userID   as AnyObject,
                "postID":pID as AnyObject
                
                
                
            ]
            ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID!).setValue(post);
            
            
            
        }
        else if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
        {
            userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
            
            
            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.1102850065, green: 0.6799504757, blue: 0.4359227419, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
            
            
            postChatList[(myIndexPath?.row)!].ratingBlend += 2
            cell.lblRating.text = postChatList[myIndexPath!.row].ratingBlend.description

            
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":+N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":+N")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":-N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":-N")!)
            }
            
            
            
            
            userBoxLikeHistoryList.append((postChatList[(myIndexPath?.row)!].postID+":LL"))
            
            let uLink = "CHATS/"+passedTopic.topicID+"/"+postChatList[(myIndexPath?.row)!].postID+"/ratingBlend"
            
            
            let pID = postChatList[(myIndexPath?.row)!].postID
            
            let post:[String : AnyObject] = [
                //"eventTitle":txtEventName.text! as AnyObject,
                "rating":"LL" as AnyObject,
                "postLink": uLink   as AnyObject,
                "topicID": passedTopic.topicID  as AnyObject,
                
                "likedUserID": userID   as AnyObject,
                "postID":pID as AnyObject
                
                
                
            ]
            ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID!).setValue(post);
            
        }
        else {
            
            postChatList[(myIndexPath?.row)!].ratingBlend += 1
            cell.lblRating.text = postChatList[myIndexPath!.row].ratingBlend.description

            
            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.1102850065, green: 0.6799504757, blue: 0.4359227419, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
            
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":+N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":+N")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":-N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":-N")!)
            }
            
            
            
            
            userBoxLikeHistoryList.append((postChatList[(myIndexPath?.row)!].postID+":L"))
            
            //ref?.child("userCreatedPosts").child((Auth.auth().currentUser?.uid)!).child(postID).child("postdata").setValue(post);
            
            
            let uLink = "CHATS/"+passedTopic.topicID+"/"+postChatList[(myIndexPath?.row)!].postID+"/ratingBlend"
            
            
            let pID = postChatList[(myIndexPath?.row)!].postID
            
            let post:[String : AnyObject] = [
                //"eventTitle":txtEventName.text! as AnyObject,
                "rating":"L" as AnyObject,
                "postLink": uLink   as AnyObject,
                "topicID": passedTopic.topicID  as AnyObject,
                
                "likedUserID": userID   as AnyObject,
                "postID":pID as AnyObject
                
                
                
            ]
            ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID!).setValue(post);
            
            
            
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        /*  if(userLikedHistoryList.contains(model.getPostID()+":L")){
         userLikedHistoryList.remove(model.getPostID()+":L");
         }
         userLikedHistoryList.add(model.getPostID()+":Y");
         */
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    @objc func downFunc(sender : UIButton){
        
        
        
        /*  let myIndexPath = IndexPath(row: sender.tag, section: 0)
         let cell = collectionPosts.cellForItem(at: myIndexPath) as! HomePostCollectionViewCell
         */
        let myIndexPath = commentCollection.indexPathForView(view: sender)
        
        
        
        
        
        let cell = commentCollection.cellForItem(at: myIndexPath as! IndexPath) as! pamfti.articleCommentNestedCollectionViewCell
        
        
        
        
        
        
        if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
        {
            userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
            
            postChatList[(myIndexPath?.row)!].ratingBlend -= 2
            cell.lblRating.text = postChatList[myIndexPath!.row].ratingBlend.description

            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            
            //Removes any exising strings
            //If there are duplicates, it will pick the first one that shows up and prevent that from happening again
            
            
            
            
            
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":+N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":+N")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":-N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":-N")!)
            }
            
            
            
            
            
            
            
            
            
            
            
            userBoxLikeHistoryList.append((postChatList[(myIndexPath?.row)!].postID+":DD"))
            
            let uLink = "CHATS/"+passedTopic.topicID+"/"+postChatList[(myIndexPath?.row)!].postID+"/ratingBlend"
            
            
            let pID = postChatList[(myIndexPath?.row)!].postID
            
            let post:[String : AnyObject] = [
                //"eventTitle":txtEventName.text! as AnyObject,
                "rating":"DD" as AnyObject,
                "postLink": uLink   as AnyObject,
                "topicID": passedTopic.topicID  as AnyObject,
                
                "likedUserID": userID   as AnyObject,
                "postID":pID as AnyObject
                
                
                
            ]
            ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID!).setValue(post);
            
            
            
            
        }
        else if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
        {
            userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
            
            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            
            postChatList[(myIndexPath?.row)!].ratingBlend -= 2
            cell.lblRating.text = postChatList[myIndexPath!.row].ratingBlend.description

            
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":+N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":+N")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":-N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":-N")!)
            }
            
            
            
            
            
            userBoxLikeHistoryList.append((postChatList[(myIndexPath?.row)!].postID+":DD"))
            
            let uLink = "CHATS/"+passedTopic.topicID+"/"+postChatList[(myIndexPath?.row)!].postID+"/ratingBlend"
            
            
            let pID = postChatList[(myIndexPath?.row)!].postID
            
            let post:[String : AnyObject] = [
                //"eventTitle":txtEventName.text! as AnyObject,
                "rating":"DD" as AnyObject,
                "postLink": uLink   as AnyObject,
                "topicID": passedTopic.topicID  as AnyObject,
                
                "likedUserID": userID   as AnyObject,
                "postID":pID as AnyObject
                
                
                
            ]
            ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID!).setValue(post);
            
            
            
            
            
            
        }
        else if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
        {
            userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
            
            
            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
            postChatList[(myIndexPath?.row)!].ratingBlend += 1
            cell.lblRating.text = postChatList[myIndexPath!.row].ratingBlend.description

            
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":+N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":+N")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":-N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":-N")!)
            }
            
            
            
            
            
            userBoxLikeHistoryList.append((postChatList[(myIndexPath?.row)!].postID+":+N"))
            
            let uLink = "CHATS/"+passedTopic.topicID+"/"+postChatList[(myIndexPath?.row)!].postID+"/ratingBlend"
            
            
            let pID = postChatList[(myIndexPath?.row)!].postID
            
            let post:[String : AnyObject] = [
                //"eventTitle":txtEventName.text! as AnyObject,
                "rating":"+N" as AnyObject,
                "postLink": uLink   as AnyObject,
                "topicID": passedTopic.topicID  as AnyObject,
                
                "likedUserID": userID   as AnyObject,
                "postID":pID as AnyObject
                
                
                
            ]
            ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID!).setValue(post);
            
            
            
            
            
        }
        else if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
        {
            userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
            
            postChatList[(myIndexPath?.row)!].ratingBlend += 1
            cell.lblRating.text = postChatList[myIndexPath!.row].ratingBlend.description

            
            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":+N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":+N")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":-N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":-N")!)
            }
            
            
            
            
            
            userBoxLikeHistoryList.append((postChatList[(myIndexPath?.row)!].postID+":+N"))
            
            let uLink = "CHATS/"+passedTopic.topicID+"/"+postChatList[(myIndexPath?.row)!].postID+"/ratingBlend"
            
            
            let pID = postChatList[(myIndexPath?.row)!].postID
            
            let post:[String : AnyObject] = [
                //"eventTitle":txtEventName.text! as AnyObject,
                "rating":"+N" as AnyObject,
                "postLink": uLink   as AnyObject,
                "topicID": passedTopic.topicID  as AnyObject,
                
                "likedUserID": userID   as AnyObject,
                "postID":pID as AnyObject
                
                
                
            ]
            ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID!).setValue(post);
            
            
            
        }
        else {
            
            
            postChatList[(myIndexPath?.row)!].ratingBlend -= 1
            cell.lblRating.text = postChatList[myIndexPath!.row].ratingBlend.description

            
            cell.btnLike.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDislike.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            
            
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":+N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":+N")!)
            }
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":-N")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":-N")!)
            }
            
            
            
            
            
            userBoxLikeHistoryList.append((postChatList[(myIndexPath?.row)!].postID+":D"))
            
            let uLink = "CHATS/"+passedTopic.topicID+"/"+postChatList[(myIndexPath?.row)!].postID+"/ratingBlend"
            
            
            let pID = postChatList[(myIndexPath?.row)!].postID
            
            let post:[String : AnyObject] = [
                //"eventTitle":txtEventName.text! as AnyObject,
                "rating":"D" as AnyObject,
                "postLink": uLink   as AnyObject,
                "topicID": passedTopic.topicID  as AnyObject,
                
                "likedUserID": userID   as AnyObject,
                "postID":pID as AnyObject
                
                
                
            ]
            ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID!).setValue(post);
            
            
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    func scrollToLastItem() {
        
        let lastItem =   collectionView(self.commentCollection!, numberOfItemsInSection: 0) - 1
        let indexPath: NSIndexPath = NSIndexPath.init(item: lastItem, section: 0)
        
        
        if(hasRunBottomWithoutAnimationOnce == false){
            commentCollection?.scrollToItem(at: indexPath as IndexPath, at: UICollectionView.ScrollPosition.top, animated: false)
            print("nah")
            
        }
        else{
            commentCollection?.scrollToItem(at: indexPath as IndexPath, at: UICollectionView.ScrollPosition.top, animated: true)
            print("yah")
        }
        
        
    }
    
    

 
}

    
    
    
    
    
    
    






