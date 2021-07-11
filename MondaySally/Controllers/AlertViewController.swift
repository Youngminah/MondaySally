//
//  AlertViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/11.
//

import UIKit

class AlertViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        
    }
    


    private func updateUI(){
        self.alertView.layer.shadowColor = UIColor.black.cgColor
        self.alertView.layer.shadowOpacity = 0.5
        self.alertView.layer.shadowOffset = .zero
        self.alertView.layer.shadowRadius = 5
        
    }
    

    
}
