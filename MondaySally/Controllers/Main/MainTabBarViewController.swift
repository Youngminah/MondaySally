//
//  MainTabBarViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
    }
    
    func setupStyle() {
        UITabBar.clearShadow()
        //tabBar.layer.applyShadow(color: .gray, alpha: 0.1, x: 0, y: 0, blur: 20)
    }
    
}


