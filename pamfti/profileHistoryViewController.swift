//
//  profileHistoryViewController.swift
//  pamfti
//
//  Created by David A on 11/21/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage



class profileHistoryViewController: UIViewController ,  UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    
    
    var passedID:String!
    var passedTopic:topicObject!
    
    var userID = ""

    var handle: DatabaseHandle?
    var isEmpty:Bool = false



    var ref:DatabaseReference?
    
    var lstArticles:[historyArticleObject] = []
    var postChatList:[topicChatPostObject] = []
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width:  self.collectionHistory.frame.width * 0.98 , height:  259)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(isEmpty){
            return 1
        }
        return lstArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if(isEmpty){
            
            let cell:profileHistoryCollectionViewCellEMPTY = collectionView.dequeueReusableCell(withReuseIdentifier: "profileHistoryCollectionViewCellEMPTY", for: indexPath) as! profileHistoryCollectionViewCellEMPTY
            
            
            
            
            return cell;
            
        }
        else{
            
        let cell:profileHistoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileHistoryCollectionViewCell", for: indexPath) as! profileHistoryCollectionViewCell
        
       cell.lblHeadline.text = lstArticles[indexPath.row].article_Object.strArticleHeadline
        
        let urll = URL(string: lstArticles[indexPath.row].article_Object.strPicURL)
        
        
        cell.imgImg.sd_setImage(with: urll)
        cell.imgImg.contentMode = .scaleAspectFill
        
        cell.imgImg.layer.cornerRadius = 12
        cell.imgImg.clipsToBounds = true
 
        let endDate = NSDate(timeIntervalSince1970: TimeInterval((lstArticles[indexPath.row].strHistoryDate) - TimeZone.current.secondsFromGMT()  ))
        let dateFormatter = DateFormatter()
        //dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        let localDate2 = dateFormatter.string(from: endDate as Date)
        cell.lblUserHistoryDate.text = "Read on " + localDate2
        
        return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
      
        /*
        
        guard let url = URL(string: lstArticles[indexPath.row].article_Object.strPicURL) else {
            return true //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
        */
        
        
        
        
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "webViewViewController") as! webViewViewController
        secondViewController.passedURL = lstArticles[indexPath.row].article_Object.strURL.description
        secondViewController.passedWebsiteTopic = lstArticles[indexPath.row].article_Object.articlePublisher.description

        
        // self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //  present(secondViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
        
        
        return true;
        
    }
    
    
    
    @IBOutlet weak var collectionHistory: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        
        userID = (Auth.auth().currentUser?.uid)!
        

        var strHistoryDate:CLong = 0
        var strHistoryDateInverse:CLong = 0
        
        var article_Object:articleObject!

        
        ref?.child("USERVIEWHISTORY").child(userID).observe(DataEventType.value, with: { (snapshot) in
            
            
            if(snapshot.exists()){
                
                
                self.isEmpty = false
                
                
                
                
            }
            else{
                self.isEmpty = true
                
            }
            
            
            
        })
        
        ref?.child("USERVIEWHISTORY").child(userID).queryLimited(toLast: 350).observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
                //    let postID = dict["name"] as! String
                let historyDate = dict["strHistoryDate"] as! CLong
                let historyDateInverse = dict["strHistoryDateInverse"] as! CLong
                let article_Object = dict["article_Object"] as! [String: Any]
                
        
                
                let strArticleHeadline = article_Object["strArticleHeadline"] as! String
                let strURL = article_Object["strURL"] as! String
                let strPicURL = article_Object["strPicURL"] as! String
                let strPicSource = article_Object["strPicSource"] as! String
                let articleBias = article_Object["articleBias"] as! Int
                let strArticleAuthor = article_Object["strArticleAuthor"] as! String
                let articleTime = article_Object["articleTime"] as! CLong
                let articlePublisher = article_Object["articlePublisher"] as! String
                let articlePicDisplayType = article_Object["articlePicDisplayType"] as! String
                let articleID = article_Object["articleID"] as! String
                let rundownCount = article_Object["rundownCount"] as! Int
                let strRundownPoint1 = article_Object["strRundownPoint1"] as! String
                let strRundownPoint2 = article_Object["strRundownPoint2"] as! String
                let strRundownPoint3 = article_Object["strRundownPoint3"] as! String
                let strRundownPoint4 = article_Object["strRundownPoint4"] as! String
                let strRundownPoint5 = article_Object["strRundownPoint5"] as! String
                let strAsrticleProposalAuthorID = article_Object["strAsrticleProposalAuthorID"] as! String
                let strAsrticleProposalAuthorName = article_Object["strAsrticleProposalAuthorName"] as! String
                let isActive = article_Object["isActive"] as! Bool

                
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
                
                var aHistoryObject = historyArticleObject(StrHistoryDate:historyDate,
                                                          StrHistoryDateInverse:historyDateInverse,
                                                          Article_Object:top)
                
                
           
                
                
              
                
                
                self.lstArticles.append(aHistoryObject)
                //self.collectionComments.reloadData()
                self.collectionHistory?.reloadData()
                
                
                
                
            }
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
