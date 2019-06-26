//
//  createArticleSuggestionViewController.swift
//  pamfti
//
//  Created by David A on 12/18/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase

class createArticleSuggestionViewController: UIViewController {
    var userName: String!
    var userFullName = ""
    var userID = ""
    var ref:DatabaseReference?
    
    var proposalTopicName:String?
    var proposalTopicID:String?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
    }
    
   
    @IBAction func btnSubmit(_ sender: Any) {
        
        let postTime:CLong = (TimeZone.current.secondsFromGMT() + CLong(Date().timeIntervalSince1970))
        
        let post1Ref = ref?.childByAutoId()
        let postID = (post1Ref?.key)!
        
        
        
        var PAO = proposedArticleObject(  StrArticleURL:(txtArticleUrl.text?.description)!,
                                          ProposalAuthorID: userID,
                                          ProposalAuthorName:userFullName,
                                          
                                          proposalTime:postTime, RundownCount:3, StrRundownPoint1:(txtRundown1.text?.description)!, StrRundownPoint2:(txtRundown2.text?.description)!, StrRundownPoint3:(txtRundown3.text?.description)!, StrRundownPoint4:"", StrRundownPoint5:"" , strArticlePublisher:(txtPublisherName.text?.description)!, strArticleTitle:(txtArticleTitle.text?.description)!, PostID:postID, proposalTopicName: proposalTopicName!, proposalTopicID: proposalTopicID!, ProposalStatus: "PENDING", ProposalStatusDescription: "Awaiting Review")
        
        
        ref?.child("PROPOSED_ARTICLES").child(proposalTopicID!).child(postID).setValue(PAO.toFBObject())
        ref?.child("PROPOSED_ARTICLES_USER_HISTORY").child(userID).child(postID).setValue(PAO.toFBObject())

        
        navigationController?.popViewController(animated: true)


        
        
    }
    
    @IBOutlet weak var txtRundown3: UITextView!
    @IBOutlet weak var txtRundown2: UITextView!
    @IBOutlet weak var txtRundown1: UITextView!
   

    @IBOutlet weak var txtArticleUrl: UITextField!
    @IBOutlet weak var txtArticleTitle: UITextField!
    @IBOutlet weak var txtPublisherName: UITextField!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
