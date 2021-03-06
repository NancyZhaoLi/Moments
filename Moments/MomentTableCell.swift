//
//  MomentTableCell.swift
//  Moments
//
//  Created by Yuning Xue on 2016-02-25.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

class MomentTableCell: UITableViewCell {
    
    @IBOutlet weak var squareImageView: UIImageView!
    
    @IBOutlet weak var lineImageView: UIImageView!
    
    @IBOutlet weak var day: UILabel!
    
    @IBOutlet weak var daySuffix: UILabel!
    
    @IBOutlet weak var month: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var momentText: UILabel!
    
    @IBOutlet weak var momentImage: UIImageView!
    
    var image_name = "square"
    
    var showOption: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    var moment: Moment? {
        didSet {
            constructMomentTableCell()
        }
    }
    
    func constructMomentTableCell() {
        if let momentInfo = moment {
            
            if (momentInfo.numOfImage() > 0) {
                showOption = 1
            } else if (momentInfo.numOfText() > 0) {
                showOption = 2
            } else {
                showOption = 3
            }
            
            constructSquareImageView(showOption!)
            constructLineImageView()
            
            constructDay(momentInfo)
            constructDaySuffix(momentInfo)
            constructMonth(momentInfo)
            constructTitle(momentInfo)
            constructMoment(momentInfo)
            
            self.selectionStyle = UITableViewCellSelectionStyle.None
            
        }
    }
    
    func constructSquareImageView(showOption: Int) {
        
        if (showOption == 1) {
            squareImageView.image = UIImage(named: image_name)
            squareImageView.frame = CGRect(x: 60, y: 10, width: self.frame.width - 75 , height: 170)
            
        } else {
            squareImageView.image = UIImage(named: image_name)
            squareImageView.frame = CGRect(x: 60, y: 10, width: self.frame.width - 75 , height: 100)
        }
        
        
    }
    
    func constructLineImageView() {
        
        lineImageView.image = UIImage(named: "line")
        lineImageView.frame = CGRect(x: 80, y: 35, width: self.frame.width - 110, height: 3)
        lineImageView.alpha = 0.3
        
    }
    
    func constructDay(momentInfo: Moment) {
        
        let dayFmt = NSDateFormatter()
        dayFmt.dateFormat = "dd"
        
        day.text = dayFmt.stringFromDate(momentInfo.getDate())
        day.textColor = UIColor.blackColor()
        day.frame = CGRect(x: 10, y: 25, width: 80, height: 30)
        day.font = UIFont(name: "Helvetica", size: 20.0)
        day.textAlignment = NSTextAlignment.Left
        
    }
    
    func constructMonth(momentInfo: Moment) {
        
        let monthFmt = NSDateFormatter()
        monthFmt.dateFormat = "MM"
        let monthNum: String = monthFmt.stringFromDate(momentInfo.getDate())
        
        month.text = convertDayFromNumToShort(monthNum)
        month.textColor = UIColor.blackColor()
        month.frame = CGRect(x: 10, y: 55, width: 80, height: 25)
        month.font = UIFont(name: "Helvetica", size: 14.0)
        month.textAlignment = NSTextAlignment.Left
        
    }
    
    func constructDaySuffix(momentInfo: Moment) {
        
        daySuffix.text = getDaySuffix()
        daySuffix.textColor = UIColor.blackColor()
        daySuffix.frame = CGRect(x: 35, y: 33, width: 10, height: 10)
        daySuffix.font = UIFont(name: "Helvetica", size: 12.0)
        daySuffix.textAlignment = NSTextAlignment.Left
        
    }
    
    func constructTitle(momentInfo: Moment) {
        
        title.text = momentInfo.getTitle()
        title.textColor = UIColor.blackColor()
        title.frame = CGRect(x: 80, y: 10, width: self.frame.width - 110, height: 30)
        title.font = UIFont(name: "Helvetica", size: 15.0)
        title.textAlignment = NSTextAlignment.Left
        title.lineBreakMode = NSLineBreakMode.ByWordWrapping
        title.numberOfLines = 0
        
    }
    
    func constructMoment(momentInfo: Moment) {
        
        if (showOption == 1) {
            
            momentText.text = nil
            momentImage.image = momentInfo.firstImage()!.getImage()
            momentImage.frame  = CGRect(x: 80, y: 42, width: self.frame.width - 105, height: 130)
            
        } else if (showOption == 2) {
            
            momentText.text = momentInfo.firstText()!.getContent()
            
            momentText.textColor = UIColor.blackColor()
            momentText.frame = CGRect(x: 80, y: 35, width: self.frame.width - 110, height: 50)
            momentText.font = UIFont(name: "Helvetica", size: 15.0)!
            momentText.textAlignment = NSTextAlignment.Left
            momentText.lineBreakMode = NSLineBreakMode.ByWordWrapping
            momentText.numberOfLines = 0
            
            momentImage.image = nil
            
        } else {
            // TODO: add audio/video
            momentText.text = nil
            momentImage.image = nil
        }
        
    }
    
    internal func convertDayFromNumToShort(monthNum: String) -> String {
        
        var monthShort:String!
        
        switch monthNum {
            
        case "01":
            monthShort = "Jan"
        case "02":
            monthShort = "Feb"
        case "03":
            monthShort = "Mar"
        case "04":
            monthShort = "Apr"
        case "05":
            monthShort = "May"
        case "06":
            monthShort = "Jun"
        case "07":
            monthShort = "Jul"
        case "08":
            monthShort = "Aug"
        case "09":
            monthShort = "Sept"
        case "10":
            monthShort = "Oct"
        case "11":
            monthShort = "Nov"
        case "12":
            monthShort = "Dec"
        default:
            break
        }
        
        return monthShort
        
    }
    
    
    internal func getDaySuffix() -> String {
        
        let dayNum: String = day.text!
        var suffix: String!
        
        switch dayNum {
        case "01":
            suffix = "st"
        case "02":
            suffix = "nd"
        case "03":
            suffix = "rd"
        default:
            suffix = "th"
        }
        
        return suffix
        
    }
    
    
}
