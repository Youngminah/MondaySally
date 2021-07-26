//
//  TermsOfServiceDetailViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/26.
//

import UIKit

class MyPageTermsOfServiceViewController: UIViewController {

    @IBOutlet weak var serviceTextview: UITextView!
    @IBOutlet weak var personalInfoTextview: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()

    }
    
    private func updateUI(){
        self.serviceTextview.layer.borderWidth = 1
        self.serviceTextview.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        self.serviceTextview.layer.cornerRadius = 4
        self.personalInfoTextview.layer.borderWidth = 1
        self.personalInfoTextview.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        self.personalInfoTextview.layer.cornerRadius = 4
        self.serviceTextview.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 7, right: 16);
        self.personalInfoTextview.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 7, right: 16);
    }
}
