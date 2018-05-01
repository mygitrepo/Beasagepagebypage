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
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

class SignUpViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate {
    
    //For Google SIgnIn
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signUpPopupView: UIView!
    @IBOutlet weak var signUpPopupKeyView: UIView!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    @IBAction func signUpDismissView(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func signInButtonTapped(_ sender: GIDSignInButton) {
        print("NOW Starting SignIn process")
    }
    
    @IBAction func logintapped(_ sender: UIButton) {
        if let email = emailText.text, let pass = passwordText.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: pass, completion: { user, error in
                if let firebaseError = error {
                    print(firebaseError.localizedDescription)
                    let alert = UIAlertController(title: "Sign In Failed",
                                                  message: "Not able to sign in to your account!",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                        action in self.parent
                    }))
                    self.present(alert, animated: true, completion:nil)
                } else {
                    //User authenticated successfully through
                    //FireBase
                    let alert = UIAlertController(title: "Success!",
                                                  message: "You signed in successfully.",
                                                  preferredStyle: UIAlertControllerStyle.alert)
                    //Show alert for successful sign in
                    self.present(alert, animated: true, completion:nil)
                    // change to desired number of seconds (in this case 5 seconds)
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        alert.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func createaccTapped(_ sender: UIButton) {
        if let email = emailText.text, let pass = passwordText.text {
            if(email == "") || (pass == "") {
                let alert = UIAlertController(title: "Error",
                                              message: "Please enter E-mail address and Password!",
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                    action in self.parent
                }))
                self.present(alert, animated: true, completion:nil)
            } else {
                FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { user, error in
                    if let firebaseError = error {
                        print(firebaseError.localizedDescription)
                        let alert = UIAlertController(title: "Error",
                                                      message: firebaseError.localizedDescription+"!",
                                                      preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                            action in self.parent
                        }))
                        self.present(alert, animated: true, completion:nil)
                    } else {
                        
                        //Account created successfully in
                        //FireBase
                        let alert = UIAlertController(title: "Account Created!",
                                                      message: "You created new account successfully.",
                                                      preferredStyle: UIAlertControllerStyle.alert)
                        //Show alert for successful sign in
                        self.present(alert, animated: true, completion:nil)
                        // change to desired number of seconds (in this case 5 seconds)
                        let when = DispatchTime.now() + 1
                        DispatchQueue.main.asyncAfter(deadline: when){
                            // your code with delay
                            alert.dismiss(animated: true, completion: nil)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                })
            }
        } else {
            let alert = UIAlertController(title: "Error",
                                          message: "Please enter e-mail address and password!",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                action in self.parent
            }))
            self.present(alert, animated: true, completion:nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpPopupView.layer.cornerRadius = 10
        signUpPopupKeyView.layer.cornerRadius = 50
        
        let loginButton = FBSDKLoginButton()
        signUpPopupView.addSubview(loginButton)
        loginButton.frame = CGRect(x: 27, y: 72, width: signUpPopupView.frame.width - 52, height: 35)
        //loginButton.frame = CGRect(x: 27, y: 72, width: view.frame.width - 188, height: 35)
        loginButton.delegate = self
        loginButton.readPermissions = ["email","public_profile"]
        

        //Do any additional setup after loading the view.
        //Code added for Google SignIn
        //signInButton.layer.cornerRadius = 5
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
                //Show alert for successful sign in
                self.present(alert, animated: true, completion:nil)
                // change to desired number of seconds (in this case 5 seconds)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    alert.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out from Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with Facebook")
        
        guard let accessToken = FBSDKAccessToken.current() else {
            print("Failed to get access token")
            return
        }
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        
        FIRAuth.auth()?.signIn(with: credential) { (user, error) in
            if let error = error {
                print("Error \(error)")
                return
            } else {
                let alert = UIAlertController(title: "Signed In!",
                                              message: "You signed in successfully.",
                                              preferredStyle: UIAlertControllerStyle.alert)
                //Show alert for successful sign in
                self.present(alert, animated: true, completion:nil)
                // change to desired number of seconds (in this case 5 seconds)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    alert.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    deinit {
        if let handle = handle {
            FIRAuth.auth()?.removeStateDidChangeListener(handle)
        }
    }
    
}
