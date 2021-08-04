//
//  ProfileEditViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit
import FirebaseStorage

class ProfileEditViewController: UIViewController{

    @IBOutlet weak var photoSelectButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    private let viewModel = EditProfileViewModel(dataService: AuthDataService())
    
    private let storage = Storage.storage().reference()
    private var imageURL = String()
    var delegate: RefreshDelegate?
    
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
    
    @objc func editButtonTap() {
        self.view.endEditing(true)
        self.showSallyQuestionAlert(with: "프로필을 수정하시겠습니까?") {[weak self] () in
            guard let strongSelf = self else { return }
            guard let nickName = strongSelf.nickNameTextField.text else { return }
            guard let phoneNumber = strongSelf.phoneNumberTextField.text else { return }
            guard let account = strongSelf.accountTextField.text else { return }
            guard let email = strongSelf.emailTextField.text else { return }
            print("되니?")
            if nickName.count == 0 {
                strongSelf.showSallyNotationAlert(with: "닉네임을 입력해주세요.")
                return
            }
            if !nickName.isValidNickname() {
                strongSelf.showSallyNotationAlert(with: "닉네임은 특수문자와\n숫자는 불가능합니다.")
                return
            }
            if phoneNumber.count == 0 {
                strongSelf.showSallyNotationAlert(with: "전화번호를 입력해주세요.")
                return
            }
            if !phoneNumber.isValidNumber() {
                strongSelf.showSallyNotationAlert(with: "전화번호를 숫자로만\n입력해주세요.")
                return
            }
            if phoneNumber.count != 11{
                strongSelf.showSallyNotationAlert(with: "전화번호를 11자리로\n입력해주세요.")
                return
            }
            if account.count == 0 {
                strongSelf.showSallyNotationAlert(with: "계좌번호를 입력해주세요.")
                return
            }
            if !account.isValidNumber() {
                strongSelf.showSallyNotationAlert(with: "계좌번호를 숫자로만\n입력해주세요.")
                return
            }
            if email.count == 0 {
                strongSelf.showSallyNotationAlert(with: "이메일을 입력해주세요.")
                return
            }
            if !email.isValidEmail() {
                strongSelf.showSallyNotationAlert(with: "정확한 이메일 형식을\n입력해주세요.")
                return
            }
            if !strongSelf.photoSelectButton.isSelected {
                let input = EditProfileInput(nickname: nickName, imgUrl: strongSelf.imageURL, phoneNumber: phoneNumber, bankAccount: account, email: email)
                strongSelf.attemptFetchEditProfile(with: input)
                return
            }
            guard let photo = strongSelf.photoSelectButton.imageView?.image else {
                return
            }
            guard let imageData = photo.pngData() else {
                print("이미지를 png로 만들 수 없습니다.")
                return
            }
            strongSelf.showTransparentIndicator()
            let uuid = UUID.init()
            strongSelf.storage.child("\(Constant.FIREBASE_URL)/profile/\(uuid)").putData(imageData, metadata: nil, completion: { [weak self] _ , error in
                guard let strongSelf = self else { return }
                guard error == nil else {
                    print("파이어베이스에 업로드하는데 실패하였습니다.")
                    return
                }
                strongSelf.storage.child("\(Constant.FIREBASE_URL)/profile/\(uuid)").downloadURL { url, error in
                    guard let url = url , error == nil else {
                        return
                    }
                    let urlString = url.absoluteString
                    print("파이어베이스에 등록된 프로필 이미지 URL주소 : \(urlString)")
                    let input = EditProfileInput(nickname: nickName, imgUrl: urlString, phoneNumber: phoneNumber, bankAccount: account, email: email)
                    strongSelf.attemptFetchEditProfile(with: input)
                }
            })
        }
    }
    
    @IBAction func photoSelectButtonTabp(_ sender: Any) {
        self.showActionsheet()
    }
}

//MARK: 기본 알람창 또는 UI구성 함수
extension ProfileEditViewController{
    
