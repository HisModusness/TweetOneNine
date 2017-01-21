//
//  FirstViewController.swift
//  TweetOneNine
//
//  Created by Liam Westby on 1/16/17.
//  Copyright © 2017 DEC Microcomputer Software, Inc. All rights reserved.
//

import UIKit
import OAuthSwift

class FirstViewController: UITableViewController {
    private var tweets: [[String: Any]] = []
    //@IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: TweetCell.nibName, bundle: nil), forCellReuseIdentifier: TweetCell.identifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = TweetCell.estimatedRowHeight
        
        getTweets()
        
    }
    
    func getTweets() {
        print("Downloading tweets")
        let conn = TwitterConnection.sharedInstance
        if (!conn.loggedIn) {
            conn.logIn()
        }
        
        _ = conn.oauth.client.get(
            "https://api.twitter.com/1.1/statuses/home_timeline.json", parameters: [:],
            success: { response in
                print("Got some tweets")
                let jsonDict = try? response.jsonObject() as! [[String: Any]]
                self.tweets = jsonDict!
                self.tableView.reloadData()
        }, failure: { error in
            print(error)
        }
        )

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
                let jsonDict = try? response.jsonObject() as! [[String: Any]]
                for s:String in (jsonDict?[0].keys.sorted())! {
                    print(s)
                }
        }, failure: { error in
            print(error)
        }
        )

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK - Table View Data Source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCell(withIdentifier: TweetCell.identifier, for: indexPath) as! TweetCell
        
        let userName = getUserName(from: tweets[indexPath.row]["user"] as! [String:Any])
        tweetCell.userName.text = userName
        
        let tweetText = tweets[indexPath.row]["text"] as? String
        tweetCell.tweetLabel.text = tweetText
        
        print("Got user name:\(userName) with text \(tweetText)")
        tweetCell.layoutSubviews()
        return tweetCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        print("Table has \(tweets.count) tweets")
        return tweets.count
    }
    
    //MARK - Table View Delegate
    
//    func tableView(_ tableView:UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat {
//        return 100
//    }
    
    private func getUserName(from user: [String: Any]) -> String {
        return user["screen_name"] as! String
    }

}

