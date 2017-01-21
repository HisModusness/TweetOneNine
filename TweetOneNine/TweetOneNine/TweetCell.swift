//
//  TweetCell.swift
//  TweetOneNine
//
//  Created by Liam Westby on 1/21/17.
//  Copyright © 2017 DEC Microcomputer Software, Inc. All rights reserved.
//

import Foundation
import UIKit

class TweetCell: UITableViewCell {
    static let identifier = "TweetCell"
    static let nibName="TweetCell"
    static let estimatedRowHeight: CGFloat = 75
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetLabel.numberOfLines = 0
        tweetLabel.sizeToFit()
    }
}
