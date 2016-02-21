//
//  NewMomentViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-19.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import Foundation




class MomentComp: UIView {
    
    var coordinate: CGPoint?
    var rotation: Float?
    var priority: Int?
    var observer: Moment?
    
    init(coordinate: CGPoint, observer: Moment){
        super.init(frame: CGRect.zero)
        self.coordinate = coordinate
        self.rotation = 0
        self.priority = 0
        self.observer = observer
        self.observer!.addNewComponent( self )
    }

    override init(frame : CGRect) {
        super.init(frame : frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    
    func attach(observer: Moment){
        self.observer = observer
    }
    
    func dettach(){
        self.observer = nil
    }
    
    func moveItem(newCoordinate: CGPoint){
        self.coordinate = newCoordinate
    }
    
    func changePriority(newPriority: Int){
        self.priority = newPriority
    }
    
}

class TextComp: MomentComp{
    
    
}

class Moment {
    
    var components: [MomentComp]
    let momentId: Int
    let creationDate: String = "date"
    var title: String = "default title"
    var backgroundColour: UIColor
    var favourite: Bool
    
    init(id: Int){
        self.components = [MomentComp]()
        self.momentId = id
        self.backgroundColour = UIColor.whiteColor()
        self.favourite = false
    }
    
    func addNewComponent(newComp: MomentComp) -> Bool {
        self.components.append(newComp)
        
        return true
    }
    
    func deleteComponent(comp: MomentComp) -> Bool {
        
        return true
    }
    
    func setBackgroundColour(newBackgroundColour: UIColor) -> Bool {
        self.backgroundColour = newBackgroundColour
        
        return true
    }
    
    func setFavourite( newState: Bool ) -> Bool {
        self.favourite = newState
        
        return true
    }
}



class NewCompViewController: UIViewController {
    
    var touchLocation : CGPoint?
    var sender: NewMomentViewController?
    
    @IBAction func newTextPressed(sender: AnyObject) {
        let textView = UITextView(frame: CGRectMake(self.touchLocation!.x, self.touchLocation!.y, 120, 120))
        textView.textAlignment = NSTextAlignment.Left
        textView.textColor = UIColor.whiteColor()
        textView.backgroundColor = UIColor.brownColor()
        self.dismissViewControllerAnimated(true, completion: nil)
        self.sender!.view.addSubview(textView)
    }
    
    @IBAction func newImagePressed(sender: AnyObject) {
    }
    
    @IBAction func newAudioPressed(sender: AnyObject) {
    }
    
    @IBAction func newVideoPressed(sender: AnyObject) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("menu popup loaded")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}



class NewMomentViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var touchLocation: CGPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("New Moment page loaded")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if (touches.isEmpty) {
            print("empty")
        } else {
            let touch = touches.first!
            self.touchLocation = touch.locationInView(touch.view)
            self.performSegueWithIdentifier("showNewCompPopover", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if ( segue.identifier == "showNewCompPopover" ) {
            var vc = segue.destinationViewController as! NewCompViewController
            vc.touchLocation = self.touchLocation
            vc.sender = self
            var popoverMenuVC = vc.popoverPresentationController
            
            popoverMenuVC?.delegate = self
            popoverMenuVC?.sourceRect = CGRectMake(self.touchLocation!.x, self.touchLocation!.y, 0, 0)
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
