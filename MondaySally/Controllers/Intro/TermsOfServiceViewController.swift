//
//  TermsOfServiceViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/15.
//

import UIKit

class TermsOfServiceViewController: UIViewController {

    @IBOutlet weak var serviceTextView: UITextView!
    @IBOutlet weak var personalTextView: UITextView!
    @IBOutlet weak var totalAgreeButton: UIButton!
    @IBOutlet weak var serviceAgreeButton: UIButton!
    @IBOutlet weak var personalAgreeButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.serviceTextView.flashScrollIndicators()
        self.personalTextView.flashScrollIndicators()
    }
    
    private func updateUI(){
        self.completedButton.isEnabled = false
        self.serviceTextView.layer.borderWidth = 1
        self.serviceTextView.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
        self.serviceTextView.layer.cornerRadius = 4
        self.personalTextView.layer.borderWidth = 1
        self.personalTextView.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
        self.personalTextView.layer.cornerRadius = 4
        self.serviceTextView.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 7, right: 16);
        self.personalTextView.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 7, right: 16);
    }
    
    @IBAction func agreeButtonTap(_ sender: UIButton) {
        if sender.tag == 0 {
            self.totalAgreeButton.isSelected = !self.totalAgreeButton.isSelected
            self.completedButtonEnable()
        }else if sender.tag == 1 {
            self.serviceAgreeButton.isSelected = !self.serviceAgreeButton.isSelected
            self.completedButtonEnable()
        }else {
            self.personalAgreeButton.isSelected = !self.personalAgreeButton.isSelected
            self.completedButtonEnable()
        }
    }
    
    private func completedButtonEnable(){
        if totalAgreeButton.isSelected && serviceAgreeButton.isSelected && personalAgreeButton.isSelected {
            self.completedButton.isEnabled = true
            self.completedButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4284791946, blue: 0.2459045947, alpha: 1)
        } else {
            self.completedButton.isEnabled = false
            self.completedButton.layer.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        }
    }
    
    @IBAction func completedButtonTap(_ sender: UIButton) {
        print("버튼누리기 성공!!")
    }
    
}
