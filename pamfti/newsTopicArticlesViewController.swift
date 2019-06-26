//
//  newsTopicArticlesViewController.swift
//  pamfti
//
//  Created by David A on 11/18/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage
import SafariServices


protocol aCustomDelegate{
  
    func reportPost(passedChatPost:topicChatPostObject)
}

class newsTopicArticlesViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, CollectionCellDelegate  {
   
    
    @IBOutlet weak var lblTopicTitle: UILabel!
    @IBOutlet weak var viewOnGoing: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
     
        super.viewWillAppear(animated)
        //self.navigationController?.navigationBar.topItem?.title = "   "
    }
    
    func reportPost(passedChatPost:topicChatPostObject) {
        
        
        let alert = UIAlertController(title: "Report", message: "Report Post?", preferredStyle: .alert)
        
        
        
        
        let post1Ref2 = ref?.childByAutoId()
        var postID = (post1Ref2?.key)!
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            
            
            
        }))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
            let postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
            
            var proposalArtt = reportChatObject(
                
                PostReportReason: 0, PostObject: passedChatPost, PostReporterID: self.userID!, PostIsFlagged:
                passedChatPost.postIsFlagged   )
            self.ref?.child("REPORTS").child(self.passedTopic.topicID).child(passedChatPost.postID).setValue(proposalArtt.toFBObject())
            
            
        }))
        
        
        
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func testt(passedPostID: String) {
        let alert = UIAlertController(title: "yes", message: passedPostID, preferredStyle: .alert)
        
        
        
        
     
        
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { [weak alert] (_) in
            
         
            
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            
            
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    var passedID:String!
    var passedTopic:topicObject!
    var userBoxLikeHistoryList:[String] = []


    var isBookmarked:Bool = false
    @IBOutlet weak var collectionArticles: UICollectionView!
    var handle: DatabaseHandle?
    var ref:DatabaseReference?
    var userID:String?
    var userFullName:String?

    @IBOutlet weak var btnBookmarkTopic: UIBarButtonItem!
    
    var lstArticles:[articleObject] = []
    var postChatList:[topicChatPostObject] = []
    
    
    func proposeArticle() -> Void {
        
        
        /*
        let alert = UIAlertController(title: "Propose an article", message: "Paste a link here", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
    
        let textField = alert.textFields![0] // Force unwrapping because we know it exists.
    
        
        let post1Ref2 = ref?.childByAutoId()
        var postID = (post1Ref2?.key)!
        
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
            
            var proposalArtt = proposedArticleObject(
                proposedURL:textField.text!,
                proposalAuthor: self.userID!,
                ProposalAuthorName: self.userFullName!,
                proposalTime:postTime
            )
            self.ref?.child("PROPOSED_ARTICLES").child(self.passedID).child(self.userID!).setValue(proposalArtt.toFBObject())
            
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: { [weak alert] (_) in
            
            
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        */
        
        
    }
    func reviewTopic() -> Void {
        
        
        
        let alert = UIAlertController(title: "Review The Articles", message: "Did you find the articles to show every side?", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        /*alert.addTextField { (textField2) in
         textField2.text = "Some default text"
         }
         alert.addTextField { (textField3) in
         textField3.text = "Some default text"
         }
         alert.addTextField { (textField3) in
         textField3.text = "headline"
         }
         alert.addTextField { (textField5) in
         textField5.text = "rating"
         }
         */
        let textField = alert.textFields![0] // Force unwrapping because we know it exists.
        /*  let textField2 = alert.textFields![1] // Force unwrapping because we know it exists.
         let textField3 = alert.textFields![2] // Force unwrapping because we know it exists.
         let textField4 = alert.textFields![3] // Force unwrapping because we know it exists.
         let textField5 = alert.textFields![4] // Force unwrapping because we know it exists.
         
         */
        
        
        let post1Ref2 = ref?.childByAutoId()
        var postID = (post1Ref2?.key)!
        
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
            
            var proposalArtt = reviewedTopicObject(
                ReviewText:textField.text!,
                ReviewAuthor:self.userID!,
                ReviewAuthorName:self.userFullName!,
                
                ReviewTime:postTime
            )
            self.ref?.child("REVIEW_TOPIC").child(self.passedID).child(self.userID!).setValue(proposalArtt.toFBObject())
            
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: { [weak alert] (_) in
            
            
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (lstArticles.count + 1 )
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(indexPath.row == (lstArticles.count )){

      //  return CGSize(width:  self.collectionArticles.frame.width * 0.98 , height:  572)
           // return CGSize(width:  self.collectionArticles.frame.width * 0.98 , height:  self.view.frame.height)
            return CGSize(width:  self.collectionArticles.frame.width * 0.98 , height:  self.collectionArticles.frame.height)


        }
        return CGSize(width:  self.collectionArticles.frame.width * 0.98 , height:  278)

        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if(indexPath.row == (lstArticles.count )){
            let cell:articleCommentCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCommentCollectionViewCell", for: indexPath) as! articleCommentCollectionViewCell
            cell.delegate = self

           // cell.layer.cornerRadius = 1
          //  cell.clipsToBounds = true
            //cell.layer.borderWidth = 0.5
          //  cell.layer.borderColor =  #colorLiteral(red: 0.1689244211, green: 0.1291499436, blue: 0.2743852437, alpha: 1)
            
            var topicid = passedTopic.topicID
            
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapOnBottomView(_:)))
            tap.delegate = self
            
            cell.viewMakePost.addGestureRecognizer(tap)
            //cell.txtEnterText.addGestureRecognizer(tap)
            //cell.btnGoToChatt.addGestureRecognizer(tap)
            
            cell.btnGoToChatt.addTarget(self, action: #selector(self.tapOnBottomView(_:)), for: .touchUpInside)
            //cell.btnGoToChatt.tag = indexPath.row
            
           //cell.viewMakePost.layer.cornerRadius = 5
          //  cell.viewMakePost.clipsToBounds = true
        /*  cell.viewMakePost.layer.borderColor =  #colorLiteral(red: 0.07058823529, green: 0.007843137255, blue: 0.2509803922, alpha: 1)
            cell.viewMakePost.layer.borderWidth =  1
            */

           cell.txtEnterText.layer.borderWidth =  0
            cell.txtEnterText.layer.borderColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)

            
            cell.setupViews()
            self.postChatList.removeAll()

            ref?.child("CHATS").child(topicid).removeAllObservers()
            ref?.child("CHATS").child(topicid).queryLimited(toLast: 350).observe(.childAdded, with: { (snapshot) in
              //  self.postChatList.removeAll()

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
                    // self.collectionChat?.reloadData()
                    
                    
                    
                    
                }
                cell.lblTextCount.text = self.postChatList.count.description + " posts"

                cell.runn(PPostChatList: self.postChatList, PassedTopic: self.passedTopic, likeList: self.userBoxLikeHistoryList)

            })

            
         
            // Configure the cell
            
            return cell
        }
        else{
        let cell:articleCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "articleCollectionViewCell", for: indexPath) as! articleCollectionViewCell
        
      cell.lblTitle.text = lstArticles[indexPath.row].strArticleHeadline
            cell.lblArticlePublication.text = lstArticles[indexPath.row].articlePublisher
            //cell.lblArticleAuthor.text = "By: " + lstArticles[indexPath.row].strArticleAuthor

            if(lstArticles[indexPath.row].articleBias < 3){
            //cell.imgArticleBiasDot.tintColor =   #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
                cell.imgArticleBiasDot.setImageColor(color: #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))
            }
            else if(lstArticles[indexPath.row].articleBias == 3){
               // cell.imgArticleBiasDot.tintColor =   #colorLiteral(red: 0.5704988837, green: 0.2374570668, blue: 1, alpha: 1)
                cell.imgArticleBiasDot.setImageColor(color: UIColor.purple)

            }
            else{
               // cell.imgArticleBiasDot.tintColor =   #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
                cell.imgArticleBiasDot.setImageColor(color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1))

            }

            
        let urll = URL(string: lstArticles[indexPath.row].strPicURL)
        
        
        cell.imgImg.sd_setImage(with: urll)
            cell.imgImg.contentMode = .scaleAspectFill
            cell.imgImg.layer.cornerRadius = 12
            cell.imgImg.clipsToBounds = true
 
            cell.lblRundownPoint1.text = "-"+lstArticles[indexPath.row].strRundownPoint1
            cell.lblRundownPoint2.text = "-"+lstArticles[indexPath.row].strRundownPoint2
            cell.lblRundownPoint3.text = "-"+lstArticles[indexPath.row].strRundownPoint3

        //cell.lblReportNumber.text = lstRegions[indexPath.row].reportCount.description
        
        
        // Configure the cell
        
        return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     
        if(indexPath.row == (lstArticles.count )){
          /*  let topicChatViewController = self.storyboard?.instantiateViewController(withIdentifier: "topicChatViewController") as! topicChatViewController
            
            topicChatViewController.passedTopic = passedTopic
            
            // self.navigationController?.pushViewController(secondViewController, animated: true)
            
            //  present(secondViewController, animated: true, completion: nil)
            
            self.navigationController?.pushViewController(topicChatViewController, animated: true)
            
            
           */

            return true
        }
        
        
        
        let postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))

        
        let hh = historyArticleObject(
            StrHistoryDate:postTime,
            StrHistoryDateInverse:-postTime,
            Article_Object: lstArticles[indexPath.row])
        
        ref?.child("USERVIEWHISTORY").child(userID!).child(lstArticles[indexPath.row].articleID).setValue(hh.toFBObject())
        
        let urll = URL(string: lstArticles[indexPath.row].strPicURL)
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewViewController") as! webViewViewController
        secondViewController.passedURL = lstArticles[indexPath.row].strURL.description
        secondViewController.passedTopic = lstArticles[indexPath.row].articleTopic.description
        secondViewController.passedWebsiteTopic = lstArticles[indexPath.row].articlePublisher.description

        

        // self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //  present(secondViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
        
        
        
        
        
        
       /*
        guard let url = URL(string: lstArticles[indexPath.row].strPicURL) else {
            return true //be safe
        }
        
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
 */
        
        return true;
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnBookmarkTopic.isEnabled = false

        ref = Database.database().reference()
        
        userID = (Auth.auth().currentUser?.uid)!
        userFullName = (Auth.auth().currentUser?.displayName)!

       /* if(passedTopic.isOngoing){
            viewOnGoing.isHidden = false
            viewOnGoing.layer.borderWidth = 0.5
            viewOnGoing.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        }
        else{
            viewOnGoing.isHidden = true

        }
        */
        viewOnGoing.isHidden = false
        viewOnGoing.layer.borderWidth = 0.5
        viewOnGoing.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lblTopicTitle.text = passedTopic.topicName
        
        handle = ref?.child("ARTICLES").child(passedID).queryLimited(toLast: 350).observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
                //    let postID = dict["name"] as! String
                let strArticleHeadline = dict["strArticleHeadline"] as! String
                let strURL = dict["strURL"] as! String
                let strPicURL = dict["strPicURL"] as! String
                let strPicSource = dict["strPicSource"] as! String
                let articleBias = dict["articleBias"] as! Int
                let strArticleAuthor = dict["strArticleAuthor"] as! String
                let articleTime = dict["articleTime"] as! CLong
                let articlePublisher = dict["articlePublisher"] as! String
                let articlePicDisplayType = dict["articlePicDisplayType"] as! String
                let articleID = dict["articleID"] as! String
                let rundownCount = dict["rundownCount"] as! Int
                let strRundownPoint1 = dict["strRundownPoint1"] as! String
                let strRundownPoint2 = dict["strRundownPoint2"] as! String
                let strRundownPoint3 = dict["strRundownPoint3"] as! String
                let strRundownPoint4 = dict["strRundownPoint4"] as! String
                let strRundownPoint5 = dict["strRundownPoint5"] as! String
                let strAsrticleProposalAuthorID = dict["proposalAuthorID"] as! String
                let strAsrticleProposalAuthorName = dict["proposalAuthorName"] as! String
                let isActive = dict["isActive"] as! Bool

               
               // let articleID = "hi"
               // let articleID = dict["articleID"] as! String


                var topicID = ""
                
              /*  if dict["strURL"] is String{
                    //everything about the value works.
                    topicID = dict["strURL"] as! String
                }
                else{
                    topicID = snapshot.key.description
                    
                }
                */
                
                
             //   let postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
                
                
                var top = articleObject(
                    StrURL: strURL, StrArticleHeadline: strArticleHeadline, StrPicURL: strPicURL, StrPicSource: strPicSource, ArticleBias: articleBias, ArticleTopic: self.passedTopic.topicCategory, ArticleID: articleID, StrArticleAuthor: strArticleAuthor, ArticleTime: articleTime, ArticlePublisher: articlePublisher, ArticlePicDisplayType: articlePicDisplayType, RundownCount: rundownCount, StrRundownPoint1: strRundownPoint1, StrRundownPoint2: strRundownPoint2, StrRundownPoint3: strRundownPoint3, StrRundownPoint4: strRundownPoint4, StrRundownPoint5: strRundownPoint5, ProposalAuthorID: strAsrticleProposalAuthorID, ProposalAuthorName: strAsrticleProposalAuthorName, IsActive: isActive)
                
                if(isActive){

                self.lstArticles.append(top)
                }
                //self.collectionComments.reloadData()
                self.collectionArticles?.reloadData()
                
                
                
                
            }
        })
        
        
        ref!.child("BOOKMARKS").child(userID!).child(passedTopic.topicID).observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot.value.debugDescription)
            if((snapshot.exists())){
                self.btnBookmarkTopic.isEnabled = true
                self.btnBookmarkTopic.setBackgroundImage(#imageLiteral(resourceName: "icons8-bookmark-filled-40 (1)"), for: .normal, barMetrics: .default)
                self.isBookmarked = true
              
                
                
                
            }
            else{
                self.btnBookmarkTopic.isEnabled = true

                self.btnBookmarkTopic.setBackgroundImage(#imageLiteral(resourceName: "icons8-bookmark-40 (1)"), for: .normal, barMetrics: .default)

                self.isBookmarked = false

            }
        })
        
        userID = (Auth.auth().currentUser?.uid)!
        
        ref?.child("CHATLIKESHISTORY").child(userID!).child(passedTopic.topicID).queryLimited(toLast: 350).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? [Bool: Any] {
                let dataArray = Array(data)
                //the first va
                let keys = dataArray.map { $0.0 }
                
                let values = dataArray.map { $0.1 }
                self.userBoxLikeHistoryList = values.flatMap{String(describing: $0)}
                
                //  print(self.userBoxLikeHistoryList[0].description)
                
                
            }
        })
      
        btnBookmarkTopic.target = self;
        btnBookmarkTopic.action = #selector(bookmarkFunc(sender:));
        
        
       // btnBookmarkTopic.addTarget(self, action: #selector(bookmarkFunc(sender:)), for: .touchUpInside)
        
       
        
        ref?.child("TOPIC").child(passedTopic.topicID).child("isActive").observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? Bool
            
            {
                //data is a bool for isActive
                //if false, the topic was deactivated and will be removed from the user's bookmarks
                if(!data){
                
            let alert = UIAlertController(title: "Whoops!", message: "It looks like this news group has been removed!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { [weak alert] (_) in
                    
                    self.ref!.child("BOOKMARKS").child(self.userID!).child(self.passedTopic.topicID).setValue(nil);
                    self.navigationController?.popViewController(animated: true)

                    
                }))
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
                
            }
            }
            else{
                
            }
                
            
        })
        
        
    }
    
    @objc func bookmarkFunc(sender : UIButton) -> Void {
        
        if(btnBookmarkTopic.isEnabled ){
            if(isBookmarked){
                btnBookmarkTopic.setBackgroundImage(#imageLiteral(resourceName: "icons8-bookmark-40 (1)"), for: .normal, barMetrics: .default)
                
                ref!.child("BOOKMARKS").child(userID!).child(passedTopic.topicID).setValue(nil);
                isBookmarked = false;
            }
            else{
                let postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
                
                var top = bookmarkedObject (
                    StrBookmarkDate:postTime,
                    StrBookmarkDateInverse:-postTime,
                    Topic_Object:passedTopic)
                
                btnBookmarkTopic.setBackgroundImage(#imageLiteral(resourceName: "icons8-bookmark-filled-40 (1)"), for: .normal, barMetrics: .default)
                
                ref!.child("BOOKMARKS").child(userID!).child(passedTopic.topicID).setValue(top.toFBObject());
                isBookmarked = true;

            }
            
        }
    }
    

    @IBAction func btnFeedback(_ sender: Any) {
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "createArticleSuggestionViewController") as! createArticleSuggestionViewController

        secondViewController.proposalTopicID = passedTopic.topicID
        secondViewController.proposalTopicName = passedTopic.topicName
        
        
        // self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //  present(secondViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
        
        
        /*
        let alert = UIAlertController(title: "Feedback", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
  
        
        
        let post1Ref2 = ref?.childByAutoId()
        var postID = (post1Ref2?.key)!
        
        
        
        alert.addAction(UIAlertAction(title: "Give Feedback on Article Bias", style: .default, handler: { [weak alert] (_) in
 
            
            self.reviewTopic()
            
        }))
        alert.addAction(UIAlertAction(title: "Propose New Article", style: .default, handler: { [weak alert] (_) in
            self.proposeArticle()
            
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { [weak alert] (_) in
            
            
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        */
        
        
        
        
    }
    
    
    func pageFeedbackText() -> Void {
    
        
        /*
        let alert = UIAlertController(title: "Propose an article", message: "Pase a link here", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
      
        let textField = alert.textFields![0] // Force unwrapping because we know it exists.
   
        
        let post1Ref2 = ref?.childByAutoId()
        var postID = (post1Ref2?.key)!
        
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))

            var proposalArtt = proposedArticleObject(
                proposedURL:textField.text!,
                proposalAuthor:self.userID!, ProposalAuthorName: self.userFullName!,
                proposalTime:postTime
            )
            self.ref?.child("PROPOSED_ARTICLES").child(self.passedID).child(self.userID!).setValue(proposalArtt.toFBObject())
            
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "cancel", style: .default, handler: { [weak alert] (_) in
            
            
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        */
        
    }
    
    
    
    
    
    
    func pageFeedbackOpeningText() -> Void {
        
        
        
        let alert = UIAlertController(title: "Feedback", message: "Enter a text", preferredStyle: .alert)
        
        
        
        
        
        alert.addAction(UIAlertAction(title: "rate balance", style: .default, handler: { [weak alert] (_) in
            
        
            
            
        }))
        
        
        alert.addAction(UIAlertAction(title: "propose link", style: .default, handler: { [weak alert] (_) in
            self.pageFeedbackText()
         
            
        }))
        alert.addAction(UIAlertAction(title: "close", style: .default, handler: { [weak alert] (_) in
            
            
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    @objc func tapOnBottomView(_ gestureRecognizer: UITapGestureRecognizer) {
     /*   let topicChatViewController = self.storyboard?.instantiateViewController(withIdentifier: "topicChatViewController") as! topicChatViewController
        
        topicChatViewController.passedTopic = passedTopic
        
        // self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //  present(secondViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(topicChatViewController, animated: true)
        */
        
        
        let savingsInformationViewController = self.storyboard?.instantiateViewController(withIdentifier: "chatCreatePopoverViewController") as! chatCreatePopoverViewController
        
        //   savingsInformationViewController.delegate = self
        savingsInformationViewController.passedTopic = self.passedTopic
        savingsInformationViewController.passedTopicID = self.passedTopic.topicID.description
        
        
        savingsInformationViewController.modalPresentationStyle = .overFullScreen
        
        self.present(savingsInformationViewController, animated: true, completion: nil)
        
        
    }
    
   

    
    
    
}

