//
//  NewMomentSavePageViewController.swift
//  
//
//  Created by Xin Lin on 2016-02-23.
//
//

import UIKit

class NewMomentSavePageViewController: UIViewController {
    
    var canvas : NewMomentCanvasViewController?
    var manager : NewMomentManager?

    @IBOutlet weak var momentTitleDisplay: UITextField!
    @IBOutlet weak var momentCategoryDisplay: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.manager!.setSavePage(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveNewMoment"{
            self.manager!.saveMomentEntry()
        }
    }
    
    @IBAction func goBack(sender: AnyObject) {
        self.canvas!.backFromSavePage()
    }
    
    func comeFromFirstView() {
        self.canvas!.dismissViewControllerAnimated(true, completion: nil)
    }

    func setDefaultMomentTitle(title: String) {
        momentTitleDisplay.placeholder = title
    }
    
    func setDefaultMomentCategory(category: String) {
        momentCategoryDisplay.placeholder = category
    }
    
    func setMomentTitle(title: String) {
        momentTitleDisplay.text = title
    }
    
    func setMomentCategory(category: String) {
        momentCategoryDisplay.text = category
    }
    
    func getMomentEntry() -> MomentEntry {
        return self.manager!.moment!
    }

}
