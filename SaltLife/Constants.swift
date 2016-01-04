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

let ref = Firebase(url: "https://saltlife.firebaseio.com")

let KEY_UID = "uid"

// Segues
let SEGUE_LOGGED_IN = "loggedIn"

//Status Codes
let STATUS_ACCOUNT_NONEXIST = -8
let STATUS_INVALID_PASSWORD = -6

