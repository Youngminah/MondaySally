//
//  ProfileEditViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class ProfileEditViewController: UIViewController {

    @IBOutlet weak var photoSelectButton: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //키보드보일때, 숨길때 일어나는 뷰위치 조정.
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.updateUI()
        self.nickNameTextField.delegate = self
        self.phoneNumberTextField.delegate = self
        self.accountTextField.delegate = self
        self.emailTextField.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    
    private func updateUI(){
        self.photoSelectButton.layer.borderWidth = 1
        self.photoSelectButton.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        self.photoSelectButton.clipsToBounds = true
        self.photoSelectButton.layer.cornerRadius = self.photoSelectButton.bounds.width/2
        self.photoSelectButton.layer.masksToBounds = true
        self.nickNameTextField.layer.cornerRadius = 4
        self.nickNameTextField.clipsToBounds = true
        self.nickNameTextField.setLeftPaddingPoints(16)
        self.phoneNumberTextField.layer.cornerRadius = 4
        self.phoneNumberTextField.clipsToBounds = true
        self.phoneNumberTextField.setLeftPaddingPoints(16)
        self.accountTextField.layer.cornerRadius = 4
        self.accountTextField.clipsToBounds = true
        self.accountTextField.setLeftPaddingPoints(16)
        self.emailTextField.layer.cornerRadius = 4
        self.emailTextField.clipsToBounds = true
        self.emailTextField.setLeftPaddingPoints(16)
        self.unselectedNickNameTextFieldUI()
        self.unselectedPhoneNumberTextFieldUI()
        self.unselectedAccountTextFieldUI()
        self.unselectedEmailTextFieldUI()
    }
    
    @IBAction func completeButtonTap(_ sender: UIButton) {
    }
    
}

//키보드가 올라가거나 내려갈때, 입력 필드의 배치 지정해주기.
extension ProfileEditViewController {
    
    //아무곳이나 클릭하면 키보드 내려가게 하기
    func hideKeyboardWhenTappedAround() {
      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
      tap.cancelsTouchesInView = false
      view.addGestureRecognizer(tap)
    }
    
    @objc override func dismissKeyboard() {
      view.endEditing(true)
    }
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            print(adjustmentHeight)
            scrollViewBottom.constant = adjustmentHeight
        } else {
            scrollViewBottom.constant = 0
        }
    }
}



extension ProfileEditViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.selectedNickNameTextFieldUI()
        }
        else if textField.tag == 1{
            self.selectedPhoneNumberTextFieldUI()
        }
        else if textField.tag == 2{
            self.selectedAccountTextFieldUI()
        }
        else if textField.tag == 3{
            self.selectedEmailTextFieldUI()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.unselectedNickNameTextFieldUI()
        }
        else if textField.tag == 1{
            self.unselectedPhoneNumberTextFieldUI()
        }
        else if textField.tag == 2{
            self.unselectedAccountTextFieldUI()
        }
        else if textField.tag == 3{
            self.unselectedEmailTextFieldUI()
        }
    }
    
    
    private func selectedNickNameTextFieldUI(){
        self.nickNameTextField.layer.borderWidth = 1
        self.nickNameTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
    }
    
    private func unselectedNickNameTextFieldUI(){
        self.nickNameTextField.layer.borderWidth = 0.5
        self.nickNameTextField.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
    }
    
    private func selectedPhoneNumberTextFieldUI(){
        self.phoneNumberTextField.layer.borderWidth = 1
        self.phoneNumberTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
    }
    
    private func unselectedPhoneNumberTextFieldUI(){
        self.phoneNumberTextField.layer.borderWidth = 0.5
        self.phoneNumberTextField.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
    }
    
    private func selectedAccountTextFieldUI(){
        self.accountTextField.layer.borderWidth = 1
        self.accountTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
    }
    
    private func unselectedAccountTextFieldUI(){
        self.accountTextField.layer.borderWidth = 0.5
        self.accountTextField.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
    }
    
    private func selectedEmailTextFieldUI(){
        self.emailTextField.layer.borderWidth = 1
        self.emailTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
    }
    
    private func unselectedEmailTextFieldUI(){
        self.emailTextField.layer.borderWidth = 0.5
        self.emailTextField.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
    }

}
