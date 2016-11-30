//
//  ViewController.swift
//  baspbp
//
//  Created by nikul on 12/17/15.
//  Copyright © 2015 isv. All rights reserved.
//

//import Foundation
import UIKit

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var perdayLabel: UILabel!
    @IBOutlet weak var pageslokaLabel: UILabel!
    @IBOutlet weak var pageslokaSwitch: UISwitch!
    @IBOutlet weak var PagesLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var timeUnitLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var scriptureLabel: UILabel!
    @IBOutlet weak var myPickerView: UIPickerView!
    @IBAction func unwindToViewController (_ sender: UIStoryboardSegue){
            BWWalkthroughViewController().closePlayer()
            // MARK: why following line still here
            //self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    var pages = true
    @IBAction func switchPressed(_ sender: AnyObject) {
        if pageslokaSwitch.isOn {
            pageslokaLabel.text = "slokas"
            pages = false
            calcPagesSlokas()
        } else {
            pageslokaLabel.text = "pages"
            pages = true
            calcPagesSlokas()
        }
    }
    
    @IBOutlet weak var InLabel: UILabel!
    
    //Following IBOutlets are created to change constrains for iPhone5/SE
    @IBOutlet weak var FromAppLogoBotToCompReadTop: NSLayoutConstraint!
    @IBOutlet weak var FromMyPickViewTopToCompReadBot: NSLayoutConstraint!
    @IBOutlet weak var FromCompReadBotToItemLabTop: NSLayoutConstraint!
    @IBOutlet weak var FromItemLabBotToInTop: NSLayoutConstraint!
    @IBOutlet weak var FromItemLabBotToTUTop: NSLayoutConstraint!
    @IBOutlet weak var FromItemLabBotToDurLabTop: NSLayoutConstraint!
    @IBOutlet weak var FromCirBackBotToViewDemoTop: NSLayoutConstraint!
    @IBOutlet weak var FromPageLabBotToViewDemoTop: NSLayoutConstraint!
    @IBOutlet var FromViewDemoBotToBotLayGuiTop: UIView!
    @IBOutlet weak var ViewDemoHeight: NSLayoutConstraint!
    @IBOutlet weak var FromViewDemoBotToBotLay: NSLayoutConstraint!
    @IBOutlet weak var CircleBgHeight: NSLayoutConstraint!
    @IBOutlet weak var CircleBgWidth: NSLayoutConstraint!
    @IBOutlet weak var PageLabHeight: NSLayoutConstraint!
    @IBOutlet weak var PickerHeight: NSLayoutConstraint!
    @IBOutlet weak var FromCirBgBotToPagDayTop: NSLayoutConstraint!
    @IBOutlet weak var YouHavToReadHeight: NSLayoutConstraint!
    @IBOutlet weak var BeaSageLabel: UILabel!
    @IBOutlet weak var PagebyPageLabel: UILabel!
    @IBOutlet weak var SwitchtoBottom: NSLayoutConstraint!
    @IBOutlet weak var SlokastoBottom: NSLayoutConstraint!
    @IBOutlet weak var PagestoBottom: NSLayoutConstraint!
    @IBOutlet weak var PagesperdayBottoViewDemotop: NSLayoutConstraint!
    @IBOutlet weak var CirBackPngTopToPlsReadBot: NSLayoutConstraint!
    
    //Following two constrains for iPad
    @IBOutlet weak var FromTopLayBotToBeaSageLabTop: NSLayoutConstraint!
    @IBOutlet weak var FromTopLayGuiBotToAppLogoPngTop: NSLayoutConstraint!
    
    func isAppAlreadyLaunchedOnce()->Bool{
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            //print("App already launched : \(isAppAlreadyLaunchedOnce)")
            return true
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            // FIXME: Remove following line
            //print("App launched first time")
            return false
        }
    }
    
    // Define scripture array
    var scripture = [
        ["Bhagavad-gita","Srimad Bhagavatam","Caitanya Caritamrta","Krsna Book","Sri Isopanishad","Nectar of Devotion","TLC", "Nectar of Instruction"],
        ["Day", "Week", "Month", "Year"],["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"]
    ]
    
    var scriptureArray = ["Bhagavad-gita","Srimad Bhagavatam","Caitanya Caritamrta","Krsna Book","Sri Isopanishad","Nectar of Devotion","TLC", "Nectar of Instruction"]
    
    // For clickable scriptureLabel
    var urls = ["bg","sb","cc","kb","iso", "nod", "tlc", "noi"]
        
    
    let sbPages = 15119
    let bgPages = 868
    let ccPages = 6621
    let krPages = 706
    let ndPages = 407
    let tlPages = 347
    let isPages = 158
    let niPages = 130
    let sbSlokas = 14094
    let bgSlokas = 700
    let ccSlokas = 11555
    let krSlokas = 0
    let ndSlokas = 0
    let niSlokas = 11
    let tlSlokas = 0
    let isSlokas = 19
    let deviceType = UIDevice.current.modelName
    var selScripturePages = 0
    var rowWidth = 0
    var numPagesDay = 0.0
    var finalNumPages = 0
    var singularTime = ""
    var fontSize = 24
    var indurtimeView = UIView()
    var slokasperdayView = UIView()
    
    // add this right above your viewDidLoad function for right to left transition
    let transitionManager = TransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Select picker rows to be displayed when App starts
        myPickerView.selectRow(3, inComponent: 0, animated: true)
        myPickerView.selectRow(1, inComponent: 1, animated: true)
        myPickerView.selectRow(9, inComponent: 2, animated: true)
        itemLabel.text = scripture[0][3]
        timeUnitLabel.text = "Weeks"
        durationLabel.text = scripture[2][9]
        PagesLabel.text = "10"
        itemLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.itemLabelTapFunction(_:)))
        itemLabel.addGestureRecognizer(tap)
        
        print("PRINTING DEVICE:"+deviceType)
        // Change constraints based on iPhone model
        if (deviceType.range(of:"iPhone 5") != nil) || (deviceType.range(of:"iPhone SE") != nil) {
            self.FromAppLogoBotToCompReadTop.constant -= 30
            self.FromMyPickViewTopToCompReadBot.constant -= -27
            self.FromCompReadBotToItemLabTop.constant -= 9
            self.FromItemLabBotToInTop.constant -= 9
            self.FromItemLabBotToTUTop.constant -= 9
            self.FromItemLabBotToDurLabTop.constant -= 9
            self.FromCirBackBotToViewDemoTop.constant -= 10
            self.FromPageLabBotToViewDemoTop.constant -= 10
            self.ViewDemoHeight.constant -= 19
            self.FromViewDemoBotToBotLay.constant += 7
            self.CircleBgHeight.constant -= 10
            self.CircleBgWidth.constant -= 10
            self.PageLabHeight.constant -= 10
            self.PickerHeight.constant -= 20
            self.FromCirBgBotToPagDayTop.constant -= 15
            self.YouHavToReadHeight.constant -= 7
            self.BeaSageLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 34)
            self.PagebyPageLabel.font = UIFont(name: "HelveticaNeue-Light", size: 24)
            self.SwitchtoBottom.constant -= 4
            self.SlokastoBottom.constant -= 4
            self.PagestoBottom.constant -= 4
            self.CirBackPngTopToPlsReadBot.constant -= 7
            //self.PagesperdayBottoViewDemotop.constant -= 5
        } else if(deviceType.range(of:"iPad") != nil) {
            self.FromAppLogoBotToCompReadTop.constant += 200
            self.FromMyPickViewTopToCompReadBot.constant -= 197
            self.PickerHeight.constant += 180
            self.FromTopLayBotToBeaSageLabTop.constant += 100
            self.FromTopLayGuiBotToAppLogoPngTop.constant += 100
            self.FromAppLogoBotToCompReadTop.constant += 5
            self.FromAppLogoBotToCompReadTop.constant += 5
        }

        indurtimeLabelcenter()
        slokasperdayLabelcenter()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isAppAlreadyLaunchedOnce() {
            self.dismiss(animated: true, completion: nil)
            let AppViewController = (UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController)
            //let AppViewController:ViewController = ViewController()
            self.present(AppViewController, animated: true, completion: nil)
        }
    }
    
    func itemLabelTapFunction(_ sender:UITapGestureRecognizer) {
        //Action to execute once selected scripture is tapped
        let urlIndex=scriptureArray.index(of: itemLabel.text!);
        let urlString = URL(string: "http://www.vedabase.com/en/" + urls[urlIndex!])
        if (urlIndex >= 0 && urlIndex < self.urls.count) {
            UIApplication.shared.openURL(urlString!)
        }
    }
    
    // Added for right to left transition instead of bottom to top
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // this gets a reference to the screen that we're about to transition to
        let toViewController = segue.destination as UIViewController
        
        // instead of using the default transition animation, we'll ask
        // the segue to use our custom TransitionManager object to manage the transition animation
        toViewController.transitioningDelegate = self.transitionManager
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return scripture.count
    }
    
    //Original code
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return scripture[component].count
        //return time_unit.count
    }
    
    //Original code
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return scripture[component][row]
    }
    
    // Smaller fonts in picker for iPhone 5
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            // Assign font size based on iPhone model
            if (deviceType.range(of:"iPhone 5") != nil) || (deviceType.range(of:"iPhone SE") != nil) {
                fontSize = 20
            }
            //let pickerLabel = UILabel()
            var pickerLabel = view as! UILabel!
            if view == nil {  //if no label there yet
                pickerLabel = UILabel()
            }
            let titleData = scripture[component][row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: CGFloat(fontSize)),NSForegroundColorAttributeName:UIColor.black])
            pickerLabel!.attributedText = myTitle
            pickerLabel!.textAlignment = .center
            return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        //Original code
        switch(component) {
        case 0:
            itemLabel.text = scripture[component][row]
            
        case 1:
            timeUnitLabel.text = scripture[component][row]
            
        case 2:
            durationLabel.text = scripture[component][row]
            
        default: break
        }
        
        //For displaying months/weeks/years in plural
        if(Int(durationLabel.text!)! > 1 && (timeUnitLabel.text?.characters.last != "s")) {
            timeUnitLabel.text = timeUnitLabel.text!+"s"
        } else if(Int(durationLabel.text!)! < 2 && (timeUnitLabel.text?.characters.last == "s")) {
            //timeUnitLabel.text.removeAtIndex(timeUnitLabel.text.endIndex.predecessor())
            timeUnitLabel.text = String(timeUnitLabel.text!.characters.dropLast())
        }
        
        calcPagesSlokas()        
    }
    
    func imageResize (_ imageObj:UIImage, sizeChange:CGSize)-> UIImage{        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
    /* better memory management version */
    /*func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            //color the label's background
            let hue = CGFloat(row)/CGFloat(scripture[component].count)
            pickerLabel.backgroundColor = UIColor(hue: hue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        }
        let titleData = scripture[component][row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 26.0)!,NSForegroundColorAttributeName:UIColor.blackColor()])
        pickerLabel!.attributedText = myTitle
        pickerLabel!.textAlignment = .Center
        
        return pickerLabel
    }*/
    
    // for best use with multitasking , dont use a constant here.
    // this is for demonstration purposes only.
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if (deviceType.range(of:"iPhone 5") != nil) || (deviceType.range(of:"iPhone SE") != nil) {
            //don't make column width bigger for iPhone 5
            switch(component) {
                case 0:
                    rowWidth = 200
                case 1:
                    rowWidth = 70
                case 2:
                    rowWidth = 30
                default: break
            }
        } else {
            switch(component) {
                case 0:
                    rowWidth = 225
                case 1:
                    rowWidth = 85
                case 2:
                    rowWidth = 55
                default: break
            }
        }
        return CGFloat(rowWidth)
    }
    
    func adaptivePresentationStyleForPresentationController(_ controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    //func indurtimeLabelcenter(view: UIView) {
    func indurtimeLabelcenter() {
        //Align "In", "Duration Lable" and "Time Unit Label" to center
        //indurtimeView = UIView()
        self.view.addSubview(indurtimeView)
        indurtimeView.translatesAutoresizingMaskIntoConstraints = false
        //self.automaticallyAdjustsScrollViewInsets = false
        //indurtimeView.clipsToBounds = true
        //indurtimeView.backgroundColor = UIColor.white

        //self.view.addSubview(indurtimeView)
        indurtimeView.addSubview(InLabel)
        indurtimeView.addSubview(durationLabel)
        indurtimeView.addSubview(timeUnitLabel)
        
        //Constraints
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["InLabel"] = InLabel
        viewsDict["durationLabel"] = durationLabel
        viewsDict["timeunitLabel"] = timeUnitLabel
        
        indurtimeView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[InLabel]|", options: [], metrics: nil, views: viewsDict))
        indurtimeView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[durationLabel]|", options: [], metrics: nil, views: viewsDict))
        indurtimeView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[timeunitLabel]|", options: [], metrics: nil, views: viewsDict))
        indurtimeView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-[InLabel]-5-[durationLabel]-5-[timeunitLabel]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDict))
        //costView!.backgroundColor = UIColor.redColor()
        
        // center costView inside self
        let centerXCons = NSLayoutConstraint(item: indurtimeView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0);
        //let centerYCons = NSLayoutConstraint(item: indurtimeView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0);
        self.view.addConstraints([centerXCons])
        //indurtimeView.removeFromSuperview()
        //self.view.addSubview(indurtimeView)
        //self.view.bringSubview(toFront: indurtimeView)
    }
    
    func slokasperdayLabelcenter() {
        //Align "slokas/pages" and "per day Label" to center
        self.view.addSubview(slokasperdayView)
        slokasperdayView.translatesAutoresizingMaskIntoConstraints = false
        
        slokasperdayView.addSubview(pageslokaLabel)
        slokasperdayView.addSubview(perdayLabel)
        
        //Constraints
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["pageslokaLabel"] = pageslokaLabel
        viewsDict["perdayLabel"] = perdayLabel
        
        slokasperdayView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[pageslokaLabel]|", options: [], metrics: nil, views: viewsDict))
        slokasperdayView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[perdayLabel]|", options: [], metrics: nil, views: viewsDict))
        slokasperdayView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-[pageslokaLabel]-5-[perdayLabel]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: viewsDict))
        
        // center View inside self
        let centerXCons = NSLayoutConstraint(item: slokasperdayView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0);
        self.view.addConstraints([centerXCons])
    }
    
    func calcPagesSlokas() {
        PagesLabel.text = "0"
        
        if pages {
            // Original Code
            switch(itemLabel.text) {
            case "Bhagavad-gita"?:
                selScripturePages = bgPages
            case "Srimad Bhagavatam"?:
                selScripturePages = sbPages
            case "Caitanya Caritamrta"?:
                selScripturePages = ccPages
            case "Krsna Book"?:
                selScripturePages = krPages
            case "Sri Isopanishad"?:
                selScripturePages = isPages
            case "Nectar of Devotion"?:
                selScripturePages = ndPages
            case "TLC"?:
                selScripturePages = tlPages
            case "Nectar of Instruction"?:
                selScripturePages = niPages
            default: break
            }
        } else {
            switch(itemLabel.text) {
            case "Bhagavad-gita"?:
                selScripturePages = bgSlokas
            case "Srimad Bhagavatam"?:
                selScripturePages = sbSlokas
            case "Caitanya Caritamrta"?:
                selScripturePages = ccSlokas
            case "Krsna Book"?:
                selScripturePages = krSlokas
            case "Sri Isopanishad"?:
                selScripturePages = isSlokas
            case "Nectar of Devotion"?:
                selScripturePages = ndSlokas
            case "TLC"?:
                selScripturePages = tlSlokas
            case "Nectar of Instruction"?:
                selScripturePages = niSlokas
            default: break
            }
        }
        
        switch(timeUnitLabel.text) {
        case "Day"?,"Days"?:
            //numPagesDay = selScripturePages / (7 * Int(durationLabel.text!)!)
            numPagesDay = Double(selScripturePages) / Double(1 *  Int(durationLabel.text!)!)
        case "Week"?,"Weeks"?:
            //numPagesDay = selScripturePages / (7 * Int(durationLabel.text!)!)
            numPagesDay = Double(selScripturePages) / Double(7 *  Int(durationLabel.text!)!)
        //numPagesDay = Double(1000 / Int("3")!)
        case "Month"?,"Months"?:
            //numPagesDay = selScripturePages / (30 * Int(durationLabel.text!)!)
            numPagesDay = Double(selScripturePages) / Double(30 * Int(durationLabel.text!)!)
        case "Year"?,"Years"?:
            //numPagesDay = selScripturePages / (365 * Int(durationLabel.text!)!)
            numPagesDay = Double(selScripturePages) / Double(365 * Int(durationLabel.text!)!)
        default: break
        }
        
        //following code for not displaying PagesLabel as 0
        //and if scripture doesn't have any sloka then display PagesLabel as "N/A"
        if numPagesDay < 0.5 {
            //numPagesDay = 1.0
            if numPagesDay == 0 {
                PagesLabel.text = "N/A"
            } else {
                numPagesDay = 1.0
                PagesLabel.text = String(Int(round(numPagesDay)))
            }
        } else {
            //numPagesDay = Int(NSString(format:"%.1f", numPagesDay) as String)!
            //finalNumPages = round(numPagesDay)
            PagesLabel.text = String(Int(round(numPagesDay)))
        }
    }
}

