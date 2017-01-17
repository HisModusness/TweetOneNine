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
    private var prefs: Preferences?
    private var oauthswift: OAuth1Swift?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For testing login
        //UserDefaults.standard.removeObject(forKey: "prefs")
        
        if let data = UserDefaults.standard.object(forKey: "prefs") as? Data {
            print("Unarchiving prefs")
            self.prefs = NSKeyedUnarchiver.unarchiveObject(with: data) as! Preferences?
        }
        
        if self.prefs == nil {
            print("Prefs not found. Log in.")
            // create an instance and retain it
            getOAuthSwift()
            if let oauthswift = self.oauthswift {
                oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
                _ = oauthswift.authorize(
                    withCallbackURL: URL(string: "oauth-swift://oauth-callback/twitter")!,
                    success: { credential, response, parameters in
                        print(credential.oauthToken)
                        print(credential.oauthTokenSecret)
                        print(parameters["user_id"]!)
                        self.updatePrefs(credential: credential)
                },
                    failure: { error in
                        print(error.localizedDescription)
                        print(error.description)
                }
                )
            }
            
        }
        else {
            getOAuthSwift()
            oauthswift!.client.credential.oauthToken = prefs!.credential.oauthToken
            oauthswift!.client.credential.oauthTokenSecret = prefs!.credential.oauthTokenSecret
        }
        if oauthswift != nil {
            testPrefs()
        }
        
    }
    
    func getOAuthSwift() {
        self.oauthswift = OAuth1Swift(
            consumerKey:    "W6bKzg06b4dhUrUVsNWe0vxST",
            consumerSecret: "Cl4JjE9acZZSy7n93bll9t2M2J4mJeuxvbQWWdHWLiSHx2rqXr",
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
    }
    
    func updatePrefs(credential: OAuthSwiftCredential) {
        print("Updating prefs")
        self.prefs = Preferences(credential: credential)
        archivePrefs()
        
    }
    
    func archivePrefs() {
        print("Saving prefs")
        if prefs != nil {
            print("Prefs not nil")
            let data = NSKeyedArchiver.archivedData(withRootObject: prefs!)
            UserDefaults.standard.set(data, forKey: "prefs")
        }
    }
    
    func testPrefs() {
        print("Testing prefs")
        let _ = oauthswift!.client.get(
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

