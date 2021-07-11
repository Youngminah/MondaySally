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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.updateUI()
        
    }
    


    private func updateUI(){
        self.alertView.layer.shadowColor = UIColor.black.cgColor
        self.alertView.layer.shadowOpacity = 0.9
        self.alertView.layer.shadowOffset = .zero
        self.alertView.layer.shadowRadius = 10
        
    }
    

    @IBAction func confirmButtonTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
