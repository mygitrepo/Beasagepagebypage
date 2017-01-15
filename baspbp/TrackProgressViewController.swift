//
//  TrackProgressViewController.swift
//  baspbp-final
//
//  Created by nikul on 12/29/16.
//  Copyright © 2016 isv. All rights reserved.
//

import Foundation
import UIKit

class TrackProgressViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let CellIdentifier = "Cell Identifier"
    var items = [Item]()
    var list = ["Bhagavad-gita","Srimad Bhagavatam","Caitanya Caritamrta","Krsna Book","Sri Isopanishad","Nectar of Devotion","TLC", "Nectar of Instruction"]
    
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var dropDown: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    @IBAction func trackScripture(_ sender: UIButton) {
        
        if(items.contains(where: {x in x.name == textBox.text!})) {
            let alert = UIAlertController(title: "Failed!",
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
            //items.append(item)
            
            // Add Row to Table View
            tableView.insertRows(at: [IndexPath.init(row: 0, section: 0)], with: .automatic)
            //tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: (items.count - 1), inSection: 0)], withRowAnimation: .None)
            
            // Save Items
            saveItems()
            
            // Set tableView height dynamically
            UITableView_Auto_Height();
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
        super.viewWillAppear(animated)
        //UITableView_Auto_Height();
        //self.tableView.layoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if((items.count * 44) <= 264) {
            tableHeight.constant = CGFloat(items.count) * 44
        } else {
            tableHeight.constant = 264
        }
        // Need to call this line to force constraint updated
        self.view.layoutIfNeeded()
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
        
        return cell
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
    
    // Dynamic tableView height
    func UITableView_Auto_Height()
    {
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

}
