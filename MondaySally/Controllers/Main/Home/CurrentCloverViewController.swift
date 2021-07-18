//
//  CurrentCloverViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class CurrentCloverViewController: UIViewController {

    @IBOutlet weak var cloverLabel: UILabel!
    
    var clover = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI() 
    }
    
    private func updateUI() {
        self.cloverLabel.text = "\(clover)".insertComma
    }
}


