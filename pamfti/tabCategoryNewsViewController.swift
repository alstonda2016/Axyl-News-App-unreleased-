//
//  tabCategoryNewsViewController.swift
//  pamfti
//
//  Created by David A on 11/20/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SDWebImage

class tabCategoryNewsViewController: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var viewSegment: UIView!
    
    var handle: DatabaseHandle?
    var ref:DatabaseReference?
    var currentSegmentIndex:Int = 0
    var categoryString = "Item 1"

    var lstTopics:[topicObject] = []
    

    
   
    @IBAction func btnReload(_ sender: Any) {
        loadPosts(categoryType:self.currentSegmentIndex)
    }
    
    @IBAction func segmentNewsCategory(_ sender: Any) {
       
        switch (sender as AnyObject).selectedSegmentIndex{
            case 0:
                self.currentSegmentIndex = 0
                loadPosts(categoryType:0)

                //self.lblOrderCategoryDescription.text = "Newest Posts"
                UIView.animate(withDuration: 1, animations: {
                   
                  //  self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.289869281, green: 0.2431372549, blue: 0.8039215686, alpha: 1)
                })
                
                print("Norm")
            case 1:
                self.currentSegmentIndex = 1
                loadPosts(categoryType:1)

                //            self.lblOrderCategoryDescription.text = "Popular Conversations"
                
               // loadPostByChatCount(passedBoxList: boxListName)
                print("Chat")
                
                UIView.animate(withDuration: 1, animations: {
                    
                    
                 
                   // self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.1490196078, green: 0.6823529412, blue: 0.5647058824, alpha: 1)
                })
                
                
            case 2:
                self.currentSegmentIndex = 2
                loadPosts(categoryType:2)

               // self.lblOrderCategoryDescription.text = "Highest Rated Posts"
                
                print("Rank")
                
                UIView.animate(withDuration: 1, animations: {
                    
                    //    self.selectOrderSegmentObj.tintColor  = #colorLiteral(red: 0.1370565295, green: 0.6085740924, blue: 1, alpha: 1)
                    
                    
                    
                    //A
                    // self.view.gradientLayer.colors = [ #colorLiteral(red: 0.137254902, green: 0.6078431373, blue: 1, alpha: 1).cgColor,   UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, #colorLiteral(red: 0.1370565295, green: 0.6085740924, blue: 1, alpha: 1).cgColor]
                    
                    
                    
                    // self.selectOrderSegmentObj.layer.borderColor = #colorLiteral(red: 0.1370565295, green: 0.6085740924, blue: 1, alpha: 1)
                    
                    /*
                     self.selectOrderSegmentObj.tintColor  = #colorLiteral(red: 0.137254902, green: 0.7725490196, blue: 1, alpha: 1)
                     
                     self.view.gradientLayer.colors = [ #colorLiteral(red: 0.1370565295, green: 0.7736131549, blue: 1, alpha: 1).cgColor, UIColor.black.cgColor, UIColor.black.cgColor,  UIColor.black.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, #colorLiteral(red: 0.1370565295, green: 0.7736131549, blue: 1, alpha: 1).cgColor]
                     self.selectOrderSegmentObj.layer.borderColor = #colorLiteral(red: 0.1370565295, green: 0.7736131549, blue: 1, alpha: 1)
                     
                     */
                    // self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.1370565295, green: 0.7736131549, blue: 1, alpha: 1)
                   // self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.137254902, green: 0.6078431373, blue: 1, alpha: 1)
                })
                
            case 3:
                
                self.currentSegmentIndex = 3
                loadPosts(categoryType:3)

               // self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.8666666667, green: 0.231372549, blue: 0.4509803922, alpha: 1)
                
                UIView.animate(withDuration: 1, animations: {
               
                })
                
            default:
                print("hi")
            }
            
            
            
    
    }
    
    @IBOutlet weak var collectionNews: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lstTopics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width:  self.collectionNews.frame.width * 0.98 , height:  260)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell:topicCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "topicCategoryCollectionViewCell", for: indexPath) as! topicCategoryCollectionViewCell
        
        cell.lblTopicTitle.text = lstTopics[indexPath.row].topicName
        
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
        
        ref = Database.database().reference()
        self.navigationController!.navigationBar.setTitleVerticalPositionAdjustment(+5, for: .default)

        
        viewSegment.addSubview(segmentedControlContainerView)
        segmentedControlContainerView.addSubview(segmentedControl)
        segmentedControlContainerView.addSubview(bottomUnderlineView)
        
        // Constrain the container view to the view controller
        let safeLayoutGuide = self.viewSegment.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            segmentedControlContainerView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            segmentedControlContainerView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            segmentedControlContainerView.widthAnchor.constraint(equalTo: safeLayoutGuide.widthAnchor),
            //segmentedControlContainerView.heightAnchor.constraint(equalToConstant: Constants.segmentedControlHeight)
            segmentedControlContainerView.heightAnchor.constraint(equalTo: safeLayoutGuide.heightAnchor)
            ])
        
        // Constrain the segmented control to the container view
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlContainerView.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlContainerView.leadingAnchor),
            segmentedControl.centerXAnchor.constraint(equalTo: segmentedControlContainerView.centerXAnchor),
            segmentedControl.centerYAnchor.constraint(equalTo: segmentedControlContainerView.centerYAnchor)
            ])
        
        // Constrain the underline view relative to the segmented control
        NSLayoutConstraint.activate([
            bottomUnderlineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            bottomUnderlineView.heightAnchor.constraint(equalToConstant: Constants.underlineViewHeight),
            leadingDistanceConstraint,
            bottomUnderlineView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments))
            ])
        
        
        
        
        
        
     loadPosts(categoryType:0)
    }
    

    func loadPosts(categoryType:Int) -> Void {
        ref?.child("CATEGORIES").child(categoryString).removeAllObservers()

        if(categoryType == 0){
            categoryString = "Item 1"

        }
        else if(categoryType == 1){
            categoryString = "Item 2"

        }
        else if(categoryType == 2){
            categoryString = "Item 3"

        }
        else if(categoryType == 3){
            categoryString = "Item 4"

        }

        else{
            categoryString = "Item 1"
        }
        
        
        lstTopics.removeAll()
        collectionNews.reloadData()
        
        
        
        ref?.child("CATEGORIES").child(categoryString).queryLimited(toLast: 350).observe(.childAdded, with: { (snapshot) in
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
    
    
    
    private enum Constants {
        static let segmentedControlHeight: CGFloat = 40
        static let underlineViewColor: UIColor = .white
        static let underlineViewHeight: CGFloat = 2
    }
    
    // Container view of the segmented control
    private lazy var segmentedControlContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    // Customised segmented control
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        
        // Remove background and divider colors
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        
        // Append segments
        segmentedControl.insertSegment(withTitle: "US News", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "World News", at: 1, animated: true)
        segmentedControl.insertSegment(withTitle: "Other", at: 2, animated: true)
        
        // Select first segment by default
        segmentedControl.selectedSegmentIndex = 0
        
        // Change text color and the font of the NOT selected (normal) segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.09165070206, green: 0.04300837219, blue: 0.3195667267, alpha: 1),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)], for: .normal)
        
        // Change text color and the font of the selected segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.09165070206, green: 0.04300837219, blue: 0.3195667267, alpha: 1),
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .bold)], for: .selected)
        
        // Set up event handler to get notified when the selected segment changes
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        // Return false because we will set the constraints with Auto Layout
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    // The underline view below the segmented control
    private lazy var bottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = Constants.underlineViewColor
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()
    
    private lazy var leadingDistanceConstraint: NSLayoutConstraint = {
        return bottomUnderlineView.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor)
    }()
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        changeSegmentedControlLinePosition()
    }
    
    // Change position of the underline
    private func changeSegmentedControlLinePosition() {
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
       // loadPosts(categoryType:1)

        loadPosts(categoryType:Int(segmentIndex))

        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 2, animations: { [weak self] in
            self?.leadingDistanceConstraint.constant = leadingDistance
            self?.loadViewIfNeeded()
        })
    }

}
