//
//  tabProfileViewController.swift
//  pamfti
//
//  Created by David A on 11/17/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage


class tabProfileViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collections.frame.width  * 0.1 , height: 292)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:profileCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileCollectionViewCell", for: indexPath) as! profileCollectionViewCell
        
        return cell
    }
    
    
    
    @IBOutlet weak var collections: UICollectionView!
    
    var ref:DatabaseReference?
    
    var userLat: Double?
    var userLong:Double?
    var dateString:String = "a"
    var creDate:String = ""
    var creNum:Int = 0
    var segmentCategoryType:String = "noted"
    var karmaModQualifyingLevel = 10000000
    var userKarmaLevel:Int?
    var lastAccountRefreshDate:CLong?
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfileImage: UIImageView!
    
  
    @IBOutlet weak var viewGTHistory: UIView!
    @IBOutlet weak var viewGTSettings: UIView!
    @IBOutlet weak var viewGTBookmarks: UIView!
    @IBOutlet weak var vieww: UIView!
    @IBOutlet weak var btnBookmarks: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet weak var btnInbox: UIButton!
    
    @IBOutlet weak var splitSectionView: UIView!
    @IBOutlet weak var lblUserKarma: UILabel!
    
    var userFullName = ""
    var userID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        userID = (Auth.auth().currentUser?.uid)!

        self.navigationController!.navigationBar.setTitleVerticalPositionAdjustment(+5, for: .default)

        
        let photoUrl:String = "https://graph.facebook.com/" + (Auth.auth().currentUser?.providerData[0].uid)! + "/picture?height=400";
        //txtUserName.text = String(  Date().timeIntervalSince1970 + 604800000 )
        
        let currentTime = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
        let date = NSDate(timeIntervalSince1970: TimeInterval(currentTime))
        let dayTimePeriodFormatter = DateFormatter()
        //dayTimePeriodFormatter.dateFormat = "MMM dd YYYY hh:mm a"
        dayTimePeriodFormatter.dateFormat = "Yd"
        dayTimePeriodFormatter.timeZone = NSTimeZone(name: TimeZone.current.abbreviation()!) as TimeZone!
        dateString = dayTimePeriodFormatter.string(from: date as Date)


 let imageUrl = URL(string: photoUrl)
 
      /* btnInbox.addTarget(self, action: #selector(gtInbox(sender:)), for: .touchUpInside)
        btnHistory.addTarget(self, action: #selector(gtHistory(sender:)), for: .touchUpInside)
        btnSettings.addTarget(self, action: #selector(gtSettings(sender:)), for: .touchUpInside)
        btnBookmarks.addTarget(self, action: #selector(gtBookmarks(sender:)), for: .touchUpInside)
        */

        let gesture = UITapGestureRecognizer(target: self, action: #selector(gtInbox(sender:)))
        self.vieww.addGestureRecognizer(gesture)
        
        let gesture2 = UITapGestureRecognizer(target: self, action: #selector(gtHistory(sender:)))
        self.viewGTHistory.addGestureRecognizer(gesture2)
        
        let gesture3 = UITapGestureRecognizer(target: self, action: #selector(gtSettings(sender:)))
        self.viewGTSettings.addGestureRecognizer(gesture3)
        
        let gesture4 = UITapGestureRecognizer(target: self, action: #selector(gtBookmarks(sender:)))
        self.viewGTBookmarks.addGestureRecognizer(gesture4)
        
        
//vieww.addTarget(self, action: #selector(gtInbox(sender:)), for: .touchUpInside)

 
 
 imgProfileImage.sd_setImage(with: imageUrl)
 // self.imageProfilePic.layer.cornerRadius = 10
 imgProfileImage.layer.cornerRadius = 5
 imgProfileImage.clipsToBounds = true
 imgProfileImage.layer.borderWidth = 0.5
 imgProfileImage.layer.borderColor =  #colorLiteral(red: 0.07058823529, green: 0.007843137255, blue: 0.2509803922, alpha: 1)
   
        splitSectionView.layer.cornerRadius = 5
        
        vieww.layer.cornerRadius = 5
        vieww.clipsToBounds = true
        vieww.layer.borderColor =  #colorLiteral(red: 0.07058823529, green: 0.007843137255, blue: 0.2509803922, alpha: 1)
        vieww.layer.borderWidth =  0.5

        viewGTHistory.layer.cornerRadius = 5
        viewGTHistory.clipsToBounds = true
        viewGTHistory.layer.borderColor =  #colorLiteral(red: 0.07058823529, green: 0.007843137255, blue: 0.2509803922, alpha: 1)
        viewGTHistory.layer.borderWidth =  0.5

        viewGTSettings.layer.cornerRadius = 5
        viewGTSettings.clipsToBounds = true
        viewGTSettings.layer.borderColor =  #colorLiteral(red: 0.07058823529, green: 0.007843137255, blue: 0.2509803922, alpha: 1)
        viewGTSettings.layer.borderWidth =  0.5

        viewGTBookmarks.layer.cornerRadius = 5
        viewGTBookmarks.clipsToBounds = true
        viewGTBookmarks.layer.borderColor =  #colorLiteral(red: 0.07058823529, green: 0.007843137255, blue: 0.2509803922, alpha: 1)
        viewGTBookmarks.layer.borderWidth =  0.5


   
        self.ref?.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let item = snapshot.value as? [String: AnyObject]{
                let uName = item["userName"]
                let uRating = item["userRating"]
                let userFullName = item["userFullName"]
                
                
                
                
                //Switched username and full name labels because it looked better
                /* self.userKarmaLevel = uRating as! Int
                 self.lblUserFullName.text = uName as? String
                 self.txtUsername.text = userFullName as? String
                 
                 
                 */
             /*   if(item["userName"] == nil){
                    
                    if let waiveUsername = UserDefaults.standard.object(forKey: "Username") as? String{
                        self.lblName.text = waiveUsername
                    }
                    else{
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let newViewController = storyBoard.instantiateViewController(withIdentifier: "usernameCreateViewController")
                        self.present(newViewController, animated: true, completion: nil)                    }
                    
                    
                }
                else{
                    let userName = item["userName"] as? String
                    
                    self.lblName.text = userName as? String
                    
                }
                
                */
                
                if(item["userRating"] == nil){
                    if let userRating = UserDefaults.standard.object(forKey: "userRating") as? Int{
                        
                        // self.lblUserKarmaa.text = "Karma: " + (userRating.description)
                        self.userKarmaLevel = userRating
                        self.lblUserKarma.text = "Axyl-IQ Score: " + (self.userKarmaLevel?.description)!
                    }
                    else{
                        // self.lblUserKarmaa.text = "Karma: 0"
                        self.userKarmaLevel = 0
                        
                    }
                }
                else{
                    let uRating = item["userRating"]
                    
                    self.userKarmaLevel = uRating as! Int
                    self.lblUserKarma.text = "Axyl-IQ Score: " + (self.userKarmaLevel?.description)!

                }
                
                
                self.lblName.text = (Auth.auth().currentUser?.displayName!)!
                
                
                
            }
            else{
                self.lblName.text = ""
            }
        })


}
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        
        userFullName = (Auth.auth().currentUser?.displayName!)!
        userID = (Auth.auth().currentUser?.uid)!
        
        
      
        
            self.lblName.text = userFullName
        
       /* if let userRating = UserDefaults.standard.object(forKey: "userRating") as? Int{
            
            //  self.lblUserKarmaa.text = "Karma: " + (userRating.description)
            self.userKarmaLevel = userRating
        }
        
        */
      
        
        
        
    }
    
    
    
    
    
    @objc func gtHistory(sender : UIButton) -> Void {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileHistoryViewController") as! profileHistoryViewController
        
        
        
        // self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //  present(secondViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(secondViewController, animated: true)

    }
    @objc func gtSettings(sender : UIButton) -> Void {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileSettingsTableViewController") as! profileSettingsTableViewController
        
   
        
        
        // self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //  present(secondViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    @objc func gtInbox(sender : UIButton) -> Void {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "profileInboxViewController") as! profileInboxViewController
        
        
        // self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //  present(secondViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    @objc func gtBookmarks(sender : UIButton) -> Void {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "bookmarkedTopicsViewController") as! bookmarkedTopicsViewController
        
        
        // self.navigationController?.pushViewController(secondViewController, animated: true)
        
        //  present(secondViewController, animated: true, completion: nil)
        
        self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
}
