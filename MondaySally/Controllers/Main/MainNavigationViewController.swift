//
//  MainNavigationViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.label,
         NSAttributedString.Key.font: UIFont(name: "NotoSansCJKkr-Medium", size: 15)!]
    }
    


}
