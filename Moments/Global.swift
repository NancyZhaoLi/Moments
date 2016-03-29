//
//  Global.swift
//  Moments
//
//  Created by Yuning Xue on 2016-03-28.
//  Copyright © 2016 Moments. All rights reserved.
//

class Global {
    
    var homeViewController: HomeViewController?
    var categoriesViewController: CategoriesViewController?
    
    init() {

    }
    
    func setHomeViewController(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
    }
    
    func getHomeViewController() -> HomeViewController? {
        return homeViewController
    }
    
    func setCategoriesViewController(categoriesViewController: CategoriesViewController) {
        self.categoriesViewController = categoriesViewController
    }
    
    func getCategoriesViewController() -> CategoriesViewController? {
        return categoriesViewController
    }

    
}
var global = Global()

