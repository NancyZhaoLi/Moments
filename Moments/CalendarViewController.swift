//
//  CalendarViewController.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-19.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let day = dayView.date.day
        let randomDay = 10
        if day == randomDay {
            return true
        }
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        let color = UIColor.blueColor()
        return [color]
    }
    
}

extension CalendarViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return true
    }
    
    func spaceBetweenWeekViews() -> CGFloat {
        return -3
    }
    
    
}
