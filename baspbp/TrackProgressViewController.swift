//
//  TrackProgressViewController.swift
//  baspbp-final
//
//  Created by nikul on 12/29/16.
//  Copyright © 2016 isv. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import EventKit
import Firebase
import GoogleSignIn
import FBSDKLoginKit

class TrackProgressViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, GIDSignInUIDelegate, GIDSignInDelegate, FBSDKLoginButtonDelegate {
    
    //For Google SIgnIn
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    //Data received through segue
    var itemLabelfromVC : String = ""
    var pagesLabelfromVC : String = ""
    var durationLabelfromVC : String = ""
    var timeUnitLabelfromVC : String = ""
    var pageSlokaLabelfromVC : String = ""
    var deviceTypefromVC : String = ""
    var currentCellText : String = ""
    var timeInSecondsfromVC = 0
    var sbPagesfromVC = 0
    var bgPagesfromVC = 0
    var ccPagesfromVC = 0
    var krPagesfromVC = 0
    var niPagesfromVC = 0
    var ndPagesfromVC = 0
    var tlPagesfromVC = 0
    var isPagesfromVC = 0
    var sbSlokasfromVC = 0
    var bgSlokasfromVC = 0
    var ccSlokasfromVC = 0
    var niSlokasfromVC = 0
    var ndSlokasfromVC = 0
    var krSlokasfromVC = 0
    var isSlokasfromVC = 0
    var tlSlokasfromVC = 0
    let CellIdentifier = "Cell Identifier"
    var items = [Item]()
    var list = ["Bhagavad-Gita","Caitanya Caritamrta","Krsna Book","Nectar of Devotion","Nectar of Instruction","Srimad Bhagavatam","Sri Isopanishad","TLC"]
    // add this right above your viewDidLoad function for right to left transition
    let transitionManager = TransitionManager()
    
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var signInButton: UIButton!
    
    //For back button from ProgressVCs to TrackProgressVC
    @IBAction func FrmProgressVCunwindToTrackProgressViewController (_ sender: UIStoryboardSegue){
        
    }
    @IBAction func signOutTapped(_ sender: UIButton) {
        
        // START HERE: Following code is in trial basis. Original code is commented out below
        // temporarily. Current probelm is that even after logging out google user, while clicking
        // on signin -> google sign in, it is signing in user silently. Actually it should ask for
        // singin information! - solution for some reason try FIRAuth.auth()?.signOut() is not
        // signin out user who signed in silently but GIDSignIn.sharedInstance().signOut() does the job.
        
//        guard FIRAuth.auth()?.currentUser != nil else {
//            print("No User signed in!!")
//            let alert = UIAlertController(title: "No User Signed In!",
//                                          message: "User can't be signed out.",
//                                          preferredStyle: UIAlertControllerStyle.alert)
//            //Show alert for successful sign in
//            self.present(alert, animated: true, completion:nil)
//            // change to desired number of seconds (in this case 5 seconds)
//            let when = DispatchTime.now() + 2
//            DispatchQueue.main.asyncAfter(deadline: when){
//                // your code with delay
//                alert.dismiss(animated: true, completion: nil)
//            }
//            return
//        }
//        
//        do {
//            //First print signed in users
//            print("Printing user login providers ......")
//            for user in (FIRAuth.auth()?.currentUser?.providerData)! {
//                print(user.providerID)
//            }
//
//            print("User signed in. Signing Out....")
//            try FIRAuth.auth()?.signOut()
//            FIRAuth.auth()?.addStateDidChangeListener { auth, user in
//                if user != nil {
//                    print("User STILL Signed In...")
//                } else {
//                    print("User Signed Out!!")
//                }
//            }
//            FBSDKAccessToken.setCurrent(nil)
//            
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
        let firebaseAuth = FIRAuth.auth()
        print("Printing user login providers ......")
        if (firebaseAuth?.currentUser != nil) {
            for user in (firebaseAuth?.currentUser?.providerData)! {
                    print(user.providerID)
            }
        }
        //print(FIRAuth.auth()?.currentUser?.providerData as Any)
        if (firebaseAuth?.currentUser != nil) {
            //user is signed in
            do {
                for user in (firebaseAuth?.currentUser?.providerData)! {
                    if(user.providerID == "google.com") {
                        print("Signing Out Google user")
                        try firebaseAuth?.signOut()
                        GIDSignIn.sharedInstance().signOut()
                    }
                    if(user.providerID == "facebook.com") {
                        print("Signing Out Facebook user")
                        try firebaseAuth?.signOut()
                        FBSDKLoginManager().logOut()
                    }
                    if(user.providerID == "password") {
                        print("Signing Out Email/Password user")
                        try firebaseAuth?.signOut()
                    }
                }
                //try FIRAuth.auth()?.signOut()
                //FBSDKLoginManager().logOut()
                //try GIDSignIn.sharedInstance().signOut()
                if (firebaseAuth?.currentUser == nil) {
                    print("User successfully signed OUT")
                    let alert = UIAlertController(title: "Signed Out!",
                                                  message: "You successfully signed out.",
                        preferredStyle: UIAlertControllerStyle.alert)
                    //Show alert for successful sign out
                    self.present(alert, animated: true, completion:nil)
//                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
//                        action in self.parent
//                    }))
//                    self.present(alert, animated: true, completion:nil)
                    // change to desired number of seconds (in this case 5 seconds)
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        alert.dismiss(animated: true, completion: nil)
                    }
                    self.signInButton.setTitle("SignIn", for: .normal)
                } else {
                    print("User is STILL signed in. Sign Out Failed.")
                }
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        } else {
            print("No User Logged in!!")
            let alert = UIAlertController(title: "No User Signed In!",
                                          message: "User can't be signed out.",
                                          preferredStyle: UIAlertControllerStyle.alert)
            //Show alert for successful sign in
            self.present(alert, animated: true, completion:nil)
            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func trackScripture(_ sender: UIButton) {
        if(textBox.text! != "Select a scripture") {
            if(items.contains(where: {x in x.name == textBox.text!})) {
                let alert = UIAlertController(title: "Duplicate!",
                                              message: "You are already tracking \(textBox.text!). Please select a different scripture to track.",
                    preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                    action in self.parent
                }))
                self.present(alert, animated: true, completion:nil)
            } else {
                let item = Item(name: textBox.text!)
                // Add Item to Items
                items.insert(item, at: 0)
                // Add Row to Table View
                tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
                Adjust_Table_Height();
                // Save Items
                saveItems()
            }
        } else {
            let alert = UIAlertController(title: "Not Allowed!",
                                          message: "Please select a scripture from picker list",
                preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                action in self.parent
            }))
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    @IBAction func removeScripture(_ sender: UIButton) {
        tableView.setEditing(!tableView.isEditing, animated: true);
        //Adjust_Table_Height();
    }
    
