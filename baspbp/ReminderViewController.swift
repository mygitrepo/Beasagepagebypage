//
//  ReminderViewController.swift
//  baspbp-final
//
//  Created by nikul on 8/9/16.
//  Copyright © 2016 isv. All rights reserved.
//

//import Foundation
import UIKit
import EventKit

class ReminderViewController: UIViewController {
    
    var savedEventId : String = ""
    var itemLabelfromVC : String = ""
    var pagesLabelfromVC : String = ""
    var durationLabelfromVC : String = ""
    var timeUnitLabelfromVC : String = ""
    var pageSlokaLabelfromVC : String = ""
    var deviceTypefromVC : String = ""
    var timeInSecondsfromVC = 0
    var lineOneView = UIView()
    var lineTwoView = UIView()
    var lineThreeView = UIView()
    var RemindTimeInSeconds = 0
    var createReminderTitle : String = ""
    var RemindreminderTime : String = ""
    
    @IBOutlet weak var RemindYouSelLabel: UILabel!
    @IBOutlet weak var RemindPagesLabel: UILabel!
    @IBOutlet weak var RemindfromLabel: UILabel!
    @IBOutlet weak var RemindBookLabel: UILabel!
    @IBOutlet weak var RemindeverydayLabel: UILabel!
    @IBOutlet weak var RemindcompReadLabel: UILabel!
    @IBOutlet weak var RemindLabelDuration: UILabel!
    @IBOutlet weak var RemindTimeUnitLabel: UILabel!
    @IBOutlet weak var RemindPagesSlokaLabel: UILabel!
    @IBOutlet weak var RemindTimePicker: UIDatePicker!
    
    //For setting different constraints on iPhone5 & SE
    @IBOutlet weak var FromBotToSetReminder: NSLayoutConstraint!
    @IBOutlet weak var FromTopToApplogoTop: NSLayoutConstraint!
    
    
    var calendarDatabase = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(pagesLabelfromVC)
        RemindPagesLabel.text = pagesLabelfromVC
        RemindBookLabel.text = itemLabelfromVC
        RemindLabelDuration.text = durationLabelfromVC
        RemindTimeUnitLabel.text = timeUnitLabelfromVC
        RemindPagesSlokaLabel.text = pageSlokaLabelfromVC
        RemindTimeInSeconds = timeInSecondsfromVC
        alignLabelsincenter(mainview: lineOneView, leftlabel: RemindYouSelLabel, centerlabel: RemindPagesLabel, rightlabel: RemindPagesSlokaLabel)
        alignLabelsincenter(mainview: lineTwoView, leftlabel: RemindfromLabel, centerlabel: RemindBookLabel, rightlabel: RemindeverydayLabel)
        alignLabelsincenter(mainview: lineThreeView, leftlabel: RemindcompReadLabel, centerlabel: RemindLabelDuration, rightlabel: RemindTimeUnitLabel)
        if (deviceTypefromVC.range(of:"iPhone 5") != nil) || (deviceTypefromVC.range(of:"iPhone SE") != nil) {
            self.FromBotToSetReminder.constant -= 63
        } else if(deviceTypefromVC.range(of:"iPad") != nil) {
            self.FromBotToSetReminder.constant += 180
            self.FromTopToApplogoTop.constant += 80
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Created for exit segue from main app to reminder view controller
    @IBAction func unwindToViewController (_ sender: UIStoryboardSegue){
        
    }
    
    // Creates an event in the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func createEvent(_ eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
            savedEventId = event.eventIdentifier
        } catch {
            print("Bad things happened")
        }
    }
    
    // Removes an event from the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func deleteEvent(_ eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if (eventToRemove != nil) {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
            } catch {
                print("Bad things happened")
            }
        }
    }
    
    // Responds to button to add event. This checks that we have permission first, before adding the
    // event
    
    
    @IBAction func AddReminder(_ sender: Any) {
        // For adding reminder in reminder App
        calendarDatabase.requestAccess(to: EKEntityType.reminder, completion: {(granted, error) in
            if !granted {
                let alert = UIAlertController(title: "Failed",
                                              message: "App can't add Remidner as permission to access reminders NOT granted earlier!",
                                              preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: {
                    action in _ = self.parent
                }))
                self.present(alert, animated: true, completion:nil)
                print("Access to store not granted")
                print(error?.localizedDescription as Any)
            } else {
                if (self.pagesLabelfromVC == "N/A") {
                    let alert = UIAlertController(title: "Failed",
                                                  message: "Can't add Reminder because number of Slokas is N/A",
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: {
                        action in _ = self.parent
                    }))
                    self.present(alert, animated: true, completion:nil)
                } else {
                    self.createReminderTitle = "Read \(self.pagesLabelfromVC) \(self.pageSlokaLabelfromVC) from \(self.itemLabelfromVC)"
                    self.createReminder(reminderTitle: self.createReminderTitle, reminderStartDate: self.RemindTimePicker.date as NSDate)
                    let alert = UIAlertController(title: "Success",
                                                  message: "Added reminder to " + self.createReminderTitle + " everyday at " + self.RemindreminderTime,
                                                  preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: {
                        action in _ = self.parent
                    }))
                    self.present(alert, animated: true, completion:nil)
                    print("Access to store granted")
                    //print(self.RemindTimePicker.date)
                }
            }            
        })
