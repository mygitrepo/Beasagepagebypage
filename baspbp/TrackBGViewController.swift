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
import Charts

class TrackBGViewController: UIViewController {
    
    //Data received via segue from TrackProgressViewController
    var scriptureLabelfromVC : String = ""
    var lineOneView = UIView()
    var lineTwoView = UIView()
    var retChart = PieChartView()
    
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
    @IBOutlet weak var chartView: UIView!
    
    fileprivate func slokaError() {
        // Changed so that it won't display message for book which has slokas but none
        // of them (0) have read by a user.
        //if PagesSlokasReadLabel.text == "0" || TotalPagesSlokasLabel.text == "0" {
        if TotalPagesSlokasLabel.text == "0" {
            let alert = UIAlertController(title: "Slokas Not Applicable!",
                                          message: "There are No Slokas in this book.",
                                          preferredStyle: UIAlertControllerStyle.alert)
            //Show alert for successful sign in
            self.present(alert, animated: true, completion:nil)
            // change to desired number of seconds (in this case 5 seconds)
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
                // your code with delay
                alert.dismiss(animated: true, completion: nil)
            }
            // Turn switch back to off (pages)
            psSwitch.setOn(false, animated: false)
        }
    }
    
    @IBAction func add_40_button(_ sender: UIButton) {
        validateSavescripture(operation: "Add", delta: 40, textFieldcheck: false)
    }
    @IBAction func add_20_button(_ sender: UIButton) {
        validateSavescripture(operation: "Add", delta: 20, textFieldcheck: false)
    }
    @IBAction func add_10_button(_ sender: UIButton) {
        validateSavescripture(operation: "Add", delta: 10, textFieldcheck: false)
//        var number: Int!
//        for book in scripturepages where book.name == ScriptureLabel.text {
//            if psSwitch.isOn {
//                slokaError()
//                number = calculatePagesSlokas(Operation: "Add", number: book.slokasread, TextFieldCheck: false, delta: 10, finalnumber: book.totalslokas)
//                if (number != -1) {
//                    book.slokasread = number
//                    PagesSlokasReadLabel.text = String(number)
//                    saveScripturePages()
//                }
//            } else {
//                number = calculatePagesSlokas(Operation: "Add", number: book.pagesread, TextFieldCheck: false, delta: 10, finalnumber: book.totalpages)
//                if (number != -1) {
//                    book.pagesread = number
//                    PagesSlokasReadLabel.text = String(number)
//                    saveScripturePages()
//                }
//            }
//        }
//        //First remove instance of earlier piechart
//        self.retChart.removeFromSuperview()
//        retChart = updateChartData()
    }
    
    @IBAction func add_5_button(_ sender: UIButton) {
        validateSavescripture(operation: "Add", delta: 5, textFieldcheck: false)
    }
    
    @IBAction func psSwitchPressed(_ sender: UISwitch) {
        if psSwitch.isOn {
            PagesSlokasLabel.text = "slokas"
            PagesSlokasLabel2.text = "slokas"
            for book in scripturepages where book.name == ScriptureLabel.text {
                PagesSlokasReadLabel.text = String(book.slokasread)
                TotalPagesSlokasLabel.text = String(book.totalslokas)
            }
            
            slokaError()
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
        //First remove instance of earlier piechart
        self.retChart.removeFromSuperview()
        retChart = updateChartData()
    }
    
    
    @IBAction func AddPagesSlokas(_ sender: UIButton) {
        validateSavescripture(operation: "Add", delta: 0, textFieldcheck: true)
//        var number: Int!
//        for book in scripturepages where book.name == ScriptureLabel.text {
//            if psSwitch.isOn {
//                slokaError()
//                number = calculatePagesSlokas(Operation: "Add", number: book.slokasread, TextFieldCheck: true, delta: 0, finalnumber: book.totalslokas)
//                if (number != -1) {
//                    book.slokasread = number
//                    PagesSlokasReadLabel.text = String(number)
//                    saveScripturePages()
//                }
//
//            } else {
//                number = calculatePagesSlokas(Operation: "Add", number: book.pagesread, TextFieldCheck: true, delta: 0, finalnumber: book.totalpages)
//                if (number != -1) {
//                    book.pagesread = number
//                    PagesSlokasReadLabel.text = String(number)
//                    saveScripturePages()
//                }
//            }
//        }
//        //First remove instance of earlier piechart
//        self.retChart.removeFromSuperview()
//        retChart = updateChartData()
    }
    
    @IBAction func RemovePagesSlokas(_ sender: UIButton) {
        validateSavescripture(operation: "Subtract", delta: 0, textFieldcheck: true)
//        var number: Int!
//        for book in scripturepages where book.name == ScriptureLabel.text {
//            if psSwitch.isOn {
//                slokaError()
//                number = calculatePagesSlokas(Operation: "Subtract", number: book.slokasread, TextFieldCheck: true, delta: 0, finalnumber: book.totalslokas)
//                if (number != -1) {
//                    book.slokasread = number
//                    PagesSlokasReadLabel.text = String(number)
//                    saveScripturePages()
//                }
//
//            } else {
//                number = calculatePagesSlokas(Operation: "Subtract", number: book.pagesread, TextFieldCheck: true, delta: 0, finalnumber: book.totalpages)
//                if (number != -1) {
//                    book.pagesread = number
//                    PagesSlokasReadLabel.text = String(number)
//                    saveScripturePages()
//                }
//            }
//        }
//        //First remove instance of earlier piechart
//        self.retChart.removeFromSuperview()
//        retChart = updateChartData()
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
        //let chart = PieChartView(frame: chartView.frame)
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
        retChart = updateChartData()
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
        let alert = UIAlertController(title: "Warning!",
                                      message: "Please enter a number",
                                      preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
            action in self.parent
        }))
        self.present(alert, animated: true, completion:nil)
    }
    
    private func validateSavescripture(operation: String, delta: Int, textFieldcheck: Bool) {
        var number: Int!
        for book in scripturepages where book.name == ScriptureLabel.text {
            if psSwitch.isOn {
                slokaError()
                number = calculatePagesSlokas(Operation: operation, number: book.slokasread, TextFieldCheck: textFieldcheck, delta: delta, finalnumber: book.totalslokas)
                if (number != -1) {
                    book.slokasread = number
                    PagesSlokasReadLabel.text = String(number)
                    saveScripturePages()
                }
            } else {
                number = calculatePagesSlokas(Operation: operation, number: book.pagesread, TextFieldCheck: textFieldcheck, delta: delta, finalnumber: book.totalpages)
                if (number != -1) {
                    book.pagesread = number
                    PagesSlokasReadLabel.text = String(number)
                    saveScripturePages()
                }
            }
        }
        //First remove instance of earlier piechart
        self.retChart.removeFromSuperview()
        retChart = updateChartData()
    }
    
    //private func
    private func calculatePagesSlokas(Operation: String, number: Int, TextFieldCheck: Bool, delta: Int, finalnumber: Int) -> Int {
        var number = number
        let finalnumber = finalnumber
        
        if(TextFieldCheck) {
            if (PagesSlokasTextField.text?.isNumeric)! && !(PagesSlokasTextField.text?.isEmpty)! {
                number = AddSubtractPages(Operation: Operation, number: number, delta: Int(PagesSlokasTextField.text!)!, finalnumber: finalnumber)
                return number
            } else {
                presentNotNumericAlert()
                return -1
            }
        } else {
            number = AddSubtractPages(Operation: Operation, number: number, delta: delta, finalnumber: finalnumber)
            return number
        }
    }
    
    private func AddSubtractPages(Operation: String, number: Int, delta: Int, finalnumber: Int) -> Int {
        var number = number
        let finalnumber = finalnumber
        if (Operation == "Add") {
            number = number + delta
            //number = number + Int(PagesSlokasTextField.text!)!
            if (number > finalnumber) {
                number = finalnumber
            }
        } else if (Operation == "Subtract") {
            number = number - delta
            //number = number - Int(PagesSlokasTextField.text!)!
            if (number < 0) {
                number = 0
            }
        }
        return number
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
    
    func updateChartData() -> PieChartView {
        //let chart = PieChartView(frame: self.view.frame)
        let chart = PieChartView(frame: chartView.frame)
        //First free memory occupied by preview chart view
        //self.view.removeFromSuperview()
        //chart.removeFromSuperview()
        // 2. generate chart data entries
        let label = ["Done", "To Go"]
        if let tpsl = Int(TotalPagesSlokasLabel.text!) {
            if let psrl = Int(PagesSlokasReadLabel.text!) {
                let diff=tpsl - psrl
                //let diff = Int(TotalPagesSlokasLabel.text!) - Int(PagesSlokasReadLabel.text!)
                let money = [Int(PagesSlokasReadLabel.text!), diff]
                
                var entries = [PieChartDataEntry]()
                for (index, value) in money.enumerated() {
                    let entry = PieChartDataEntry()
                    entry.y = Double(value!)
                    entry.label = label[index]
                    //entry.label.distance(from:  ,to:)
                    entries.append( entry)
                }
                
                // 3. chart setup
                let set = PieChartDataSet( values: entries, label: "Pie Chart")
                // this is custom extension method. Download the code for more details.
                var colors: [UIColor] = []
                
                for _ in 0..<money.count {
                    let red = Double(arc4random_uniform(256))
                    let green = Double(arc4random_uniform(256))
                    let blue = Double(arc4random_uniform(256))
                    let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                    colors.append(color)
                }
                set.colors = colors
                // For adding labels outside of chart
                set.xValuePosition = .outsideSlice
                set.yValuePosition = .outsideSlice
                set.valueTextColor = .black
                set.valueLineWidth = 0.5
                set.valueLinePart1Length = 0.15
                set.valueLinePart2Length = 0.3
                set.drawValuesEnabled = true
                
                let data = PieChartData(dataSet: set)
                chart.data = data
                chart.noDataText = "No data available"
                // user interaction
                chart.isUserInteractionEnabled = true
                
                //let d = Description()
                //d.text = "iOSCharts.io"
                //chart.chartDescription = d
                //chart.centerText = "Pie Chart"
                // Following line changes width of pie chart donut
                chart.holeRadiusPercent = 0.8
                chart.transparentCircleColor = UIColor.clear
                chart.legend.enabled = false
                chart.chartDescription?.text = ""
                chart.holeColor = nil
                //chart.frame.size = CGSize(width: chartView.frame.size.width, height: chartView.frame.size.height)
                
                // Adding image
                let attachment = NSTextAttachment()
                attachment.image = UIImage(named: "govardhan_parikrama")
                let attachmentString = NSAttributedString(attachment: attachment)
                let labelImg = NSMutableAttributedString(string: "")
                labelImg.append(attachmentString)
                chart.centerAttributedText = labelImg
                
                self.view.addSubview(chart)
            }
        }
    return chart
    }
}
