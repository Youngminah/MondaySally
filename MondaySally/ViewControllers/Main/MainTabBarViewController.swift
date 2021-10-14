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
        self.setupStyle()

    }
    
    private func setupStyle() {
        UITabBar.clearShadow()
        //tabBar.layer.applyShadow(color: .gray, alpha: 0.1, x: 0, y: 0, blur: 20)
    }
    
    @IBAction func mainLogoButtonTap(_ sender: UIButton) {
        guard let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainNavigationView") as? MainNavigationViewController else{
            return
        }
        self.changeRootViewController(mainTabBarController)
    }
}


