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
        self.dismiss(animated: true, completion: nil)
    }
    
}
