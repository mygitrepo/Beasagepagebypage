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
    var handle: AuthStateDidChangeListenerHandle?
    
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
            Auth.auth().signIn(withEmail: email, password: pass, completion: { user, error in
                if let firebaseError = error {
                    //Customized message based on error descr
                    guard let _ = user else {
                        if let error = error {
                            if let errCode = AuthErrorCode(rawValue: error._code) {
                                switch errCode {
                                case .userNotFound:
                                    print(firebaseError.localizedDescription)
                                    let alert = UIAlertController(title: "Sign In Failed",
                                                                  message: "User account not found. Try registering!",
                                                                  preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                                        action in _ = self.parent
                                    }))
                                    self.present(alert, animated: true, completion:nil)
                                case .wrongPassword:
                                    print(firebaseError.localizedDescription)
                                    let alert = UIAlertController(title: "Sign In Failed",
                                                                  message: "Incorrect username/password combination!",
                                                                  preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Reset Passowrd", style: UIAlertActionStyle.default, handler: {
                                        action in
                                        self.didRequestPasswordReset()
                                        //action in self.parent
                                    }))
                                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                                        action in _ = self.parent
                                    }))
                                    self.present(alert, animated: true, completion:nil)
                                default:
                                    print(firebaseError.localizedDescription)
                                    let alert = UIAlertController(title: "Sign In Failed",
                                                                  message: "Not able to sign in to your account!",
                                                                  preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                                        action in _ = self.parent
                                    }))
                                    //self.showAlert("Error: \(error.localizedDescription)")
                                    self.present(alert, animated: true, completion:nil)
                                }
                            }
                            return
                        }
                        assertionFailure("user and error are nil")
                        return
                    }
//                    print(firebaseError.localizedDescription)
//                    let alert = UIAlertController(title: "Sign In Failed",
//                                                  message: "Not able to sign in to your account!",
//                                                  preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
//                        action in self.parent
//                    }))
//                    self.present(alert, animated: true, completion:nil)
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
    
    @IBAction func didRequestPasswordReset() {
        let prompt = UIAlertController(title: "Be a Sage Page by Page", message: "Email:", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            Auth.auth().sendPasswordReset(withEmail: userInput!, completion: { (error) in
                if let error = error {
                    if let errCode = AuthErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .userNotFound:
                            DispatchQueue.main.async {
                                self.showAlert("User account not found. Try registering")
                            }
                        default:
                            DispatchQueue.main.async {
                                self.showAlert("Error: \(error.localizedDescription)")
                            }
                        }
                    }
                    return
                } else {
                    DispatchQueue.main.async {
                        self.showAlert("You'll receive an email shortly to reset your password.")
                    }
                }
            })
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil)
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: "Be a Sage Page by Page", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func createaccTapped(_ sender: UIButton) {
        if let email = emailText.text, let pass = passwordText.text {
            if(email == "") || (pass == "") {
                let alert = UIAlertController(title: "Error",
                                              message: "Please enter E-mail address and Password!",
                                              preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                    action in _ = self.parent
                }))
                self.present(alert, animated: true, completion:nil)
            } else {
                Auth.auth().createUser(withEmail: email, password: pass, completion: { user, error in
                    if let firebaseError = error {
                        print(firebaseError.localizedDescription)
                        let alert = UIAlertController(title: "Error",
                                                      message: firebaseError.localizedDescription+"!",
                                                      preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                            action in _ = self.parent
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
                action in _ = self.parent
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
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
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
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
        Auth.auth().signInAndRetrieveData(with: credential) { (user,error) in
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
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
}
