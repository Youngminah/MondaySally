//
//  ViewController.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

class IntroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func directStartButtonTap(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "OnBoardingViewController") as? OnBoardingViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    

}

