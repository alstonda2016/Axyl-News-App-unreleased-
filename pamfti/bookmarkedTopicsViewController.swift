//
//  bookmarkedTopicsViewController.swift
//  pamfti
//
//  Created by David A on 11/26/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage


class bookmarkedTopicsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    var ref:DatabaseReference?
    
    var userLat: Double?
    var userLong:Double?
    var userID:String = ""
    var userFullName:String = ""
    var creNum:Int = 0
    var isEmpty:Bool = false

    var userKarmaLevel:Int?
    var lastAccountRefreshDate:CLong?
    var lstBookmarkedTopics:[bookmarkedObject] = []

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(isEmpty){
            return 1
        }
        return lstBookmarkedTopics.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionBookmarks.frame.width  * 0.9 , height: 275)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(isEmpty){
            
            let cell:bookmarkedTopicCollectionViewCellEMPTY = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkedTopicCollectionViewCellEMPTY", for: indexPath) as! bookmarkedTopicCollectionViewCellEMPTY
            
          
            
            
            return cell;
            
        }
        else{
         let cell:bookmarkedTopicCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkedTopicCollectionViewCell", for: indexPath) as! bookmarkedTopicCollectionViewCell
        
        cell.btnDropBookmark.addTarget(self, action: #selector(upFunc(sender:)), for: .touchUpInside)
        cell.btnDropBookmark.tag = indexPath.row
        
        
        cell.lblTitle.text = lstBookmarkedTopics[indexPath.row].topic_Object.topicName
        
        let urll = URL(string: lstBookmarkedTopics[indexPath.row].topic_Object.strPicURL)
        
        
        cell.imgImg.sd_setImage(with: urll)
        //cell.imgImg.contentMode = .scaleAspectFit
        cell.imgImg.contentMode = .scaleAspectFill
        cell.imgImg.layer.cornerRadius = 12
        cell.imgImg.clipsToBounds = true
        //cell.lblReportNumber.text = lstRegions[indexPath.row].reportCount.description
        
        let endDate = NSDate(timeIntervalSince1970: TimeInterval((lstBookmarkedTopics[indexPath.row].topic_Object.topicCreationTime) - TimeZone.current.secondsFromGMT()  ))
        let dateFormatter = DateFormatter()
        //dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        let localDate2 = dateFormatter.string(from: endDate as Date)
        cell.lblDate.text = localDate2
        
        
        
        
        
        return cell;
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        /* let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "regionLevel3ViewController") as! regionLevel3ViewController
         
         secondViewController.passedRegionLevel1 = passedRegionLevel1
         secondViewController.passedRegionLevel2 = reportTypeList[indexPath.row]
         
         // self.navigationController?.pushViewController(secondViewController, animated: true)
         
         //  present(secondViewController, animated: true, completion: nil)
         
         self.navigationController?.pushViewController(secondViewController, animated: true)
         */
        if(!isEmpty){

        
        
        let postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
        let idDesc = lstBookmarkedTopics[indexPath.row].topic_Object.topicID.description
        let topicCategory = lstBookmarkedTopics[indexPath.row].topic_Object.topicCategory.description
        
        
        ref?.child("TOPIC_CLICK_LIST").child(topicCategory).child(idDesc).child(userID).setValue(postTime)
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newsTopicArticlesViewController") as! newsTopicArticlesViewController
        
        secondViewController.passedID = lstBookmarkedTopics[indexPath.row].topic_Object.topicID
        secondViewController.passedTopic = lstBookmarkedTopics[indexPath.row].topic_Object
        
        
        // self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //  present(secondViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
        
        
        /*
         let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let newViewController = storyBoard.instantiateViewController(withIdentifier: "newsTopicArticlesViewController") as! newsTopicArticlesViewController
         newViewController.passedID = lstTopics[indexPath.row].topicID
         
         self.present(newViewController, animated: true, completion: nil)
         */
        
        }
        
        return true
    }
    
    
    
    
    @objc func upFunc(sender : UIButton) -> Void {
        
        
        let myIndexPath = collectionBookmarks.indexPathForView(view: sender)
        let cell = collectionBookmarks.cellForItem(at: myIndexPath as! IndexPath) as! bookmarkedTopicCollectionViewCell
        /*if userBoxLikeHistoryList.contains(postChatList[(myIndexPath?.row)!].postID+":L")
        {
        }
        */
        
        
      var tID =   lstBookmarkedTopics[((myIndexPath?.row)!)].topic_Object.topicID
        
        ref!.child("BOOKMARKS").child(userID).child(tID).setValue(nil);
        self.lstBookmarkedTopics.remove(at: (myIndexPath?.row)!)
        self.collectionBookmarks.deleteItems(at: [myIndexPath!])
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        userID = (Auth.auth().currentUser?.uid)!
        userFullName = (Auth.auth().currentUser?.displayName)!
        
        
        
        ref?.child("BOOKMARKS").child(userID).observe(DataEventType.value, with: { (snapshot) in
            
            
            if(snapshot.exists()){
                
           
                self.isEmpty = false
                
                
                
                
            }
            else{
                self.isEmpty = true
                self.collectionBookmarks?.reloadData()

            }
            
            
            
        })
        
        
        ref?.child("BOOKMARKS").child(userID).queryLimited(toLast: 350).observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
                //    let postID = dict["name"] as! String
                
     
                
                let bDate = dict["strBookmarkDate"] as! CLong
                let bDateInv = dict["strBookmarkDateInverse"] as! CLong
                let article_Object = dict["topic_Object"] as! [String: Any]
                
                
                let strPicURL = article_Object["strPicURL"] as! String
                let topicName = article_Object["topicName"] as! String
                let strPicSource = article_Object["strPicSource"] as! String
                let isActive = article_Object["isActive"] as! Bool

                var topicCategory = ""
                
                var topicID = ""
                
                if article_Object["topicID"] is String{
                    //everything about the value works.
                    topicID = article_Object["topicID"] as! String
                }
                else{
                    topicID = snapshot.key.description
                    
                }
                
                
                if article_Object["topicCategory"] is String{
                    //everything about the value works.
                    topicCategory = article_Object["topicCategory"] as! String
                }
                else{
                    topicCategory = "none"
                    
                }
                
                var postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
                
                
                if article_Object["topicCreationTime"] is CLong{
                    //everything about the value works.
                    postTime = article_Object["topicCreationTime"] as! CLong
                }
                let isOngoing = article_Object["isOngoing"] as! Bool

                
                var top = topicObject( TopicName:topicName,
                                       StrPicURL:strPicURL, TopicID: topicID, TopicCreationTime: postTime, TopicCreationTimeInverse: -postTime,
                                       StrPicSource:strPicSource, TopicCategory: topicCategory, IsActive: isActive, IsOngoing: isOngoing
                )
                var bookmarkedTopic = bookmarkedObject(StrBookmarkDate:bDate,
                                                       StrBookmarkDateInverse:bDateInv,
                                                       Topic_Object:top
                )
                
                
                self.lstBookmarkedTopics.append(bookmarkedTopic)
                //self.collectionComments.reloadData()
                self.collectionBookmarks?.reloadData()
                
                
                
                
            }
        })

        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var collectionBookmarks: UICollectionView!
    

    
    
   
}
