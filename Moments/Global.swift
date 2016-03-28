//
//  Global.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-28.
//  Copyright © 2016 Moments. All rights reserved.
//

class Global {

    var newMoments = [Moment]()
    
    init() {

    }
    
    func getNewMoments() -> [Moment] {
        return self.newMoments
    }

    func addNewMoment(moment: Moment) {
        newMoments.append(moment)
    }
    
    func removeNewMoment(moment: Moment) {
        if let index = newMoments.indexOf(moment) {
            newMoments.removeAtIndex(index)
        }
    }
    
}
var global = Global()

