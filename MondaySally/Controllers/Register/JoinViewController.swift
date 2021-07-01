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
        guard let vc = self.storyboard?.instantiateViewController(identifier: "FailView") as? FailViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}
