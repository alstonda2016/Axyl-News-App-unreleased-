//
//  tabNewsViewController.swift
//  pamfti
//
//  Created by David A on 11/17/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage


class tabNewsViewController: UIViewController ,  UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    
    var handle: DatabaseHandle?
    var ref:DatabaseReference?
    
    var lstTopics:[topicObject] = []
    var userID = ""

    
    
    @IBAction func btnReload(_ sender: Any) {
        
        ref?.child("TOPIC").queryOrdered(byChild: "topicCreationTimeInverse").queryLimited(toLast: 350).observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
                //    let postID = dict["name"] as! String
                let strPicURL = dict["strPicURL"] as! String
                let topicName = dict["topicName"] as! String
                let strPicSource = dict["strPicSource"] as! String
                let isActive = dict["isActive"] as! Bool

                var topicCategory = ""
                
                var topicID = ""
                
                if dict["topicID"] is String{
                    //everything about the value works.
                    topicID = dict["topicID"] as! String
                }
                else{
                    topicID = snapshot.key.description
                    
                }
                
                
                if dict["topicCategory"] is String{
                    //everything about the value works.
                    topicCategory = dict["topicCategory"] as! String
                }
                else{
                    topicCategory = "none"
                    
                }
                
                
                var postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
                
                
                
                if dict["topicCreationTime"] is CLong{
                    //everything about the value works.
                    postTime = dict["topicCreationTime"] as! CLong
                }
                
                let isOngoing = dict["isOngoing"] as! Bool

                var top = topicObject( TopicName:topicName,
                                       StrPicURL:strPicURL, TopicID: topicID, TopicCreationTime: postTime, TopicCreationTimeInverse: -postTime,
                                       StrPicSource:strPicSource, TopicCategory: topicCategory, IsActive: isActive, IsOngoing: isOngoing
                )
                
                if(isActive){
                self.lstTopics.append(top)
                }
                //self.collectionComments.reloadData()
                self.collectionNews?.reloadData()
                
                
                
                
            }
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return lstTopics.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width:  self.collectionNews.frame.width * 0.98 , height:  260)
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:tabNewsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabNewsCollectionViewCell", for: indexPath) as! tabNewsCollectionViewCell
        
        cell.txtTitle.text = lstTopics[indexPath.row].topicName
        
        let urll = URL(string: lstTopics[indexPath.row].strPicURL)

        
        cell.imgImg.sd_setImage(with: urll)
        //cell.imgImg.contentMode = .scaleAspectFit
        cell.imgImg.contentMode = .scaleAspectFill
        
        cell.imgImg.layer.cornerRadius = 12
        cell.imgImg.clipsToBounds = true

        //cell.lblReportNumber.text = lstRegions[indexPath.row].reportCount.description
        
        let endDate = NSDate(timeIntervalSince1970: TimeInterval((lstTopics[indexPath.row].topicCreationTime) - TimeZone.current.secondsFromGMT()  ))
        let dateFormatter = DateFormatter()
        //dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        let localDate2 = dateFormatter.string(from: endDate as Date)
        cell.lblTopicTime.text = localDate2
        
        // Configure the cell
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
       /* let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "regionLevel3ViewController") as! regionLevel3ViewController
        
        secondViewController.passedRegionLevel1 = passedRegionLevel1
        secondViewController.passedRegionLevel2 = reportTypeList[indexPath.row]
        
        // self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //  present(secondViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
        */
        
       
        
         let postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
        let idDesc = lstTopics[indexPath.row].topicID.description
        let topicCategory = lstTopics[indexPath.row].topicCategory.description

        
        ref?.child("TOPIC_CLICK_LIST").child(topicCategory).child(idDesc).child(userID).setValue(postTime)
        
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "newsTopicArticlesViewController") as! newsTopicArticlesViewController
        
        secondViewController.passedID = lstTopics[indexPath.row].topicID
        secondViewController.passedTopic = lstTopics[indexPath.row]

        
        // self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //  present(secondViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(secondViewController, animated: true)

        
        
        /*
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "newsTopicArticlesViewController") as! newsTopicArticlesViewController
        newViewController.passedID = lstTopics[indexPath.row].topicID
        
        self.present(newViewController, animated: true, completion: nil)
        */
        
        
        
        return true
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userID = (Auth.auth().currentUser?.uid)!

        
        ref = Database.database().reference()
        self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.09165070206, green: 0.04300837219, blue: 0.3195667267, alpha: 1)

        self.navigationController!.navigationBar.setTitleVerticalPositionAdjustment(+5, for: .default)
        
        ref?.child("TOPIC").queryOrdered(byChild: "topicCreationTimeInverse").queryLimited(toLast: 350).observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject]{
            //    let postID = dict["name"] as! String
                let strPicURL = dict["strPicURL"] as! String
                let topicName = dict["topicName"] as! String
                let strPicSource = dict["strPicSource"] as! String

                var topicCategory = ""

                var topicID = ""
                
                if dict["topicID"] is String{
                    //everything about the value works.
                    topicID = dict["topicID"] as! String
                }
                else{
                    topicID = snapshot.key.description

                }
                
                
                if dict["topicCategory"] is String{
                    //everything about the value works.
                    topicCategory = dict["topicCategory"] as! String
                }
                else{
                    topicCategory = "none"
                    
                }
               let isActive = dict["isActive"] as! Bool
                let isOngoing = dict["isOngoing"] as! Bool
             
                var postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))

                
                
                if dict["topicCreationTime"] is CLong{
                    //everything about the value works.
                    postTime = dict["topicCreationTime"] as! CLong
                }
                
                
                var top = topicObject( TopicName:topicName,
                                       StrPicURL:strPicURL, TopicID: topicID, TopicCreationTime: postTime, TopicCreationTimeInverse: -postTime,
                                       StrPicSource:strPicSource, TopicCategory: topicCategory, IsActive: isActive, IsOngoing: isOngoing
                )
                
                
                if(isActive){
                    self.lstTopics.append(top)
                }                //self.collectionComments.reloadData()
                self.collectionNews?.reloadData()
                
                
                
                
            }
        })
        
        
    }
    
    @IBOutlet weak var collectionNews: UICollectionView!
    
    
    

}
