//
//  ColorPickerViewController.swift
//  Moments
//
//  Created by Xin Lin on 2016-02-26.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit
import SwiftHSVColorPicker


protocol ColourPickerViewControllerDelegate {
    func selectColor(controller: ColourPickerViewController, color: UIColor)
}



class ColourPickerViewController: UIViewController {

    var colorPicker: SwiftHSVColorPicker?
    var delegate: ColourPickerViewControllerDelegate?
    
    @IBAction func selectColour(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.selectColor(self, color: self.colorPicker!.color)
        }
    }
    
    @IBAction func cancelColourPicking(sender: AnyObject) {
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let width = self.view.frame.width - 20
        let height = self.view.frame.height - 50
        self.colorPicker = SwiftHSVColorPicker(frame: CGRectMake(10,50,width,height))
        self.view.addSubview(self.colorPicker!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

    
}
