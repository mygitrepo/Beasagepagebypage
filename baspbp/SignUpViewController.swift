//
//  SignUpViewController.swift
//  baspbp-final
//
//  Created by nikul on 4/13/17.
//  Copyright © 2017 isv. All rights reserved.
//

import UIKit
import QuartzCore
import EventKit
import Firebase
import GoogleSignIn

class SignUpViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    //For Google SIgnIn
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signUpPopupView: UIView!
    @IBOutlet weak var signUpPopupKeyView: UIView!
    
    @IBAction func signUpDismissView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func signInButtonTapped(_ sender: GIDSignInButton) {
        print("NOW Starting SignIn process")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpPopupView.layer.cornerRadius = 10
        signUpPopupKeyView.layer.cornerRadius = 50

        //Do any additional setup after loading the view.
        //Code added for Google SignIn
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("Failed to log into Google: ")
            print("Error \(error)")
            return
        }
        
        print("Successfully logged into Google", user)
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let error = error {
                print("Error \(error)")
                return
            } else {
                let alert = UIAlertController(title: "Signed In!",
                                              message: "You signed in successfully.",
                    preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                    action in
                        //Dissmis SignIn VC when user taps "OK" button
                        self.dismiss(animated: true, completion: nil)
                }))
                //Show alert for successful sign in
                self.present(alert, animated: true, completion:nil)
            }
        }
    }
    
}
