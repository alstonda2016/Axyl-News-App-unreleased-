//
//  profileBtn.swift
//  pamfti
//
//  Created by David A on 11/28/18.
//  Copyright © 2018 David A. All rights reserved.
//

import UIKit

class profileBtn: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            
            imageView!.contentMode = .scaleAspectFit

          /*  imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 35), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
 */
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 35), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
    }

}
