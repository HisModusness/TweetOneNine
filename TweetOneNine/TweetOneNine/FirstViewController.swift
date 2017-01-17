//
//  FirstViewController.swift
//  TweetOneNine
//
//  Created by Liam Westby on 1/16/17.
//  Copyright © 2017 DEC Microcomputer Software, Inc. All rights reserved.
//

import UIKit
import OAuthSwift

class FirstViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testConnection()
    }
    
    func testConnection() {
        print("Testing prefs")
        let conn = TwitterConnection.sharedInstance
        if (!conn.loggedIn) {
            conn.logIn()
        }
        
        _ = conn.oauth.client.get(
            "https://api.twitter.com/1.1/statuses/mentions_timeline.json", parameters: [:],
            success: { response in
                print("Test success")
                let jsonDict = try? response.jsonObject()
                print(jsonDict as Any)
        }, failure: { error in
            print(error)
        }
        )

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

