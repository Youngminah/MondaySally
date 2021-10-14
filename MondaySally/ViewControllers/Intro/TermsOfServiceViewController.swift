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
    @IBOutlet weak var totalAgreeTextButton: UIButton!
    @IBOutlet weak var serviceAgreeTextButton: UIButton!
    @IBOutlet weak var personalAgreeTextButton: UIButton!
    
    
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
        self.completedButton.layer.cornerRadius = 4
        self.serviceTextView.layer.borderWidth = 1
        self.serviceTextView.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        self.serviceTextView.layer.cornerRadius = 4
        self.personalTextView.layer.borderWidth = 1
        self.personalTextView.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        self.personalTextView.layer.cornerRadius = 4
        self.serviceTextView.textContainerInset = UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 10);
        self.personalTextView.textContainerInset = UIEdgeInsets(top: 14, left: 10, bottom: 14, right: 10);
    }
    
    @IBAction func agreeButtonTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.tag == 0 {
            self.serviceAgreeButton.isSelected = sender.isSelected
            self.personalAgreeButton.isSelected = sender.isSelected
            self.serviceAgreeTextButton.isSelected = sender.isSelected
            self.personalAgreeTextButton.isSelected = sender.isSelected
            self.changeTextViewBorderColor(sender, self.serviceTextView)
            self.changeTextViewBorderColor(sender, self.personalTextView)
        }else if sender.tag == 1 {
            self.serviceAgreeTextButton.isSelected = sender.isSelected
            self.changeTextViewBorderColor(sender, self.serviceTextView)
        }else {
            self.personalAgreeTextButton.isSelected = sender.isSelected
            self.changeTextViewBorderColor(sender, self.personalTextView)
        }
        self.completedButtonEnable()
    }
    
    @IBAction func agreeTextButtonTap(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        switch sender.tag {
        case 0:
            self.serviceAgreeTextButton.isSelected = sender.isSelected
            self.personalAgreeTextButton.isSelected = sender.isSelected
            self.serviceAgreeButton.isSelected = sender.isSelected
            self.personalAgreeButton.isSelected = sender.isSelected
            self.changeTextViewBorderColor(sender, self.serviceTextView)
            self.changeTextViewBorderColor(sender, self.personalTextView)
        case 1:
            self.serviceAgreeButton.isSelected = sender.isSelected
            self.changeTextViewBorderColor(sender, self.serviceTextView)
        default:
            self.personalAgreeButton.isSelected = sender.isSelected
            self.changeTextViewBorderColor(sender, self.personalTextView)
        }
        self.completedButtonEnable()
    }
    
    private func completedButtonEnable(){
        if serviceAgreeButton.isSelected && personalAgreeButton.isSelected {
            self.totalAgreeButton.isSelected = true
            self.totalAgreeTextButton.isSelected = true
            self.completedButton.isEnabled = true
            self.completedButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4284791946, blue: 0.2459045947, alpha: 1)
        } else {
            self.totalAgreeButton.isSelected = false
            self.totalAgreeTextButton.isSelected = false
            self.completedButton.isEnabled = false
            self.completedButton.layer.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        }
    }
    
    private func changeTextViewBorderColor(_ sender: UIButton, _ textView: UITextView){
        if sender.isSelected{
            textView.layer.borderColor = #colorLiteral(red: 1, green: 0.4284791946, blue: 0.2459045947, alpha: 1)
        }else {
            textView.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        }
    }
    
    //팀 코드가 유효할 경우 조인 페이지로 이동.
    private func moveToJoinView(){
        guard let vc = self.storyboard?.instantiateViewController(identifier: "JoinView") as? JoinViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func completedButtonTap(_ sender: UIButton) {
        self.moveToJoinView()
    }
    
}
