//
//  RegisterViewController.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.codeTextField.delegate = self
    }
    
    private func updateUI(){
        self.completeButton.layer.cornerRadius = 4
        self.codeTextField.layer.cornerRadius = 4
        self.codeTextField.clipsToBounds = true
        self.codeTextField.setLeftPaddingPoints(16)
        self.unselectedTextFieldUI()
        self.disableButtonSetting()
    }
    
    @IBAction func completeButtonTab(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "JoinView") as? JoinViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //화면 아무곳 클릭하면 키보드 내려가게 하기.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
    }
    
}

extension RegisterViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (codeTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if newText.count > 0 {
            self.enableButtonSetting()
        } else {
            self.disableButtonSetting()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextFieldUI()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.unselectedTextFieldUI()
    }
    
    private func enableButtonSetting(){
        self.completeButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4284791946, blue: 0.2459045947, alpha: 1)
        self.completeButton.isEnabled = true
    }
    
    private func disableButtonSetting(){
        self.completeButton.layer.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        self.completeButton.isEnabled = false
    }
    
    private func selectedTextFieldUI(){
        self.codeTextField.layer.borderWidth = 1
        self.codeTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
    }
    
    private func unselectedTextFieldUI(){
        self.codeTextField.layer.borderWidth = 0.5
        self.codeTextField.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
    }
}
