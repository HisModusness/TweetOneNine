//
//  Preferences.swift
//  TweetOneNine
//
//  Created by Liam Westby on 1/16/17.
//  Copyright © 2017 DEC Microcomputer Software, Inc. All rights reserved.
//

import Foundation
import OAuthSwift

class TwitterConnection : NSObject{
    static let sharedInstance = TwitterConnection()
    
    var oauth: OAuth1Swift
    var loggedIn: Bool = false
    
    override init() {
        // Get a connection to twitter
        self.oauth = OAuth1Swift(
            consumerKey:    "W6bKzg06b4dhUrUVsNWe0vxST",
            consumerSecret: "Cl4JjE9acZZSy7n93bll9t2M2J4mJeuxvbQWWdHWLiSHx2rqXr",
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
        
        // Has the app connected before?
        if let data = UserDefaults.standard.object(forKey: "tc.credential") as? Data {
            print("Unarchiving credentials")
            let credential = NSKeyedUnarchiver.unarchiveObject(with: data) as! OAuthSwiftCredential
            self.oauth.client.credential.oauthToken = credential.oauthToken
            self.oauth.client.credential.oauthTokenSecret = credential.oauthTokenSecret
            loggedIn = true
        }
        
    }
    
    func logIn() {
        // Start a new connection
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = appDelegate.window!.rootViewController!
        oauth.authorizeURLHandler = SafariURLHandler(viewController: vc, oauthSwift: self.oauth)
        _ = oauth.authorize(
            withCallbackURL: URL(string: "oauth-swift://oauth-callback/twitter")!,
            success: { credential, response, parameters in
                print(credential.oauthToken)
                print(credential.oauthTokenSecret)
                print(parameters["user_id"]!)
                self.updateCredential(credential: credential)
        },
            failure: { error in
                print(error.localizedDescription)
                print(error.description)
        }
        )

    }
    
    func updateCredential(credential: OAuthSwiftCredential) {
        let data = NSKeyedArchiver.archivedData(withRootObject: oauth.client.credential)
        UserDefaults.standard.set(data, forKey: "tc.credential")
    }
}
