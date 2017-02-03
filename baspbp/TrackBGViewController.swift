//
//  TrackBGViewController.swift
//  baspbp-final
//
//  Created by nikul on 1/25/17.
//  Copyright © 2017 isv. All rights reserved.
//

import UIKit
import QuartzCore
import EventKit

class TrackBGViewController: UIViewController {
    
    @IBOutlet weak var YouHaveReadLabel: UILabel!
    @IBOutlet weak var PagesSlokasReadLabel: UILabel!
    @IBOutlet weak var PagesSlokasLabel: UILabel!
    @IBOutlet weak var OutOfLabel: UILabel!
    @IBOutlet weak var TotalPagesSlokasLabel: UILabel!
    @IBOutlet weak var PagesSlokasLabel2: UILabel!
    @IBOutlet weak var OfBhagavadGitaLabel: UILabel!
    @IBOutlet weak var SwitchPagesLabel: UILabel!
    @IBOutlet weak var SwitchSlokasLabel: UILabel!
    @IBOutlet weak var PagesSlokasTextField: UITextField!
    
    @IBAction func AddPagesSlokas(_ sender: UIButton) {
        
    }
    
    @IBAction func RemovePagesSlokas(_ sender: UIButton) {
        
    }
    
    
    var scripturepages = [ScripturePages]()
    
    // MARK: -
    // MARK: Initialization
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        // Load ScripturePages
        loadScripturePages()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    // MARK: Helper Methods
    private func loadScripturePages() {
        if let filePath = pathForScripturePages(), FileManager.default.fileExists(atPath: filePath) {
            if let archivedScripturePages = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [ScripturePages] {
                scripturepages = archivedScripturePages
            }
        }
    }
    
    private func saveScripturePages() {
        if let filePath = pathForScripturePages() {
            NSKeyedArchiver.archiveRootObject(scripturepages, toFile: filePath)
        }
    }
    
    private func pathForScripturePages() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        if let documents = paths.first, let documentsURL = NSURL(string: documents) {
            return documentsURL.appendingPathComponent("scripturepages")!.path
        }
        
        return nil
    }
    
}
