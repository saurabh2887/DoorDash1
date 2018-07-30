//
//  DoorDashTabBarController.swift
//  DoorDash
//
//  Created by Saurabh Anand on 7/28/18.
//  Copyright © 2018 Saurabh Anand. All rights reserved.
//

import UIKit

class DoorDashTabBarController: UITabBarController, UITabBarControllerDelegate {

    var viewModel : DoorDashViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // set view model in both tabs view controllers
        let exploreVC = self.viewControllers?.first as! ExploreViewController
        exploreVC.viewModel = viewModel
        
        let favoritesVC = self.viewControllers?.last as! FavoritesViewController
        favoritesVC.viewModel = viewModel
    }
}