    private func updateUI(){
        self.title = "프로필 수정"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(editButtonTap))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.label
        self.photoSelectButton.layer.borderWidth = 1
        self.photoSelectButton.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        self.photoSelectButton.clipsToBounds = true
        self.photoSelectButton.layer.cornerRadius = self.photoSelectButton.bounds.width/2
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width/2
        self.profileImageView.alpha = 0.3
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
        self.updateProfileImage()
        self.imageURL = UserDefaults.standard.string(forKey: "imageUrl") ?? ""
        self.nickNameTextField.text = UserDefaults.standard.string(forKey: "nickName")
        self.phoneNumberTextField.text = UserDefaults.standard.string(forKey: "phoneNumber")
        self.accountTextField.text = UserDefaults.standard.string(forKey: "account")
        self.emailTextField.text = UserDefaults.standard.string(forKey: "email")
        self.unselectedNickNameTextFieldUI()
        self.unselectedPhoneNumberTextFieldUI()
        self.unselectedAccountTextFieldUI()
        self.unselectedEmailTextFieldUI()
    }
    
    //MARK: Kingfisher로 프로필 이미지 가져오고 , 예외 처리
    private func updateProfileImage(){
        guard let urlImage = UserDefaults.standard.string(forKey: "imageUrl") else {
            self.profileImageView.image = #imageLiteral(resourceName: "illustSallyBlank")
            return
        }
        if urlImage == "" {
            self.profileImageView.image = #imageLiteral(resourceName: "illustSallyBlank")
            return
        }
        self.profileImageView.showViewIndicator()
        let url = URL(string: urlImage)
        self.profileImageView.kf.setImage(with: url) { [weak self] result in
            guard let strongself = self else { return }
            switch result {
            case .success(_):
                strongself.profileImageView.dismissViewndicator()
            case .failure( _):
                print("프로필 이미지 URL의 이미지를 가져올 수 없음!!")
                strongself.profileImageView.image = #imageLiteral(resourceName: "illustSallyBlank")
                strongself.profileImageView.dismissViewndicator()
            }
        }
    }
    
    private func editSuccessSallyAlertPresent(){
        self.showSallyNotationAlert(with: "프로필 수정이\n완료되었습니다.") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func editFailAlertPresent(with message: String){
        let alert = UIAlertController(title: message, message: .none, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    private func editUserInfo(with input: EditProfileInput){
        UserDefaults.standard.setValue(input.nickname, forKey: "nickName")
        UserDefaults.standard.setValue(input.email, forKey: "email")
        UserDefaults.standard.setValue(input.imgUrl, forKey: "imageUrl")
        UserDefaults.standard.setValue(input.phoneNumber, forKey: "phoneNumber")
        UserDefaults.standard.setValue(input.bankAccount, forKey: "account")
    }
    
    private func showActionsheet(){
        
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: {_ in
            print("취소 버튼 누름")
        })
        actionsheet.addAction(cancel)
        
        let album = UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: { [weak self] _ in
            guard let strongself = self else { return }
            let vc = UIImagePickerController()
            vc.sourceType = .photoLibrary
            vc.delegate = self
            vc.allowsEditing = true
            strongself.present(vc, animated: true)
        })
        actionsheet.addAction(album)
        
        let basic = UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: {_ in
            self.profileImageView.image = #imageLiteral(resourceName: "illustSallyBlank")
            self.imageURL = ""
            self.photoSelectButton.isSelected = false
        })
        actionsheet.addAction(basic)
        
        present(actionsheet,animated: true)
    }
}


//MARK: 파이어베이스 이미지 업로드
extension ProfileEditViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.profileImageView.image = image
        self.photoSelectButton.isSelected = true
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Networking
extension ProfileEditViewController {
    //프로필 수정 API 호출 함수
    private func attemptFetchEditProfile(with input: EditProfileInput) {
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.viewModel.isLoading ? strongSelf.showTransparentIndicator() : strongSelf.dismissIndicator()
            }
        }
        
        self.viewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.viewModel.error {
                    print("서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    self?.networkFailToExit()
                }
                if let message = strongSelf.viewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                    strongSelf.editFailAlertPresent(with: message)
                }
            }
        }
        
        self.viewModel.didFinishFetch = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                print("프로필 수정이 성공했습니다 !! ->")
                UserDefaults.standard.setValue(true, forKey: "twinkleRefreshFlag")
                UserDefaults.standard.setValue(true, forKey: "homeRefreshFlag")
                strongSelf.editUserInfo(with :input)
                strongSelf.delegate?.doRefresh()
                strongSelf.editSuccessSallyAlertPresent()
            }
        }
        
        self.viewModel.fetchEditProfile(with: input)
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

extension ProfileEditViewController : UITextFieldDelegate {
    
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
    
    
    //텍스트뷰 글자수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard let text = textField.text else {return true}
        // 최대 글자수 이상을 입력한 이후에는 중간에 다른 글자를 추가할 수 없게끔 작동
        if textField.tag == 0 {
            if text.count > 9 {
                return false
            }
        }else if textField.tag == 1 {
            if text.count > 10 {
                return false
            }
        }else if textField.tag == 2 {
            if text.count > 19 {
                return false
            }
        }
        return true
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
