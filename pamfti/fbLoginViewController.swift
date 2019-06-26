//
//  fbLoginViewController.swift
//  pamfti
//
//  Created by David A on 11/17/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase
//import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class fbLoginViewController: UIViewController {
    
    
    var isAccountMessedUp:Bool = false
    var ref:DatabaseReference?
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /*
         let gradient = CAGradientLayer()
         
         // gradient colors in order which they will visually appear
         gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
         
         // Gradient from left to right
         gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
         gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
         
         // set the gradient layer to the same size as the view
         gradient.frame = viewBackgroundText.bounds
         // add the gradient layer to the views layer for rendering
         viewBackgroundText.layer.addSublayer(gradient)
         // viewBackgroundText.addSubview(lblBackgroundText)
         
         let label = UILabel(frame: view.bounds)
         label.text = lblBackgroundText.text
         label.numberOfLines = 100
         // label.font = UIFont.boldSystemFont(ofSize: 30)
         label.textAlignment = .justified
         viewBackgroundText.addSubview(label)
         
         
         
         // Tha magic! Set the label as the views mask
         viewBackgroundText.mask = label
         */
        
        //let backImage = #imageLiteral(resourceName: "gradientTest")
        //  backImage.set
        
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        
        
        btnLogin.addTarget(self, action: #selector(nSignIn), for: .touchUpInside)
        self.navigationController?.isNavigationBarHidden = true
        
        /*  btnLogin.layer.masksToBounds = true
         btnLogin.layer.cornerRadius = 20;
         btnLogin.layer.borderColor =  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
         btnLogin.layer.borderWidth = 1
         */
        
        ref = Database.database().reference()
        
        
        btnLogin.layer.cornerRadius = 12
        btnLogin.clipsToBounds = true
       
        
        if Auth.auth().currentUser != nil {
            
           // btnLogin.isHidden = true
            //self.btnLogin.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self.btnLogin.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), for: .normal)

            self.btnLogin.isEnabled = false

            //self.view.makeToastActivity(.bottom)
            // superview.frame.size.width / 2 - width / 2,
            // y: superview.frame.height / 2 - height / 2
            // activityIndicator.frame.origin = CGPoint(x: 50 , y: 100)//Set the origin related to your button
            
            // popOverVC.view.frame = self.view.frame
            
            let width = view.frame.size.width / 2.3
            let height: CGFloat = 50.0
            activityIndicator.frame.origin = CGPoint(x: self.view.frame.size.width * 0.5  , y: self.view.frame.height * 0.8 )//Set the origin related to your button
            
            //activityIndicator.center = self.view.
            activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2);
            
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.gray
            activityIndicator.color = #colorLiteral(red: 0.09165070206, green: 0.04300837219, blue: 0.3195667267, alpha: 1)
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
        }
        else{
            
           // btnLogin.isHidden = false
           // self.btnLogin.tintColor = #colorLiteral(red: 0.5704988837, green: 0.2374570668, blue: 1, alpha: 1)
            self.btnLogin.setTitleColor(#colorLiteral(red: 0.09165070206, green: 0.04300837219, blue: 0.3195667267, alpha: 1), for: .normal)

            self.btnLogin.isEnabled = true

            //self.view.hideToast()
            self.activityIndicator.stopAnimating()
            
        }
        
        
        
        
        let accessToken = FBSDKAccessToken.current()
        if accessToken?.tokenString == nil && Auth.auth().currentUser != nil {
            
            let firebaseAuth = Auth.auth()
            do {
                //This occurs when the user is basically half-signed in and half-signed out due to
                //previously updating the app. This status essentially keeps the user in a sign-in purgatory
                //by signing out of both Firebase and FBSDK, we are breaking out of the purgatory.
                try firebaseAuth.signOut()
                FBSDKLoginManager().logOut()
                //self.view.hideToastActivity()
                self.activityIndicator.stopAnimating()
                
                
                //self.Username.text = ""
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }
        
        
        //This occurs when the user is already signed in
        if Auth.auth().currentUser != nil {
            
            
            let user = Auth.auth().currentUser
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
            user?.reauthenticate(with: credential) { error in
                if error != nil {
                    // An error happened.
                    
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                        FBSDKLoginManager().logOut()
                    } catch let signOutError as NSError {
                        print ("Error signing out: %@", signOutError)
                    }
                   // self.btnLogin.isHidden = false
                    self.btnLogin.setTitleColor(#colorLiteral(red: 0.09165070206, green: 0.04300837219, blue: 0.3195667267, alpha: 1), for: .normal)

                    self.btnLogin.isEnabled = true

                    //self.view.hideToast()
                    self.activityIndicator.stopAnimating()
                    
                    //Blame the error on their phones...not us
                    let alert = UIAlertController(title: "Connection Error", message: "Please check cellular connection and sign-in again.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default) { (alert: UIAlertAction!) -> Void in
                        
                    }
                    
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion:nil)
                    
                } else {
                    // self.view.hideToast()
                    self.activityIndicator.stopAnimating()
                    
                    //Sign in is cleared, go to the home page
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabHome")
                    self.present(newViewController, animated: true, completion: nil)
                    
                    
                }
            }
            
            if Auth.auth().currentUser != nil {
                
            }
            
        }
        else{
            
            //User is not signed in so the login button appears
            
           // btnLogin.isHidden = false
            self.btnLogin.setTitleColor(#colorLiteral(red: 0.09165070206, green: 0.04300837219, blue: 0.3195667267, alpha: 1), for: .normal)

            //self.btnLogin.tintColor = #colorLiteral(red: 0.5704988837, green: 0.2374570668, blue: 1, alpha: 1)
            self.btnLogin.isEnabled = true

            
        }    }
    
    @IBOutlet weak var btnLogin: UIButton!
    
    @objc func nSignIn() {
        let fbLoginManager = FBSDKLoginManager()
        //  self.view.makeToastActivity(.bottom)
        
        // activityIndicator.frame.origin = CGPoint(x: 50 , y: 100)//Set the origin related to your button
        activityIndicator.frame.origin = CGPoint(x: self.view.frame.size.width * 0.5  , y: self.view.frame.height * 0.8 )
        //activityIndicator.center = self.view.
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2);
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.color = #colorLiteral(red: 0.09165070206, green: 0.04300837219, blue: 0.3195667267, alpha: 1)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
       // btnLogin.isHidden = true
        self.btnLogin.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), for: .normal)

       // self.btnLogin.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.btnLogin.isEnabled = false

        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                //self.btnLogin.isHidden = false
                self.btnLogin.setTitleColor(#colorLiteral(red: 0.09165070206, green: 0.04300837219, blue: 0.3195667267, alpha: 1), for: .normal)

                self.btnLogin.isEnabled = true

                //self.view.hideToastActivity()
                self.activityIndicator.stopAnimating()
                
                
                return
            }
            
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
               // self.btnLogin.isHidden = false
                self.btnLogin.setTitleColor(#colorLiteral(red: 0.09165070206, green: 0.04300837219, blue: 0.3195667267, alpha: 1), for: .normal)

                self.btnLogin.isEnabled = true

                //self.view.hideToastActivity()
                self.activityIndicator.stopAnimating()
                
                
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    //Blame the error on their phones...not us
                    let alertController = UIAlertController(title: "Connection Error", message: "Please check cellular connection and sign-in again.", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                   // self.btnLogin.isHidden = false
                    self.btnLogin.setTitleColor(#colorLiteral(red: 0.09165070206, green: 0.04300837219, blue: 0.3195667267, alpha: 1), for: .normal)

                    self.btnLogin.isEnabled = true

                    
                    //self.view.hideToastActivity()
                    self.activityIndicator.stopAnimating()
                    
                    
                    
                    return
                }
                
                
                
                
                if (Auth.auth().currentUser != nil) {
                    
                    
                    
                    
                    
                    self.ref = Database.database().reference()
                    self.ref?.child("Users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        //username string
                        var uName = ""
                        
                        //If everything is there
                        if (snapshot.hasChild("userID")
                            && snapshot.hasChild("userProfilePic") && snapshot.hasChild("ActiveStatus")  &&  snapshot.hasChild("userName") && snapshot.hasChild("userFullName")  ){
                            
                            
                            if let item = snapshot.value as? [String: AnyObject]{
                                
                                if item["userName"] is String{
                                    //everything about the value works.
                                    uName = item["userName"] as! String
                                }
                                
                                //uName = item["userName"] as! String
                                var uActiveStatus = ""
                                if(item["ActiveStatus"] != nil){
                                    
                                    if item["ActiveStatus"] is String{
                                        //everything about the value works.
                                        uActiveStatus = item["ActiveStatus"] as! String
                                    }
                                }
                                
                                var uAccountResetDate = 0
                                var userStrikes = 0
                                
                                //userLastAccountResetDate isn't checked for in the if conditionals
                                //This just makes sure nothing crashes
                                if(item["userLastAccountResetDate"] != nil){
                                    
                                    
                                    if item["userLastAccountResetDate"] is CLong{
                                        //everything about the value works.
                                        uAccountResetDate = item["userLastAccountResetDate"] as! CLong
                                    }
                                    
                                }
                                
                                if(item["userStrikes"] != nil){
                                    
                                    //  userStrikes = item["userStrikes"] as! Int
                                    
                                    if item["userStrikes"] is Int{
                                        //everything about the value works.
                                        userStrikes = item["userStrikes"] as! Int
                                    }
                                    
                                }
                                
                                //Reload everything if the account had been deactivated by the user
                                if(uActiveStatus == "INACTIVE"){
                                    let autoKomKey = "P"+(self.ref?.childByAutoId().key)!
                                    let photoUrl:String = "https://graph.facebook.com/" + (Auth.auth().currentUser?.providerData[0].uid)! + "/picture?height=400";
                                    
                                    
                                    
                                    
                                    let inverseDate = -uAccountResetDate
                                    
                                    let post:[String : AnyObject] = [
                                        "ActiveStatus":"ACTIVE" as AnyObject,
                                        "userID":Auth.auth().currentUser?.uid as AnyObject,
                                        "inviteKey": autoKomKey as AnyObject,
                                        "userFullName":Auth.auth().currentUser?.displayName as AnyObject,
                                        "userProfilePic":photoUrl as AnyObject,
                                        "userName":Auth.auth().currentUser?.displayName as AnyObject,
                                        "notedPostsNumber": 0 as AnyObject,
                                        "userAllowedAccessDate": 0 as AnyObject,
                                        "userUniverstiyVerificationEmail":"none" as AnyObject,
                                        "userAccessLevel":"NORMAL" as AnyObject,
                                        "userNecessaryAlertType":"none" as AnyObject,
                                        "userNecessaryAlertType2":"none" as AnyObject,
                                        "userRating":0 as AnyObject,
                                        "userLastAccountResetDate": uAccountResetDate as AnyObject,
                                        "userLastAccountResetDateInverse":inverseDate as AnyObject,
                                        "userStrikes":userStrikes as AnyObject,
                                        "showUserStrikeAlert":false as AnyObject
                                        
                                        
                                        
                                        
                                    ]
                                    self.ref?.child("Users").child((Auth.auth().currentUser?.uid)!).setValue(post)
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                                
                                //Sets uName for later use in the app
                                UserDefaults.standard.set(uName, forKey: "Username")
                                
                                //Go to home page
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabHome")
                                self.present(newViewController, animated: true, completion: nil)
                                
                                
                            }
                            
                            
                            
                        }
                            
                            //Has everything except the username
                        else if (snapshot.hasChild("userID")
                            && snapshot.hasChild("userProfilePic") && snapshot.hasChild("ActiveStatus") &&  !snapshot.hasChild("userName")  && snapshot.hasChild("userFullName")){
                            
                            
                            
                            if let item = snapshot.value as? [String: AnyObject]{
                                var uActiveStatus = ""
                                
                                if(item["ActiveStatus"] != nil){
                                    
                                    if item["ActiveStatus"] is String{
                                        //everything about the value works.
                                        uActiveStatus = item["ActiveStatus"] as! String
                                    }
                                }
                                
                                var userStrikes = 0
                                
                                var uAccountResetDate = 0
                                //userLastAccountResetDate isn't checked for in the if conditionals
                                //This just makes sure nothing crashes
                                /* if(item["userLastAccountResetDate"] != nil){
                                 
                                 uAccountResetDate = item["userLastAccountResetDate"] as! CLong
                                 
                                 }
                                 */
                                
                                if(item["userLastAccountResetDate"] != nil){
                                    
                                    if item["userLastAccountResetDate"] is CLong{
                                        //everything about the value works.
                                        uAccountResetDate = item["userLastAccountResetDate"] as! CLong
                                    }
                                }
                                
                                /*
                                 if(item["userStrikes"] != nil){
                                 
                                 userStrikes = item["userStrikes"] as! Int
                                 
                                 
                                 
                                 }
                                 
                                 */
                                if(item["userStrikes"] != nil){
                                    
                                    if item["userStrikes"] is Int{
                                        //everything about the value works.
                                        userStrikes = item["userStrikes"] as! Int
                                    }
                                }
                                
                                //Reload everything if the account had been deactivated by the user
                                if(uActiveStatus == "INACTIVE"){
                                    
                                    let autoKomKey = "P"+(self.ref?.childByAutoId().key)!
                                    let photoUrl:String = "https://graph.facebook.com/" + (Auth.auth().currentUser?.providerData[0].uid)! + "/picture?height=400";
                                    
                                    
                                    
                                    let inverseDate = -uAccountResetDate
                                    //Has all user attributes except username, which the user will set next
                                    let post:[String : AnyObject] = [
                                        "ActiveStatus":"ACTIVE" as AnyObject,
                                        "userID":Auth.auth().currentUser?.uid as AnyObject,
                                        "inviteKey": autoKomKey as AnyObject,
                                        "userFullName":Auth.auth().currentUser?.displayName as AnyObject,
                                        "userProfilePic":photoUrl as AnyObject,
                                        "notedPostsNumber": 0 as AnyObject,
                                        "userAllowedAccessDate": 0 as AnyObject,
                                        "userUniverstiyVerificationEmail":"none" as AnyObject,
                                        "userAccessLevel":"NORMAL" as AnyObject,
                                        "userNecessaryAlertType":"none" as AnyObject,
                                        "userNecessaryAlertType2":"none" as AnyObject,
                                        "userRating":0 as AnyObject,
                                        "userLastAccountResetDate": uAccountResetDate as AnyObject,
                                        "userLastAccountResetDateInverse":inverseDate as AnyObject,
                                        "userStrikes":userStrikes as AnyObject,
                                        "showUserStrikeAlert":false as AnyObject,
                                        "userName":Auth.auth().currentUser?.displayName as AnyObject

                                        
                                        
                                        
                                        
                                    ]
                                    self.ref?.child("Users").child((Auth.auth().currentUser?.uid)!).setValue(post)
                                    
                                    
                                    
                                    
                                    
                                    //go to username page
                                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabHome")
                                    self.present(newViewController, animated: true, completion: nil)
                                }
                                
                                
                                
                                
                                //Signs in
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabHome")
                                self.present(newViewController, animated: true, completion: nil)
                                
                                
                                
                                
                                
                            }
                            
                            
                            
                            if(uName.isEmpty ){
                                //Basically, If the username is still not there somehow, it goes to the username set up page
                                
                                
                                
                                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabHome")
                                self.present(newViewController, animated: true, completion: nil)
                            }
                            
                            
                            
                            
                        }
                            
                            
                            //If nether account info nor username are there
                        else{
                            
                            //creates user account
                            //YAY! A NEW USER!!!!
                            
                            let autoKomKey = "P"+(self.ref?.childByAutoId().key)!
                            let photoUrl:String = "https://graph.facebook.com/" + (Auth.auth().currentUser?.providerData[0].uid)! + "/picture?height=400";
                            let post:[String : AnyObject] = [
                                "ActiveStatus":"ACTIVE" as AnyObject,
                                "userID":Auth.auth().currentUser?.uid as AnyObject,
                                "inviteKey": autoKomKey as AnyObject,
                                "userFullName":Auth.auth().currentUser?.displayName as AnyObject,
                                "userName":Auth.auth().currentUser?.displayName  as AnyObject,
                                "userProfilePic":photoUrl as AnyObject,
                                "notedPostsNumber": 0 as AnyObject,
                                "userRating": 0 as AnyObject,
                                "userAllowedAccessDate": 0 as AnyObject,
                                "userAccessLevel":"NORMAL" as AnyObject,
                                "userNecessaryAlertType":"none" as AnyObject,
                                "userNecessaryAlertType2":"none" as AnyObject,
                                "userUniverstiyVerificationEmail":"none" as AnyObject,
                                "userLastAccountResetDate": 0 as AnyObject,
                                "userLastAccountResetDateInverse":0 as AnyObject,
                                "userStrikes":0 as AnyObject,
                                "showUserStrikeAlert":false as AnyObject
                                
                                
                                
                                
                                
                                
                            ]
                            self.ref?.child("Users").child((Auth.auth().currentUser?.uid)!).setValue(post)
                            
                            
                            //Goes to username setup
                            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                            let newViewController = storyBoard.instantiateViewController(withIdentifier: "tabHome")
                            self.present(newViewController, animated: true, completion: nil)
                            
                        }
                        
                        
                    })
                    
                    
                }
                
            })
            
        }
        
        //If there is some error with sign in and it takes longer than 30 seconds, the sign in button will appear again and the
        //loading animation will disappear
        DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
            //self.view.hideToastActivity()
            self.activityIndicator.stopAnimating()
            
            //self.btnLogin.isHidden = false
            self.btnLogin.isEnabled = true
            self.btnLogin.setTitleColor(#colorLiteral(red: 0.09165070206, green: 0.04300837219, blue: 0.3195667267, alpha: 1), for: .normal)

            
            
        }
        
    }
}
func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
    if let error = error {
        print(error.localizedDescription)
        return
    }
    
    
}

func submitForms() {
    let accessToken = FBSDKAccessToken.current()
    guard let accessTokenString = accessToken?.tokenString else {
        return }
}


