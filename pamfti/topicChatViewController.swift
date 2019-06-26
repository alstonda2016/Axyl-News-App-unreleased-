//
//  topicChatViewController.swift
//  pamfti
//
//  Created by David A on 11/20/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage
import Material


protocol chatCustomDelegate{
    
    func reloadChatCollectionview()
}

class topicChatViewController: UIViewController,  UICollectionViewDataSource,chatCustomDelegate, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var txtEnterChat: UITextField!
    
    @IBAction func btnSendPost(_ sender: Any) {
        
        collectionChat.reloadData()
        let savingsInformationViewController = self.storyboard?.instantiateViewController(withIdentifier: "chatCreatePopoverViewController") as! chatCreatePopoverViewController
        
        //   savingsInformationViewController.delegate = self
        savingsInformationViewController.passedTopic = self.passedTopic
        savingsInformationViewController.passedTopicID = self.passedTopic.topicID.description
        
        
        savingsInformationViewController.modalPresentationStyle = .overFullScreen
        
        self.present(savingsInformationViewController, animated: true, completion: nil)
    }
    var userFullName = ""
    var userID = ""
    
    var userBoxLikeHistoryList:[String] = []

    func reloadChatCollectionview() {
        self.collectionChat.reloadData()

    }
    
   
    
    @IBAction func btnCreate(_ sender: Any) {
        
        collectionChat.reloadData()
        let savingsInformationViewController = self.storyboard?.instantiateViewController(withIdentifier: "chatCreatePopoverViewController") as! chatCreatePopoverViewController
        
        //   savingsInformationViewController.delegate = self
        savingsInformationViewController.passedTopic = self.passedTopic
        savingsInformationViewController.passedTopicID = self.passedTopic.topicID.description

        
        savingsInformationViewController.modalPresentationStyle = .overFullScreen
        
        self.present(savingsInformationViewController, animated: true, completion: nil)
        
    }
    
    
    
    var handle: DatabaseHandle?
    var ref:DatabaseReference?
    var CHATID:String!
    var passedTopic:topicObject!

    var postChatList:[topicChatPostObject] = []
    
    
  
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postChatList.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:topicChatCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "topicChatCollectionViewCell", for: indexPath) as! topicChatCollectionViewCell
        cell.lblPost.text = postChatList[indexPath.row].postText
        cell.lblUserName.text = postChatList[indexPath.row].postUserName

     /*   cell.txtTitle.text = lstTopics[indexPath.row].topicName
        
        let urll = URL(string: lstTopics[indexPath.row].strPicURL)
        
        
        cell.imgImg.sd_setImage(with: urll)
      */
        
        
        cell.btnUpVote.addTarget(self, action: #selector(upFunc(sender:)), for: .touchUpInside)
        cell.btnUpVote.tag = indexPath.row
        
        cell.btnReport.addTarget(self, action: #selector(reportFunc(sender:)), for: .touchUpInside)
        cell.btnReport.tag = indexPath.row
        cell.btnDownVote.addTarget(self, action: #selector(downFunc(sender:)), for: .touchUpInside)
        cell.btnDownVote.tag = indexPath.row
        
        
        
        var strHasLikedPost = postChatList[indexPath.row].postID+":L"
        var strHasDislikedPost = postChatList[indexPath.row].postID+":D"
        var strHasSuperLikedPost = postChatList[indexPath.row].postID+":LL"
        var strHasSuperDislikedPost = postChatList[indexPath.row].postID+":DD"
        
        
        
        
        if userBoxLikeHistoryList.contains(strHasLikedPost) {
            print("LikedIt")
            cell.btnUpVote.tintColor =   #colorLiteral(red: 0.1102850065, green: 0.6799504757, blue: 0.4359227419, alpha: 1)
            cell.btnDownVote.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
        }
        else if userBoxLikeHistoryList.contains(strHasDislikedPost) {
            print("Disliked it")
            
            cell.btnUpVote.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDownVote.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            
            
        }
        else if userBoxLikeHistoryList.contains(strHasSuperLikedPost) {
            print("Superliked it")
            
            cell.btnUpVote.tintColor =   #colorLiteral(red: 0.1098039216, green: 0.6784313725, blue: 0.4352941176, alpha: 1)
            cell.btnDownVote.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
        }
        else if userBoxLikeHistoryList.contains(strHasSuperDislikedPost) {
            print("SuperDisliked it")
            
            cell.btnUpVote.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDownVote.tintColor = #colorLiteral(red: 1, green: 0.1490196078, blue: 0, alpha: 1)
            
        }
        else{
            print("Nothin")
            
            
            cell.btnUpVote.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            cell.btnDownVote.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            
            
            
        }
        
        return cell
    }
    

    @IBOutlet weak var collectionChat: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        CHATID = passedTopic.topicID
        ref = Database.database().reference()

        userID = (Auth.auth().currentUser?.uid)!
        
        ref?.child("CHATLIKESHISTORY").child(userID).child(CHATID).queryLimited(toLast: 350).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [String: Any] {
                let dataArray = Array(data)
                //the first va
                let keys = dataArray.map { $0.0 }
                
                let values = dataArray.map { $0.1 }
                self.userBoxLikeHistoryList = values.flatMap{String(describing: $0)}
                
                //  print(self.userBoxLikeHistoryList[0].description)
                
                
            }
        })
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnBottomView(_:)))
        tap.delegate = self
        txtEnterChat.addGestureRecognizer(tap)
        
        loadPosts()
        

    }
    
    
    func loadPosts() -> Void {
        
        ref?.child("CHATS").child(CHATID).removeAllObservers()
        postChatList.removeAll()
        collectionChat.reloadData()
       
        
        ref?.child("CHATS").child(CHATID).queryLimited(toLast: 350).observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
                //    let postID = dict["name"] as! String
                
                let postCreatorID = dict["postCreatorID"] as! String
                let postText = dict["postText"] as! String
                let postID = dict["postID"] as! String
                let postTime = dict["postTime"] as! CLong
                let postTimeInverse = dict["postTimeInverse"] as! CLong
                let postUserName = dict["postUserName"] as! String
                let postType = dict["postType"] as! String
                let postDESCRIPTION = dict["postDescription"] as! String
                let creatorName = dict["creatorName"] as! String
                let ratingBlend = dict["ratingBlend"] as! Int
                let postVisibilityStartTime = dict["postVisibilityStartTime"] as! CLong
                let postVisibilityEndTime = dict["postVisibilityEndTime"] as! CLong
                let textCount = dict["textCount"] as! Int
                let postIsFlagged = dict["postIsFlagged"] as! Bool
                let originalTopicID = dict["originalTopicID"] as! String


                
               
               
                
                var top = topicChatPostObject( PostCreatorID:postCreatorID ,
                                               PostText:postText,
                                               PostID:postID ,
                                               
                                               PostTime:postTime ,
                                               PostTimeInverse:postTimeInverse ,
                                               PostUserName:postUserName ,
                                               PostType:postType ,
                                               PostDESCRIPTION:postDESCRIPTION,
                                               CreatorName:creatorName, RatingBlend: ratingBlend, PostVisStart: postVisibilityStartTime, PostVisEnd: postVisibilityEndTime, TextCount: textCount, PostFlaggedStatus: postIsFlagged, OriginalTopicID: originalTopicID)
                
     
                
                
                self.postChatList.append(top)
                //self.collectionComments.reloadData()
                self.collectionChat?.reloadData()
                
                
                
                
            }
        })
    }
    
    @objc func upFunc(sender : UIButton) -> Void {
        
        /* let myIndexPath = IndexPath(row: sender.tag, section: 0)
         let cell = collectionPosts.cellForItem(at: myIndexPath) as! HomePostCollectionViewCell
         */
        let myIndexPath = collectionChat.indexPathForView(view: sender)
        
        
    
            
            
            
            let cell = collectionChat.cellForItem(at: myIndexPath as! IndexPath) as! topicChatCollectionViewCell
            
            
            
            
            
            
            
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
                
                
                cell.btnUpVote.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                cell.btnDownVote.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                
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
                ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID).setValue(post);

                
            }
            else if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
                
                
                
                
                cell.btnUpVote.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                cell.btnDownVote.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                
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
                ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID).setValue(post);

                
                
                
            }
            else if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
                
                
                
                
                cell.btnUpVote.tintColor =   #colorLiteral(red: 0.1102850065, green: 0.6799504757, blue: 0.4359227419, alpha: 1)
                cell.btnDownVote.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                
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
                ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID).setValue(post);

                
                
            }
            else if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
                
                
                
                cell.btnUpVote.tintColor =   #colorLiteral(red: 0.1102850065, green: 0.6799504757, blue: 0.4359227419, alpha: 1)
                cell.btnDownVote.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                
                
                
                
                
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
                ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID).setValue(post);

            }
            else {
                
                
                
                
                cell.btnUpVote.tintColor =   #colorLiteral(red: 0.1102850065, green: 0.6799504757, blue: 0.4359227419, alpha: 1)
                cell.btnDownVote.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                
                
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
                ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID).setValue(post);

                
            
            
            
            
            
            
            
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
        let myIndexPath = collectionChat.indexPathForView(view: sender)
        
        
        
            
            
        let cell = collectionChat.cellForItem(at: myIndexPath as! IndexPath) as! topicChatCollectionViewCell
            
            
            
            
            
            
            if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":L")!)
                
                
                
                
                cell.btnUpVote.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                cell.btnDownVote.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                
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
                ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID).setValue(post);
                
                
                
                
            }
            else if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":LL")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":LL")!)
                
                
                cell.btnUpVote.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                cell.btnDownVote.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                
                
                
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
                ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID).setValue(post);

                
                
                
                
                
            }
            else if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":D")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":D")!)
                
                
                
                cell.btnUpVote.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                cell.btnDownVote.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                
                
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
                ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID).setValue(post);

                
                
                
                
            }
            else if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":DD")
            {
                userBoxLikeHistoryList.remove(at: userBoxLikeHistoryList.index(of: postChatList[(myIndexPath?.row)!].postID+":DD")!)
                
                
                
                
                cell.btnUpVote.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                cell.btnDownVote.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                
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
                ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID).setValue(post);

                
                
            }
            else {
                
                
                
                
                cell.btnUpVote.tintColor =   #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
                cell.btnDownVote.tintColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
                
                
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
                ref?.child("LIKESDISLIKES").child(passedTopic.topicID).child(postChatList[(myIndexPath?.row)!].postID).child(userID).setValue(post);

                
                
          
            
            
        }
        
        
        
        
        
    }
    
    
    
    
    @objc func reportFunc(sender : UIButton){
        
        let myIndexPath = collectionChat.indexPathForView(view: sender)
        //postChatList[(myIndexPath?.row)!]
       
            /*
            let cell = collectionChat.cellForItem(at: myIndexPath as! IndexPath) as! topicChatCollectionViewCell
            
            /*     let popOverVC = storyboard?.instantiateViewController(withIdentifier: "reportPostPOPOVERViewController") as! reportPostPOPOVERViewController
             self.addChildViewController(popOverVC)
             popOverVC.passedObject = postChatList[(myIndexPath?.row)!]
             popOverVC.view.frame = self.view.frame
             self.view.addSubview(popOverVC.view)
             popOverVC.didMove(toParentViewController: self)
             */
            let savingsInformationViewController = storyboard?.instantiateViewController(withIdentifier: "reportPostPOPOVERViewController") as! reportPostPOPOVERViewController
            
            //   savingsInformationViewController.delegate = self
            savingsInformationViewController.passedObject = postChatList[(myIndexPath?.row)!]
            
            savingsInformationViewController.modalPresentationStyle = .overFullScreen
            if let popoverController = savingsInformationViewController.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
                //popoverController.permittedArrowDirections = .anyany
                popoverController.delegate = self
            }
            present(savingsInformationViewController, animated: true, completion: nil)
            */
        
        
        
        let alert = UIAlertController(title: "Report", message: "Report Post?", preferredStyle: .alert)
        
       
        
        
        let post1Ref2 = ref?.childByAutoId()
        var postID = (post1Ref2?.key)!
        
        
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
            let postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
            
            var proposalArtt = reportChatObject(
             
                PostReportReason: 0, PostObject: self.postChatList[(myIndexPath?.row)!], PostReporterID: self.userID, PostIsFlagged:
                self.postChatList[(myIndexPath?.row)!].postIsFlagged   )
            self.ref?.child("REPORTS").child(self.passedTopic.topicID).child(self.postChatList[(myIndexPath?.row)!].postID).setValue(proposalArtt.toFBObject())
            
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            
            
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
    @objc func tapOnBottomView(_ gestureRecognizer: UITapGestureRecognizer) {
        collectionChat.reloadData()
        let savingsInformationViewController = self.storyboard?.instantiateViewController(withIdentifier: "chatCreatePopoverViewController") as! chatCreatePopoverViewController
        
        //   savingsInformationViewController.delegate = self
        savingsInformationViewController.passedTopic = self.passedTopic
        savingsInformationViewController.passedTopicID = self.passedTopic.topicID.description
        
        
        savingsInformationViewController.modalPresentationStyle = .overFullScreen
        
        self.present(savingsInformationViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    

}
