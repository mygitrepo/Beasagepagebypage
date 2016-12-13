//
//  MainViewController.swift
//  baspbp-final
//
//  Created by nikul on 7/21/16.
//  Copyright © 2016 isv. All rights reserved.
//

//import Foundation
import UIKit

class MainViewController: UIViewController, BWWalkthroughViewControllerDelegate {
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            //print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            //print("App launched first time")
            return false
        }
    }
    
    var needWalkthrough:Bool = true
    var walkthrough:BWWalkthroughViewController!
    
    // add this right above your viewDidLoad function for right to left transition
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if needWalkthrough {
            //self.openInstrButtonPressed()
        }
    }
    
    @IBAction func openInstrButtonPressed(){
        
        let stb = UIStoryboard(name: "Main", bundle: nil)
        walkthrough = stb.instantiateViewController(withIdentifier: "container") as! BWWalkthroughViewController
        let page_one = stb.instantiateViewController(withIdentifier: "instr_page1")
        let page_two = stb.instantiateViewController(withIdentifier: "instr_page2")
        let page_three = stb.instantiateViewController(withIdentifier: "instr_page3")
        let page_four = stb.instantiateViewController(withIdentifier: "instr_page4")
        let page_five = stb.instantiateViewController(withIdentifier: "instr_page5")
        let page_six = stb.instantiateViewController(withIdentifier: "instr_page6")
        let page_seven = stb.instantiateViewController(withIdentifier: "instr_page7")
        let page_eight = stb.instantiateViewController(withIdentifier: "instr_page8")
        
        // Attach the pages to the master
        walkthrough.delegate = self
        walkthrough.addViewController(page_one)
        walkthrough.addViewController(page_two)
        walkthrough.addViewController(page_three)
        walkthrough.addViewController(page_four)
        walkthrough.addViewController(page_five)
        walkthrough.addViewController(page_six)
        walkthrough.addViewController(page_seven)
        walkthrough.addViewController(page_eight)
        
        // For transition right to left
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
                
        self.present(walkthrough, animated: false) {
            ()->() in
            self.needWalkthrough = false
        }
    }
}

// FIXME: Do we need following code block anymore?
//extension MainViewController{
//    
//    func walkthroughCloseButtonPressed() {
//        //BWWalkthroughViewController().closePlayer()
//        //self.dismissViewControllerAnimated(true, completion: nil)
//        //let AppViewController = (UIStoryboard(name: "Main",bundle: nil).instantiateViewControllerWithIdentifier("ViewController") as! ViewController)
//        //let AppViewController:ViewController = ViewController()
//        //self.presentViewController(AppViewController, animated: true, completion: nil)
//        //BWWalkthroughViewController().closePlayer()
//    }
//}
