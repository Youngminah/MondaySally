//
//  FailViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/01.
//

import UIKit

class FailViewController: UIViewController {

    @IBOutlet weak var goPreviewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.goPreviewButton.layer.cornerRadius = 4
    }
    
    @IBAction func goPreviewButtonTab(_ sender: UIButton) {
        guard let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainNavigationView") as? MainNavigationViewController else{
            return
        }
        self.changeRootViewController(mainTabBarController)
    }
    
}
