//
//  RegisterNavigationViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/01.
//

import UIKit

class RegisterNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.label,
         NSAttributedString.Key.font: UIFont(name: "NotoSansCJKkr-Medium", size: 15)!]
    }

}