//        createReminderTitle = "Read \(pagesLabelfromVC) pages from \(itemLabelfromVC)"
//        createReminder(reminderTitle: createReminderTitle, reminderStartDate: self.RemindTimePicker.date as NSDate)
//        let alert = UIAlertController(title: "Success",
//                                      message: "Added a reminder to " + createReminderTitle,
//                                      preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: {
//            action in self.parent
//        }))
//        present(alert, animated: true, completion:nil)
    }
    
    // Responds to button to remove event. This checks that we have permission first, before removing the
    // event
    
    // Following functions added to create reminder in reminder App instead of event in a calender
    func eventStoreAccessReminders() {
        calendarDatabase.requestAccess(to: EKEntityType.reminder, completion:
            {(granted, error) in
                if !granted {
                    print("Access to store not granted")
                }
        })
    }
    
    func accessCalendarInTheDatabase() {
        let calendars = calendarDatabase.calendars(for: EKEntityType.reminder)
        
        for calendar in calendars as [EKCalendar] {
            print("Calendar = \(calendar.title)")
        }
    }
    
    func createReminder(reminderTitle: String, reminderStartDate: NSDate) {
        let reminder = EKReminder(eventStore: self.calendarDatabase)
        
        reminder.title = reminderTitle
        let startDate = reminderStartDate
        //print("Reminder Time: \(startDate)")
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        RemindreminderTime = formatter.string(from: startDate as Date)
        let dueDate: NSDate = NSDate(timeInterval: TimeInterval(RemindTimeInSeconds), since: startDate as Date)
        //print("Reminder DueDate: \(dueDate)")
        let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let unitFlags = NSCalendar.Unit.init(rawValue: UInt.max)
        reminder.dueDateComponents = gregorian?.components(unitFlags, from: dueDate as Date)
        let rule = EKRecurrenceRule(recurrenceWith: .daily,
                                    interval: 1,
                                    daysOfTheWeek: nil,
                                    daysOfTheMonth: nil,
                                    monthsOfTheYear: nil,
                                    weeksOfTheYear: nil,
                                    daysOfTheYear: nil,
                                    setPositions: nil,
                                    end: nil)
        reminder.addRecurrenceRule(rule)
        let alarm = EKAlarm(absoluteDate: startDate as Date)
        
        reminder.addAlarm(alarm)
        
        reminder.calendar = calendarDatabase.defaultCalendarForNewReminders()
        
        do {
            try calendarDatabase.save(reminder,
                                      commit: true)
        } catch let error {
            print("Reminder failed with error \(error.localizedDescription)")
        }
    }
    
    func alignLabelsincenter(mainview: UIView, leftlabel: UILabel, centerlabel: UILabel, rightlabel:UILabel) {
        self.view.addSubview(mainview)
        mainview.translatesAutoresizingMaskIntoConstraints = false
        
        //self.view.addSubview(mainview)
        mainview.addSubview(leftlabel)
        mainview.addSubview(centerlabel)
        mainview.addSubview(rightlabel)
        
        //Constraints
        var viewsDict = Dictionary <String, UIView>()
        viewsDict["leftlabel"] = leftlabel
        viewsDict["centerlabel"] = centerlabel
        viewsDict["rightlabel"] = rightlabel
        
        mainview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[leftlabel]|", options: [], metrics: nil, views: viewsDict))
        mainview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[centerlabel]|", options: [], metrics: nil, views: viewsDict))
        mainview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[rightlabel]|", options: [], metrics: nil, views: viewsDict))
        mainview.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-[leftlabel]-5-[centerlabel]-5-[rightlabel]-|", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: viewsDict))
        
        // center costView inside self
        let centerXCons = NSLayoutConstraint(item: mainview, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0);
        self.view.addConstraints([centerXCons])
    }
}
