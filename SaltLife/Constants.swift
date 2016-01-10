//
//  Constants.swift
//  SaltLife
//
//  Created by John Frost on 1/2/16.
//  Copyright © 2016 Pair-A-Dice. All rights reserved.
//

import Foundation
import UIKit
import Firebase



let SHADOW_COLOR: CGFloat = 157.0 / 255.0

//Firebase Paths
let REF = Firebase(url: "https://saltlife.firebaseio.com")
let REF_USERS = Firebase(url: "\(REF)/users")
let REF_POSTS = Firebase(url: "\(REF)/posts")

var REF_USER_CURRENT: Firebase {
    let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as? String
    let user = Firebase(url: "\(REF_USERS)").childByAppendingPath(uid)
    return user!
}

let KEY_UID = "uid"

// Segues
let SEGUE_LOGGED_IN = "loggedIn"

//Status Codes
let STATUS_ACCOUNT_NONEXIST = -8
let STATUS_INVALID_PASSWORD = -6

