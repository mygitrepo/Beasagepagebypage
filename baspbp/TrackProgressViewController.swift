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
    var handle: AuthStateDidChangeListenerHandle?
    
    //Firestore document reference
    let db = Firestore.firestore()
    var docRef: DocumentReference? = nil
    var user_id : String = ""
    var user_email_id : String = ""
    //To handle async call to Firestore
    let myGroup = DispatchGroup()
    
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
    var userSignedIn = false
    let CellIdentifier = "Cell Identifier"
    var items = [Item]()
    var scripturePages = [ScripturePages]()
    var list = ["Bhagavad-Gita","Caitanya-caritamrta","Krsna Book","Nectar of Devotion","Nectar of Instruction","Srimad Bhagavatam","Sri Isopanishad","TLC"]
    // add this right above your viewDidLoad function for right to left transition
    let transitionManager = TransitionManager()
    
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var signInButton: UIButton!
    
    //For back button from ProgressVCs to TrackProgressVC
    @IBAction func FrmProgressVCunwindToTrackProgressViewController (_ sender: UIStoryboardSegue){
        
    }
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        print("TrackProgressViewController: Entering func signOutTapped")
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
        let firebaseAuth = Auth.auth()
        print("TrackProgressViewController: Printing user login providers ......")
        if (firebaseAuth.currentUser != nil) {
            for user in (firebaseAuth.currentUser?.providerData)! {
                    print(user.providerID)
            }
        }
        //print(FIRAuth.auth()?.currentUser?.providerData as Any)
        if (firebaseAuth.currentUser != nil) {
            //user is signed in
            do {
                for user in (firebaseAuth.currentUser?.providerData)! {
                    if(user.providerID == "google.com") {
                        print("TrackProgressViewController: Signing Out Google user")
                        try firebaseAuth.signOut()
                        GIDSignIn.sharedInstance().signOut()
                    }
                    if(user.providerID == "facebook.com") {
                        print("TrackProgressViewController: Signing Out Facebook user")
                        try firebaseAuth.signOut()
                        FBSDKLoginManager().logOut()
                    }
                    if(user.providerID == "password") {
                        print("TrackProgressViewController: Signing Out Email/Password user")
                        try firebaseAuth.signOut()
                    }
                }
                
                if (firebaseAuth.currentUser == nil) {
                    print("TrackProgressViewController: User successfully signed OUT")
                    self.signInButton.setTitle("SignIn", for: .normal)
                    userSignedIn = false
                    let alert = UIAlertController(title: "Signed Out!",
                                                  message: "You successfully signed out.",
                        preferredStyle: UIAlertControllerStyle.alert)
                    //Show alert for successful sign out
                    self.present(alert, animated: true, completion:nil)
                    // change to desired number of seconds (in this case 5 seconds)
                    let when = DispatchTime.now() + 2
                    DispatchQueue.main.asyncAfter(deadline: when){
                        // your code with delay
                        print("TrackProgressViewController: Dismissing alert & TrackProgressViewController from main thread")
                        alert.dismiss(animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    print("User is STILL signed in. Sign Out Failed.")
                }
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        } else {
            print("TrackProgressViewController: No User Logged in. Showing alert !!")
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
                    action in _ = self.parent
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
                saveItems(operation:"add", name:textBox.text!)
            }
        } else {
            let alert = UIAlertController(title: "Not Allowed!",
                                          message: "Please select a scripture from picker list",
                preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                action in _ = self.parent
            }))
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    @IBAction func removeScripture(_ sender: UIButton) {
        if items.count == 0 {
            let alert = UIAlertController(title: "Not Allowed!",
                                          message: "You are not tracking any scripture",
                                          preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
                action in _ = self.parent
            }))
            self.present(alert, animated: true, completion:nil)
        } else {
            // For resetting pages & slokas to 0 in local db when a scripture is removed
            for book in scripturePages where book.name == textBox.text! {
                book.pagesread = 0
                book.slokasread = 0
            }
            // Write to local db file for scripturePages
            if let scripturepagesPath = self.pathForScripturePages() {
                // Write to File
                print("Print scripturepagesPath: \(scripturepagesPath)")
                if NSKeyedArchiver.archiveRootObject(self.scripturePages, toFile: scripturepagesPath) {
                    print("TrackProgressViewController: scripturePages archived locally to file scripturepagesPath")
                }
            }
            //Now move tableView in editing mode
            tableView.setEditing(!tableView.isEditing, animated: true);
            if tableView.isEditing {
                self.removeButton.setTitle("Done", for: .normal)
            } else {
                self.removeButton.setTitle("Remove", for: .normal)
            }
        }
    }
    
    // MARK: -
    // MARK: Initialization
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        // Load Items
        loadItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("TrackProgressViewController: Entering viewDidAppear")
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        //var flag = false
        print("TrackProgressViewController: Entering viewDidLoad")
        super.viewDidLoad()
        
        //Code added for Google SignIn & Reading book names from Firestore
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        let firebaseAuth = Auth.auth()
        if (firebaseAuth.currentUser != nil) || (GIDSignIn.sharedInstance().currentUser != nil) {
//            firebaseAuth.currentUser!.link(with: credential) {(user, error) in
//                if user != nil && error == nil {
//                    // Linking accounts was a success
//                    print("Linking of Facebook account with existing email and password successfull")
//                }
//            )}
            self.signInButton.setTitle("SignedIn", for: .normal)
            self.userSignedIn = true
        }
        
        if(FBSDKAccessToken.current() != nil) {
            self.signInButton.setTitle("SignedIn", for: .normal)
        }
        
        print("TrackProgressViewController: viewDidLoad: Seeding items post reading from Firestore")
        //Entering dispatch group to wait on execution until Firestore requests are complete
        myGroup.enter()
        seedItems()
        
        //Firestore requests are complete. Resume execution.
        myGroup.notify(queue: DispatchQueue.main, execute: {
            print("TrackProgressViewController: viewDidLoad: Finished all Firestore requests.")
            print(self.itemLabelfromVC)
            print(self.sbPagesfromVC)
            //self.table.register(UITableViewCell.self, forCellReuseIdentifier: "td")
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.dropDown.selectRow(3, inComponent: 0, animated: true)
            self.title = "Items"
            // Register Class
            self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: self.CellIdentifier)
            // Do any additional setup after loading the view, typically from a nib.
            //UITableView_Auto_Height();
            self.Adjust_Table_Height();
            // Need to call this line to force constraint updated
            self.view.layoutIfNeeded()
        })
        print("TrackProgressViewController: DONE WITH viewDidLoad in TrackProgressVC")
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
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin);
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
                // Fetch Item name
                let item_name = items[indexPath.row].name
                // Delete Item from Items
                items.remove(at: indexPath.row)
                
                // Update Table View
                tableView.deleteRows(at: [indexPath], with: .right)
                //tableView.reloadData();
                Adjust_Table_Height();
                
                // Save Changes
                saveItems(operation: "remove", name: item_name)
            
                //Change removeButton title to "Remove" if there is no item left
                if items.count == 0 {
                    self.removeButton.setTitle("Remove", for: .normal)
                    tableView.setEditing(!tableView.isEditing, animated: true);
                }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        currentCellText = currentCell.textLabel!.text!
        print(currentCellText)
        print(currentCell.textLabel!.text as Any)
        performSegue(withIdentifier: "ScriptureProgress", sender: self)
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
    
    private func saveItems(operation: String, name: String) {
        if let filePath = pathForItems() {
            NSKeyedArchiver.archiveRootObject(items, toFile: filePath)
        }
        if Auth.auth().currentUser != nil {
            if (operation == "add") {
                print("TrackProgressViewController: Adding book name to Firestore: ",name)
                let dataToSave: [String: Any] = ["totalPagesRead":0, "totalSlokasRead":0]
                //docRef = db.document("userData/scriptureTracking/users/" + user_id.replacingOccurrences(of: " ", with: "_") + "/books/" + name)
                docRef = db.document("userData/scriptureTracking/users/" + user_email_id + "/books/" + name)
                docRef?.setData(dataToSave) { (error) in
                        if let error = error {
                            print("CloudFirestore Got error: \(error.localizedDescription)")
                        } else {
                            print("TrackBGViewController: CloudFirestore: New book name has been saved! : ",name)
                        }
                }
            } else if (operation == "remove") {
                print("TrackProgressViewController: Removing book name from Firestore: ",name)
                //db.collection("userData/scriptureTracking/users/" + user_id.replacingOccurrences(of: " ", with: "_") + "/books/").document(name).delete() { err in
                db.collection("userData/scriptureTracking/users/" + user_email_id + "/books/").document(name).delete() { err in
                    if let err = err {
                        print("CloudFirestore Got Error removing document: \(err)")
                    } else {
                        print("TrackBGViewController: CloudFirestore: Book name successfully removed! :",name)
                    }
                }
            } else {
                print("TrackProgressViewController: Invalid operation. It should be 'add' or 'remove': ",operation)
            }
            
        }
    }
    
    private func pathForItems() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let documents = paths.first, let documentsURL = NSURL(string: documents) {
            return documentsURL.appendingPathComponent("items")!.path
        }
        return nil
    }
    
    // MARK: -
    // MARK: Helper Methods
    // Added as a part of Track Progress feature
    // For seeding scripture name in the list
    private func seedItems() {
        //var flag = false
        print("TrackProgressViewController: First remove everything from items object")
        items.removeAll()
        print("TrackProgressViewController: Load Scripture Pages")
        loadScripturePages()
        
        //user_id = (Auth.auth().currentUser?.displayName)!
        user_email_id = (Auth.auth().currentUser?.email)!
        
        print("TrackProgressViewController: Now read book names from Firestore")
        //docRef = Firestore.firestore().collection("userData/scriptureTracking/users/" + user_id.replacingOccurrences(of: " ", with: "_") + "/books/")
        //db.collection("userData/scriptureTracking/users/" + user_id.replacingOccurrences(of: " ", with: "_") + "/books/").getDocuments() { (querySnapshot, err) in
        db.collection("userData/scriptureTracking/users/" + user_email_id + "/books/").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents from Firestore: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("TrackProgressViewController: \(document.documentID) => \(document.data())")
                    print("TrackProgressViewController: Adding each book as a item in items")
                    // Create Item
                    let item = Item(name: document.documentID)
                    
                    // Add Item
                    self.items.append(item)
                    
                    self.scripturePages = self.scripturePages.map{
                        var mutableScripture = $0
                        print("TrackProgressViewController: mutableScripture: ",mutableScripture)
                        if $0.name == document.documentID {
                            print("TrackProgressViewController: document.data()['totalPagesRead']: ",document.data()["totalPagesRead"] as Any)
                            print("TrackProgressViewController: document.data()['totalSlokasRead']: ",document.data()["totalSlokasRead"] as Any)
                            mutableScripture.pagesread = document.data()["totalPagesRead"] as! Int
                            mutableScripture.slokasread = document.data()["totalSlokasRead"] as! Int
                        }
                        return mutableScripture
                    }
                    
                    if let scripturepagesPath = self.pathForScripturePages() {
                        // Write to File
                        print("Print scripturepagesPath: \(scripturepagesPath)")
                        if NSKeyedArchiver.archiveRootObject(self.scripturePages, toFile: scripturepagesPath) {
                            print("TrackProgressViewController: scripturePages archived locally to file scripturepagesPath")
                        }
                    }

                    //var scripture = scripturePages(name: document.documentID)
                    //scripturePages.first({$0.name == document.documentID})?.pagesread = document.data().totalPagesread
                    
                }
                print("TrackProgressViewController: Now printing items post reading from Firestore")
                print(self.items)
                
                if let itemsPath = self.pathForItems() {
                    print("TrackProgressViewController: Print itemsPath: \(itemsPath)")
                    // Write to File
                    if NSKeyedArchiver.archiveRootObject(self.items, toFile: itemsPath) {
                        print("TrackProgressViewController: items archived locally to file itemsPath")
                    }
                }
                //Signalling main queue that Firestore requests are complete
                self.myGroup.leave()
            }
        }
    }
    
    // MARK: -
    // MARK: Helper Methods
    private func loadScripturePages() {
        if let filePath = pathForScripturePages(), FileManager.default.fileExists(atPath: filePath) {
            print("TrackProgressViewController: Print filePath in loadScripturePages: \(filePath)")
            if let archivedScripturePages = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [ScripturePages] {
                scripturePages = archivedScripturePages
                for book in scripturePages {
                    print(book.name)
                    print(book.pagesread)
                    print(book.slokasread)
                    print(book.totalpages)
                    print(book.totalslokas)
                }
            }
        }
    }
    
    private func pathForScripturePages() -> String? {
        let pathsScript = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let documents = pathsScript.first, let documentsURL = NSURL(string: documents) {
            return documentsURL.appendingPathComponent("scripturepages")?.path
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("TrackProgressViewController: Entering prepare for segue")
        if (segue.identifier == "ScriptureProgress") {
            if let destination = segue.destination as? TrackBGViewController {
                destination.scriptureLabelfromVC = self.currentCellText
                destination.userSignedInfromVC = self.userSignedIn
            }
        
            // this gets a reference to the screen that we're about to transition to
            let toViewController = segue.destination as UIViewController
        
            // instead of using the default transition animation, we'll ask
            // the segue to use our custom TransitionManager object to manage the transition animation
            toViewController.transitioningDelegate = self.transitionManager
            
        } else if (segue.identifier == "SignUp") {
            print("TrackProgressViewController: Transition using SignUp segue - No Code here")
            //performSegue(withIdentifier: "SignUp", sender: nil)
            // this gets a reference to the screen that we're about to transition to
            //let toViewController = segue.destination as UIViewController
            //toViewController.transitioningDelegate = self.transitionManager
        } else if (segue.identifier == "SegueToViewController") {
            print("TrackProgressViewController: Into Prepare for segue sub-block for SegueToViewController")
            print("TrackProgressViewController: segue.destination is ViewController")
            print("TrackProgressViewController: setting up transition manager")
            segue.destination is ViewController
            // this gets a reference to the screen that we're about to transition to
            let toViewController = segue.destination as UIViewController
            
            // instead of using the default transition animation, we'll ask
            // the segue to use our custom TransitionManager object to manage the transition animation
            toViewController.transitioningDelegate = self.transitionManager
        }
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        print("TrackProgressViewController: Entering func sign")
        if let error = error {
            print("Failed to log into Google: ")
            print("Error \(error)")
            return
        }
        
        // START HERE: User status is displayed only first time as "SignedIn" after manually signing in
        // from signupVC.
        print("TrackProgressViewController: Successfully logged into Google", user)
        self.signInButton.setTitle("SignedIn", for: .normal)
        print("TrackProgressViewController: Done with func sign")
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
