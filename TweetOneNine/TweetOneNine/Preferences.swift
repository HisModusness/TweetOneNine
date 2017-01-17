//
//  Preferences.swift
//  TweetOneNine
//
//  Created by Liam Westby on 1/16/17.
//  Copyright © 2017 DEC Microcomputer Software, Inc. All rights reserved.
//

import Foundation
import OAuthSwift

class Preferences : NSObject, NSCoding {
    var credential: OAuthSwiftCredential
    
    init(credential: OAuthSwiftCredential) {
        self.credential = credential
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let credential = aDecoder.decodeObject(forKey: "credential") as? OAuthSwiftCredential else { return nil }
        self.init(credential: credential)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(credential, forKey: "credential")
    }
}