    // MARK: -
    // MARK: Initialization
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        // Load Items
        loadItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Code added for Google SignIn
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            // user is signed in or has previous authentication parameters saved in keychain
            //SignIn silently only if user is not already signed in
            if(GIDSignIn.sharedInstance().currentUser == nil) {
                GIDSignIn.sharedInstance().signInSilently()
                //if(GIDSignIn.sharedInstance().currentUser == nil) {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                    self.handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
                        if user != nil {
                            print("USER SIGNED IN SILENTLY !!")
                            self.signInButton.setTitle("SignedIn", for: .normal)
                            //MeasurementHelper.sendLoginEvent()
                            //self.performSegue(withIdentifier: Constants.Segues.SignInToFp, sender: nil)
                        }
                    }
                })
            } else if (GIDSignIn.sharedInstance().currentUser != nil) {
                self.signInButton.setTitle("SignedIn", for: .normal)
            }
        } else if(FBSDKAccessToken.current() != nil) {
            self.signInButton.setTitle("SignedIn", for: .normal)
        }
        print("====>>>> DONE WITH viewDidAppear in TrackProgressVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(itemLabelfromVC)
        print(sbPagesfromVC)
        //self.table.register(UITableViewCell.self, forCellReuseIdentifier: "td")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        dropDown.selectRow(3, inComponent: 0, animated: true)
        //let item = Item(name: "Bhagavad-Gita")
        //print(item.uuid)
        //loadItems()
        //print(items)
        title = "Items"
        // Register Class
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: CellIdentifier)
        // Do any additional setup after loading the view, typically from a nib.
        //UITableView_Auto_Height();
        Adjust_Table_Height();
        // Need to call this line to force constraint updated
        self.view.layoutIfNeeded()
        print("====>>>> DONE WITH viewDidLoad in TrackProgressVC")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        //UITableView_Auto_Height();
        return 1
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        //UITableView_Auto_Height();
        return list.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //UITableView_Auto_Height();
        self.view.endEditing(true)
        //UITableView_Auto_Height();
        return list[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //UITableView_Auto_Height();
        self.textBox.text = self.list[row]
        self.dropDown.isHidden = true
        //UITableView_Auto_Height();
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == self.textBox {
            self.dropDown.isHidden = false
            //UITableView_Auto_Height();
            //if you dont want the users to se the keyboard type:            
            textField.endEditing(true)
        }
        
    }
    
    // MARK: -
    // MARK: Table View Data Source Methods
    func numberOfSections(in table: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue Reusable Cell
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "td")
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath as IndexPath)
        
        // Fetch Item
        let item = items[indexPath.row]
        
        // Configure Table View Cell
        cell.textLabel?.text = item.name
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = UIColor.blue
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightThin);
        //cell.textLabel?.font = UIFont(name:"Avenir", size:22)
