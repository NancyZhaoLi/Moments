//
//  CalendarViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-19.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: UIViewController, NewMomentViewControllerDelegate {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    var pickedDay:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "calendarBG")!)
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BackgroundImage")!)
        monthLabel.text = CVDate(date: NSDate()).globalDescription
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
        
        calendarView.backgroundColor = UIColor.customBackgroundColor()
        menuView.backgroundColor = UIColor.customBackgroundColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    @IBAction func getToday(sender: AnyObject) {
        calendarView.toggleCurrentDayView()
    }
    
    @IBAction func getNextMonth(sender: AnyObject) {
        calendarView.loadNextView()
    }
    
    @IBAction func getPreMonth(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "calendarDay" {
            let calendarDayViewController = segue.destinationViewController as! CalendarDayViewController
            calendarDayViewController.date = pickedDay
        } else if segue.identifier == "CalenderToNewMoment" {
            let newMomentNavigationVC = segue.destinationViewController as! NewMomentNavigationController
            newMomentNavigationVC.setDelegate(self)
        }
    }
    
    func newMoment(controller: NewMomentSavePageViewController, moment: Moment) {
        print("new moment in calendar view")
        
        if moment.save() {
            print("after saving a new moment")
            if let home = global.getHomeViewController() {
                home.newMoment(moment)
            }
            //global.addNewMoment(moment)
        }
        
    }
    
    func updateMoment(controller: NewMomentSavePageViewController, moment: Moment) {
        print("update moment in calendar view")
    }
    
}

extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {

    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return true
    }
    
    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
        pickedDay = dayView.date.convertedDate()

        self.performSegueWithIdentifier("calendarDay", sender: self)
    }
    
    
    
    func presentedDateUpdated(date: CVDate) {
        monthLabel.text = calendarView.presentedDate.globalDescription
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 16
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        
        let count = CoreDataFetchHelper.fetchDayMomentsCountFromCoreData(dayView.date.date)
        
        if count > 0 {
            return true
        }
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        let count = CoreDataFetchHelper.fetchDayMomentsCountFromCoreData(dayView.date.date)
        var color: UIColor
        
        switch count {
            
        case 1:
            color = UIColor.dotColor1()
            
        case 2:
            color = UIColor.dotColor2()
        
        case 3:
            color = UIColor.dotColor3()
            
        default:
            color = UIColor.dotColor4()
            
        }
        
        //let color = UIColor.dotColor1()
        return [color]
    }

    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let highlight = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        highlight.fillColor = .colorFromCode(0xF5DEB3)
        return highlight
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
}

extension CalendarViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return true
    }
    
    func spaceBetweenWeekViews() -> CGFloat {
        return -2
    }
    
    
}
