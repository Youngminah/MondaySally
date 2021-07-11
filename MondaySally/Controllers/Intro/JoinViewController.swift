//
//  JoinViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/01.
//

import UIKit

class JoinViewController: UIViewController {

    @IBOutlet weak var goHomeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goHomeButton.layer.cornerRadius = 4
    }
    
    @IBAction func goHomeButtonTab(_ sender: UIButton) {
        guard let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainNavigationView") as? MainNavigationViewController else{
            return
        }
        self.changeRootViewController(mainTabBarController)
    }
    
}
