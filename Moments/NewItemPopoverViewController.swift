//
//  NewItemPopoverViewController.swift
//  Moments
//
//  Created by Mengyi LUO on 2016-03-17.
//  Copyright © 2016 Moments. All rights reserved.
//

import UIKit

protocol NewItemViewControllerDelegate {
    func addText()
}


class NewItemViewController: UIViewController {

    var text: UIButton!
    var image: UIButton!
    var audio: UIButton!
    var video: UIButton!
    var sticker: UIButton!
    var delegate: NewItemViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    convenience init() {
        self.init(delegate: nil)
    }
    
    init(delegate: NewItemViewControllerDelegate?) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
        
        initView()
        initAnimation()
        initButtons()
    }

    convenience required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func initView() {
        self.view = UIView(frame: CGRectMake(0,0,windowWidth - 40, windowWidth - 40))
        self.view.backgroundColor = UIColor.whiteColor()
        self.preferredContentSize = CGSizeMake(windowWidth - 40, windowWidth - 40)
    }
    
    func initAnimation() {
        self.modalPresentationStyle = .Popover
    }
    
    func initButtons() {
        text = createNewTextButton()
        image = createNewImageButton()
    }
    
    
    
    func createNewTextButton() -> UIButton {
        let button = UIButton(frame: CGRectMake(0,0,40,40))
        button.center = CGPointMake(windowWidth/2.0, windowHeight/2.0)
        button.setBackgroundImage(UIImage(named: "text.png"), forState: .Normal)
        button.addTarget(self, action: "newText", forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func createNewImageButton() -> UIButton {
        let button = UIButton(frame: CGRectMake(0,0,40,40))
        button.center = CGPointMake(windowWidth/2.0 - 50, windowHeight/2.0 - 50)
        button.setBackgroundImage(UIImage(named:"photo.png"), forState: .Normal)
        button.addTarget(self, action: "newImage", forControlEvents: .TouchUpInside)
        
        return button
    }
    
    func newText() {
        print("text selected")
    }

    func newImage() {
        print("image selected")
    }

}
