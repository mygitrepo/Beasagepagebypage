//
//  AppDelegate.swift
//  baspbp
//
//  Created by nikul on 12/17/15.
//  Copyright © 2015 isv. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Seed Items - Temporarily commented out to release old version of
        // App with two enhancements
        seedItems()
        seedScripturePages()
        FirebaseApp.configure()
        //FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            print("Found hasAuthInKeychain for GIDSignIn")
        } else {
            print("NOT Able to find hasAuthInKeychain for GIDSignIn")
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication =  options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
        let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
        
        let googleHandler = GIDSignIn.sharedInstance().handle(
            url,
            sourceApplication: sourceApplication,
            annotation: annotation )
        
        let facebookHandler = FBSDKApplicationDelegate.sharedInstance().application (
            app,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation )
        
        return googleHandler || facebookHandler
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: -
    // MARK: Helper Methods
    // Added as a part of Track Progress feature
    // For seeding scripture name in the list
    private func seedItems() {
        let ud = UserDefaults.standard
        
        if !ud.bool(forKey: "UserDefaultsSeedItems") {
            if let filePath = Bundle.main.path(forResource: "seed", ofType: "plist"), let seedItems = NSArray(contentsOfFile: filePath) {
                // Items
                var items = [Item]()
                
                // Create List of Items
                for seedItem in seedItems as! [[String:Any]] {
                    if let name = seedItem["name"] as? String {
                        print("Printing name before adding to items array")
                        print("\(name)")
                        // Create Item
                        let item = Item(name: name)
                        
                        // Add Item
                        items.append(item)
                    }
                }
                
                print("Now printing items")
                print(items)
                
                if let itemsPath = pathForItems() {
                    print("Print itemsPath: \(itemsPath)")
                    // Write to File
                    if NSKeyedArchiver.archiveRootObject(items, toFile: itemsPath) {
                        ud.set(true, forKey: "UserDefaultsSeedItems")
                    }
                }
            }
        }
    }
    
    private func pathForItems() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let documents = paths.first, let documentsURL = NSURL(string: documents) {
            return documentsURL.appendingPathComponent("items")?.path
        }
        
        return nil
    }

    // For seeding all scripture pages in the list
    private func seedScripturePages() {
        let ud = UserDefaults.standard
        
        // Start here: Temp hack uncomment following line
        if !ud.bool(forKey: "UserDefaultsScript7SeedItems") {
            if let filePath = Bundle.main.path(forResource: "seedpages", ofType: "plist"), let seedScripturePages = NSArray(contentsOfFile: filePath) {
                // Items
                var scripturepages = [ScripturePages]()
                
                // Create List of Items
                for seedScripturePage in seedScripturePages as! [[String:Any]] {
                    if let name = seedScripturePage["name"] as? String {
                        if let pagesread = seedScripturePage["pagesread"] as? Int {
                            if let totalpages = seedScripturePage["totalpages"] as? Int {
                                if let slokasread = seedScripturePage["slokasread"] as? Int {
                                    if let totalslokas = seedScripturePage["totalslokas"] as? Int {
                                        print("Printing name, pagesread, totalpages, slokasread and totalslokas before adding to scripturepages array")
                                        print("\(name) - \(pagesread) - \(totalpages) - \(slokasread) - \(totalslokas)")
                                        // Create ScripturePages
                                        let item = ScripturePages(name: name, pagesread: pagesread, totalpages: totalpages, slokasread: slokasread, totalslokas: totalslokas)
                        
                                        // Add Item
                                        scripturepages.append(item)
                                    }
                                }
                            }
                        }
                    }
                }
                
                print("Now printing items in ScripturePages")
                for book in scripturepages {
                    print(book.name)
                    print(book.pagesread)
                    print(book.slokasread)
                    print(book.totalpages)
                    print(book.totalslokas)
                }
                //print(scripturepages)
                
                if let scripturepagesPath = pathForScripturePages() {
                    // Write to File
                    print("Print scripturepagesPath: \(scripturepagesPath)")
                    if NSKeyedArchiver.archiveRootObject(scripturepages, toFile: scripturepagesPath) {
                        ud.set(true, forKey: "UserDefaultsScript7SeedItems")
                    }
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
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            print("Failed to log into Google: ")
            print("Error \(error)")
            return
        }
        
        print("AppDelegate: Successfully logged into Google", user)
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (user, error) in
            if let error = error {
                print("Error \(error)")
                return
            }
        }
    }
    
}

