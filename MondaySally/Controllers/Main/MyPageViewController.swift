//
//  MyPageViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.width/2
    }
    
}
