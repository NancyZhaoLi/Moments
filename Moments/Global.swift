//
//  Global.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-28.
//  Copyright © 2016 Moments. All rights reserved.
//

class Global {

    var newMoments = [Moment]()
    var editMoments = [Moment]()
    
    init() {

    }
    
    func getNewMoments() -> [Moment] {
        return self.newMoments
    }
    
    func getEditMoments() -> [Moment] {
        return self.editMoments
    }

    func addNewMoment(moment: Moment) {
        newMoments.append(moment)
    }
    
    func addEditMoment(moment: Moment) {
        editMoments.append(moment)
    }
    
    func removeNewMoment(moment: Moment) {
        if let index = newMoments.indexOf(moment) {
            newMoments.removeAtIndex(index)
        }
    }
    
    func removeEditMoment(moment: Moment) {
        if let index = editMoments.indexOf(moment) {
            editMoments.removeAtIndex(index)
        }
    }

    
}
var global = Global()