//        let redColor = UIColor.yellow
//        self.tableView.layer.borderColor = redColor.withAlphaComponent(0.9).cgColor
//        self.tableView.layer.borderWidth = 1;
        self.tableView.layer.cornerRadius = 4;
        
        return cell
    }
    
    // Allowing table rows to be editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete Item from Items
            items.remove(at: indexPath.row)
            
            // Update Table View
            tableView.deleteRows(at: [indexPath], with: .right)
            //tableView.reloadData();
            Adjust_Table_Height();
            
            // Save Changes
            saveItems()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        currentCellText = currentCell.textLabel!.text!
        print(currentCellText)
        print(currentCell.textLabel!.text as Any)
        //Check first if user is signed in
//        handle = FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
//            if user != nil {
//                self.performSegue(withIdentifier: "ScriptureProgress", sender: self)
//            } else {
//                print("NOT Allowed")
//            }
//        }
        performSegue(withIdentifier: "ScriptureProgress", sender: self)
//        switch (currentCell.textLabel!.text) {
//            case "Krsna Book"?:
//                performSegue(withIdentifier: "KRProgress", sender: self)
//            case "Bhagavad-gita"?:
//                performSegue(withIdentifier: "ScriptureProgress", sender: self)
//            default:
//                break
//        }
    }
    
    // MARK: -
    // MARK: Helper Methods
    private func loadItems() {
        if let filePath = pathForItems(), FileManager.default.fileExists(atPath: filePath) {
            if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Item] {
                items = archivedItems
            }
        }
    }
    
    private func saveItems() {
        if let filePath = pathForItems() {
            NSKeyedArchiver.archiveRootObject(items, toFile: filePath)
        }
    }
    
    private func pathForItems() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let documents = paths.first, let documentsURL = NSURL(string: documents) {
            return documentsURL.appendingPathComponent("items")!.path
        }
        
        return nil
    }
    
    // Dynamic tableView height after adding new element
    func UITableView_Auto_Height() {
        if(tableView.contentSize.height > tableView.frame.height){
            var frame: CGRect = tableView.frame;
            if(tableView.contentSize.height < 264) {
                frame.size.height = tableView.contentSize.height;
                tableView.frame = frame;
            } else {
                frame.size.height = 264
                tableView.frame = frame;
            }
        }
    }
    
    func UITableView_Auto_Height_Remove() {
    // Dynamic tableView height after removing an element
        if (tableView.contentSize.height < tableView.frame.height){
            var frame: CGRect = tableView.frame;
            if(tableView.contentSize.height == 44) {
                frame.size.height = 44
                tableView.frame = frame;
                //frame.size.height = tableView.contentSize.height;
                //tableView.frame = frame;
            } else {
                frame.size.height = tableView.contentSize.height;
                tableView.frame = frame;
                //frame.size.height = 44
                //tableView.frame = frame;
            }
        }
    }
    
    func Adjust_Table_Height() {
        if((items.count * 44) <= 264) {
            tableHeight.constant = CGFloat(items.count) * 44
        } else {
            tableHeight.constant = 264
        }
    }
    
    // Added for right to left transition instead of bottom to top
    // Only for 'ScriptureProgress' segue
    // For 'SignUp' segue, we want cross dissolve popup VC
    override func prepare(for segue: UIStoryboardSegue!, sender: Any?) {
        if (segue.identifier == "ScriptureProgress") {
            if let destination = segue.destination as? TrackBGViewController {
                destination.scriptureLabelfromVC = self.currentCellText
            }
        
            // this gets a reference to the screen that we're about to transition to
            let toViewController = segue.destination as UIViewController
        
            // instead of using the default transition animation, we'll ask
            // the segue to use our custom TransitionManager object to manage the transition animation
            toViewController.transitioningDelegate = self.transitionManager
            
        } else if (segue.identifier == "SignUp") {
            print("Transition using SignUp segue")
            //performSegue(withIdentifier: "SignUp", sender: nil)
            // this gets a reference to the screen that we're about to transition to
//            let toViewController = segue.destination as UIViewController
//            toViewController.transitioningDelegate = self.transitionManager
        }
    }
    
    deinit {
        if let handle = handle {
            FIRAuth.auth()?.removeStateDidChangeListener(handle)
        }
    }

    
//    func Adjust_Table_Height_Remove() {
//        if((items.count * 44) <= 264) {
//            if((items.count * 44) == 44) {
//                //do nothing
//            } else {
//                tableHeight.constant = CGFloat(items.count) * 44
//            }
//        } else {
//            tableHeight.constant = 264
//        }
//    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("Failed to log into Google: ")
            print("Error \(error)")
            return
        }
        
        // START HERE: User status is displayed only first time as "SignedIn" after manually signing in
        // from signupVC.
        print("TrackProgressVC: Successfully logged into Google", user)
        self.signInButton.setTitle("SignedIn", for: .normal)
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        print("TrackProgressVC: Successfully logged into Facebook")
        self.signInButton.setTitle("SignedIn", for: .normal)
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out from Facebook")
    }

}
