//
//  ProfileEditViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class ProfileEditViewController: UIViewController{

    @IBOutlet weak var photoSelectButton: UIButton!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    let viewModel = EditProfileViewModel(dataService: DataService())
    
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
    
    @IBAction func photoSelectButtonTabp(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func completeButtonTap(_ sender: UIButton) {
        let photoUrl = ""
        guard let nickName = nickNameTextField.text else {
            return
        }
        guard let phoneNumber = phoneNumberTextField.text else {
            return
        }
        guard let account = accountTextField.text else {
            return
        }
        guard let email = emailTextField.text else {
            return
        }
        guard let photo = photoSelectButton.imageView?.image else {
            let input = EditProfileInput(nickname: nickName, imgUrl: "", phoneNumber: phoneNumber, bankAccount: account, email: email)
            self.attemptFetchEditProfile(with: input)
            return
        }
        let input = EditProfileInput(nickname: nickName, imgUrl: photoUrl, phoneNumber: phoneNumber, bankAccount: account, email: email)
        self.attemptFetchEditProfile(with: input)
    }
    
}

// MARK: - Networking
extension ProfileEditViewController {
    
    //유요한 팀코드로 jwt생성 하는 API 호출 함수
    private func attemptFetchEditProfile(with input: EditProfileInput) {
        
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let _ = strongSelf.viewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }
        
        self.viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let error = self?.viewModel.error {
                    print("서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    self?.networkFailToExit()
                }
                
                if let message = self?.viewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        
        self.viewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                print("성공했습니다 !! -> \(strongSelf.viewModel.message)")
            }
        }
        
        self.viewModel.fetchEditProfile(with: input)
    }
}


extension ProfileEditViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.photoSelectButton.setImage(image, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
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
