//
//  AppDelegate.swift
//  baspbp
//
//  Created by nikul on 12/17/15.
//  Copyright © 2015 isv. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Seed Items
        seedItems()
        return true
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
}

