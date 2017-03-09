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
    
    //Data received via segue from TrackProgressViewController
    var scriptureLabelfromVC : String = ""
    var lineOneView = UIView()
    var lineTwoView = UIView()
    
    @IBOutlet weak var ScriptureLabel: UILabel!
    @IBOutlet weak var YouHaveReadLabel: UILabel!
    @IBOutlet weak var PagesSlokasReadLabel: UILabel!
    @IBOutlet weak var PagesSlokasLabel: UILabel!
    @IBOutlet weak var OutOfLabel: UILabel!
    @IBOutlet weak var TotalPagesSlokasLabel: UILabel!
    @IBOutlet weak var PagesSlokasLabel2: UILabel!
    @IBOutlet weak var SwitchPagesLabel: UILabel!
    @IBOutlet weak var SwitchSlokasLabel: UILabel!
    @IBOutlet weak var PagesSlokasTextField: UITextField!
    @IBOutlet weak var OfLabel: UILabel!
    @IBOutlet weak var ScriptLab: UILabel!
    @IBOutlet weak var psSwitch: UISwitch!
    
    
    @IBAction func psSwitchPressed(_ sender: UISwitch) {
        if psSwitch.isOn {
            PagesSlokasLabel.text = "slokas"
            PagesSlokasLabel2.text = "slokas"
            for book in scripturepages where book.name == ScriptureLabel.text {
                PagesSlokasReadLabel.text = String(book.slokasread)
                TotalPagesSlokasLabel.text = String(book.totalslokas)
            }
            //pages = false
            //calcPagesSlokas()
        } else {
            PagesSlokasLabel.text = "pages"
            PagesSlokasLabel2.text = "pages"
            for book in scripturepages where book.name == ScriptureLabel.text {
                PagesSlokasReadLabel.text = String(book.pagesread)
                TotalPagesSlokasLabel.text = String(book.totalpages)
            }
            //pages = true
            //calcPagesSlokas()
        }
    }
    
    
    @IBAction func AddPagesSlokas(_ sender: UIButton) {
        var number: Int!
        for book in scripturepages where book.name == ScriptureLabel.text {
            if psSwitch.isOn {
                number = calculatePagesSlokas(Operation: "Add", number: book.slokasread, finalnumber: book.totalslokas)
                if (number != -1) {
                    book.slokasread = number
                    PagesSlokasReadLabel.text = String(number)
                    saveScripturePages()
                }
                
            } else {
                number = calculatePagesSlokas(Operation: "Add", number: book.pagesread, finalnumber: book.totalpages)
                if (number != -1) {
                    book.pagesread = number
                    PagesSlokasReadLabel.text = String(number)
                    saveScripturePages()
                }
            }
        }
    }
    
    @IBAction func RemovePagesSlokas(_ sender: UIButton) {
        var number: Int!
        for book in scripturepages where book.name == ScriptureLabel.text {
            if psSwitch.isOn {
                number = calculatePagesSlokas(Operation: "Subtract", number: book.slokasread, finalnumber: book.totalslokas)
                if (number != -1) {
                    book.slokasread = number
                    PagesSlokasReadLabel.text = String(number)
                    saveScripturePages()
                }
                
            } else {
                number = calculatePagesSlokas(Operation: "Subtract", number: book.pagesread, finalnumber: book.totalpages)
                if (number != -1) {
                    book.pagesread = number
                    PagesSlokasReadLabel.text = String(number)
                    saveScripturePages()
                }
            }
        }
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
        ScriptureLabel.text = scriptureLabelfromVC
        ScriptLab.text = scriptureLabelfromVC
        PagesSlokasLabel2.text = "pages"
        PagesSlokasLabel.text = "pages"
        for book in scripturepages where book.name == ScriptureLabel.text {
            PagesSlokasReadLabel.text = String(book.pagesread)
            TotalPagesSlokasLabel.text = String(book.totalpages)
        }
        alignLabelsincenter(mainview: lineOneView, extleftlabel: YouHaveReadLabel, midleftlabel: PagesSlokasReadLabel, midrightlabel: PagesSlokasLabel, extrightlabel: OutOfLabel)
        alignLabelsincenter(mainview: lineTwoView, extleftlabel: TotalPagesSlokasLabel, midleftlabel: PagesSlokasLabel2, midrightlabel: OfLabel, extrightlabel: ScriptLab)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    // MARK: Helper Methods
    private func loadScripturePages() {
        if let filePath = pathForScripturePages(), FileManager.default.fileExists(atPath: filePath) {
            print("Print filePath in loadScripturePages: \(filePath)")
            if let archivedScripturePages = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [ScripturePages] {
                scripturepages = archivedScripturePages
                for book in scripturepages {
                    print(book.name)
                    print(book.pagesread)
                    print(book.slokasread)
                    print(book.totalpages)
                    print(book.totalslokas)
                }
                //print(scripturepages)
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
    
    private func presentNotNumericAlert() {
        let alert = UIAlertController(title: "Error!",
                                      message: "Please enter a number. Other values are not allowed",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
            action in self.parent
        }))
        self.present(alert, animated: true, completion:nil)
    }
    
    private func calculatePagesSlokas(Operation: String, number: Int, finalnumber: Int) -> Int {
        var number = number
        let finalnumber = finalnumber
            
        if (PagesSlokasTextField.text?.isNumeric)! {
            if (Operation == "Add") {
                number = number + Int(PagesSlokasTextField.text!)!
                if (number > finalnumber) {
                    number = finalnumber
                }
            } else if (Operation == "Subtract") {
                number = number - Int(PagesSlokasTextField.text!)!
                if (number < 0) {
                    number = 0
                }
            }
        return number
        } else {
            presentNotNumericAlert()
            return -1
        }
    }
    
    func alignLabelsincenter(mainview: UIView, extleftlabel: UILabel, midleftlabel: UILabel, midrightlabel:UILabel, extrightlabel: UILabel) {
        self.view.addSubview(mainview)
        mainview.translatesAutoresizingMaskIntoConstraints = false
        
        //self.view.addSubview(mainview)
        mainview.addSubview(extleftlabel)
        mainview.addSubview(midleftlabel)
        mainview.addSubview(midrightlabel)
        mainview.addSubview(extrightlabel)
        
        //Constraints
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["extleftlabel"] = extleftlabel
        viewsDict["midleftlabel"] = midleftlabel
        viewsDict["midrightlabel"] = midrightlabel
        viewsDict["extrightlabel"] = extrightlabel
        
        mainview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[extleftlabel]|", options: [], metrics: nil, views: viewsDict))
        mainview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[midleftlabel]|", options: [], metrics: nil, views: viewsDict))
        mainview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[midrightlabel]|", options: [], metrics: nil, views: viewsDict))
        mainview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[extrightlabel]|", options: [], metrics: nil, views: viewsDict))
        mainview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-[extleftlabel]-5-[midleftlabel]-5-[midrightlabel]-5-[extrightlabel]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDict))
        
        // center costView inside self
        let centerXCons = NSLayoutConstraint(item: mainview, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0);
        self.view.addConstraints([centerXCons])
    }
    
}
