//
//  profileSettingsTableViewController.swift
//  pamfti
//
//  Created by David A on 11/21/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


class profileSettingsTableViewController: UITableViewController , UIPopoverPresentationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
        tableView.tableFooterView = UIView(frame: .zero)

    }

    // MARK: - Table view data source

   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            /*
            if let vc = self.storyboard?.instantiateViewController(withIdentifier:"newUserTutorialViewController") {
                vc.modalTransitionStyle   = .crossDissolve;
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
            }
            
            */
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
            //Change Username
            //  let url = URL(string: "https://www.freeprivacypolicy.com/privacy/view/5ae34555bd83ee1c9bc81feeaa87fcc8")!
            
            let url = URL(string: "http://triba.co/privacyPolicy.html")!
            
            
            
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        }
        if indexPath.section == 0 && indexPath.row == 2 {
            //Log Out
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                FBSDKLoginManager().logOut()
                //self.Username.text = ""
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            
            
            let myVC = storyboard?.instantiateViewController(withIdentifier: "fbLoginViewController") as! fbLoginViewController
            navigationController?.pushViewController(myVC, animated: true)
            
            
            
            
            
        }
        
        
        
        if indexPath.section == 3 && indexPath.row == 2 {
            //Deactivate Account
            /*
            
            let refreshAlert = UIAlertController(title: "Are you sure?", message: "All of your posts will be locked and you will lose all your Karma", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                let inverseTime = -self.postTime
                self.ref?.child("Users").child((Auth.auth().currentUser?.uid)!).child("ActiveStatus").setValue("INACTIVE")
                self.ref?.child("Users").child((Auth.auth().currentUser?.uid)!).child("userLastAccountResetDate").setValue(self.postTime)
                self.ref?.child("Users").child((Auth.auth().currentUser?.uid)!).child("userLastAccountResetDateInverse").setValue(inverseTime)
                self.ref?.child("notedPosts").child((Auth.auth().currentUser?.uid)!).setValue(nil)
                self.ref?.child("UsersNotedPostsIDList").child((Auth.auth().currentUser?.uid)!).setValue(nil)
                
                
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    FBSDKLoginManager().logOut()
                    //self.Username.text = ""
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
                
                let myVC = self.storyboard?.instantiateViewController(withIdentifier: "fbLoginPageViewController") as! fbLoginPageViewController
                self.navigationController?.pushViewController(myVC, animated: true)
                
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                
                
            }))
            
            
            self.present(refreshAlert, animated: true, completion: nil)
            
         */
            
            
            
            
            
        }
        
        
        //appSuggestionViewController
    }
    

}
