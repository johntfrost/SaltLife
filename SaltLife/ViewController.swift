//
//  ViewController.swift
//  SaltLife
//
//  Created by John Frost on 1/2/16.
//  Copyright © 2016 Pair-A-Dice. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase


class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    @IBAction func fbBtnPressed(sender: UIButton!) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"],
            fromViewController: self,
            handler: {(result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                
            if error != nil {
                print("Facebook login failed. Error \(error)")
                
            } else if result.isCancelled {
                print("Facebook login was cancelled.")
                
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                
                print("Successfully logged in with facebook. \(accessToken)")
            
                REF.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Login failed. \(error)")
                            
                        } else {
                            print("Logged in! \(authData)")
                            
                            let user = ["provider": authData.provider!]
                            self.createFirebaseUser(authData.uid, user: user)
                            
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                        }
                })
            }
        })
    }
    
    @IBAction func attemptLogin(sender: UIButton!) {
        
        if let email = emailField.text where email != "", let pwd = passwordField.text where  pwd != "" {
            
            REF.authUser(email, password: pwd, withCompletionBlock: {error, authData in
                if error != nil {
                    print(error)
                    if error.code == STATUS_ACCOUNT_NONEXIST{
                        REF.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            
                            if error != nil {
                                self.showErrorAlert("Could not creat account", msg: " Check that your shit is correct")
                                
                            }else {
                                NSUserDefaults.standardUserDefaults().setValue(result [KEY_UID], forKey: KEY_UID)
                                REF.authUser(email, password: pwd, withCompletionBlock: {
                                    
                                    err, authData in
                                    
                                    let user = ["provider": authData.provider!, "blah": "emailtest"]
                                    self.createFirebaseUser(authData.uid, user: user)
                                })
                                
                                self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            }
                        })
                        
                    }else if error.code == STATUS_INVALID_PASSWORD{
                        self.showErrorAlert("Could not login", msg: "Password Incorrect")
                        
                    }else {
                        self.showErrorAlert("Couldnot login", msg: "Check that your shit is correct")
                    }
                    
                }else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
            
        }else {
            showErrorAlert("Email and Password Required", msg: "You must enter an email and a password")
        }
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func createFirebaseUser(uid:String, user: Dictionary<String,String>) {
        REF_USERS.childByAppendingPath(uid).setValue(user)
    }

}

