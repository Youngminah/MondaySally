//
//  TwinkleWriteViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/07.
//

import UIKit

class TwinkleWriteViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var photoTag: Int = 0
    
    @IBOutlet weak var photoButtonFirst: UIButton!
    @IBOutlet weak var photoButtonSecond: UIButton!
    @IBOutlet weak var photoButtonThird: UIButton!
    @IBOutlet weak var receiptPhotoButton: UIButton!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    @IBOutlet weak var countLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        //키보드보일때, 숨길때 일어나는 뷰위치 조정.
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    @IBAction func photoSelectButtonTap(_ sender: UIButton) {
        let vc = UIImagePickerController()
        self.photoTag = sender.tag
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    private func updateUI(){
        self.title = "내 트윙클 추가하기"
        self.textView.layer.borderWidth = 0.5
        self.textView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        self.textView.layer.cornerRadius = 4
        self.textView.textContainer.lineFragmentPadding = 17;
        self.textView.textContainerInset = UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0);
        self.textView.delegate = self
        placeholderSetting()
    }
}

//키보드가 올라가거나 내려갈때, 입력 필드의 배치 지정해주기. && 글자수 제한.
extension TwinkleWriteViewController {
    
    //아무곳이나 클릭하면 키보드 내려가게 하기
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc override func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height
            self.scrollViewBottom.constant = -adjustmentHeight
        } else {
            self.scrollViewBottom.constant = 0
        }
    }
    
    func placeholderSetting() {
        self.textView.text = "트윙클 내용을 입력해주세요."
        self.textView.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
    }
    
    func updateCharacterCount() {
        let reviewsCount = self.textView.text.count
        self.countLabel.text = "(\(reviewsCount)/1000)"
    }
}

extension TwinkleWriteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
        if textView.textColor == #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1) {
            self.textView.text = nil
            self.textView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.textView.layer.borderWidth = 0.5
        self.textView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        if textView.text.isEmpty {
            self.textView.text = "트윙클 내용을 입력해주세요."
            self.textView.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    //텍스트뷰 글자수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        if newText.count > 0 {
            self.countLabel.textColor = #colorLiteral(red: 0.992348969, green: 0.4946574569, blue: 0.004839691333, alpha: 1)
        }else{
            self.countLabel.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
        return newText.count <= 1000
    }
}

extension TwinkleWriteViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if photoTag == 0 {
                self.photoButtonFirst.setImage(image, for: .normal)
            } else if photoTag == 1{
                self.photoButtonSecond.setImage(image, for: .normal)
            }else if photoTag == 2 {
                self.photoButtonThird.setImage(image, for: .normal)
            }else {
                self.receiptPhotoButton.setImage(image, for: .normal)
            }
            
        }
        //self.photoSelectButton.imageView?.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
