//
//  TwinkleWriteViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/07.
//

import UIKit
import FirebaseStorage

class TwinkleWriteViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var cloverLabel: UILabel!
    
    //이미지 추가 버튼
    @IBOutlet weak var imageFirstButton: UIButton!
    @IBOutlet weak var imageSecondButton: UIButton!
    @IBOutlet weak var imageThirdButton: UIButton!
    @IBOutlet weak var receiptImageButton: UIButton!
    
    //삭제버튼
    @IBOutlet weak var deleteFirstButton: UIButton!
    @IBOutlet weak var deleteSecondButton: UIButton!
    @IBOutlet weak var deleteThirdButton: UIButton!
    @IBOutlet weak var receiptDeleteButton: UIButton!
    
    
    private let viewModel = TwinkleWriteViewModel(dataService: TwinkleDataService())
    private let storage = Storage.storage().reference()
    private var imageUrl = [String]()
    private var receiptImageURL = String()
    private var imageButtonList = [UIButton]()
    private var photoTag: Int = 0 //이미지 피커 때 사용할 버튼의 태그 번호
    var giftIndex = Int() // 트윙클 작성 서버 요청시 보낼 트윙클 인덱스
    var giftName = String() // 이전화면에서 받아와야하는 기프트 이름
    var clover = Int() // 이전화면에서 받아와야하는 사용클로버 정보
    var delegate: TwinkleWriteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(postButtonTap))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.label
        self.updateUI()
        self.imageButtonList = [self.imageFirstButton, self.imageSecondButton, self.imageThirdButton]
        //키보드보일때, 숨길때 일어나는 뷰위치 조정.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustInputView),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustInputView),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func selectImageButtonTap(_ sender: UIButton) {
        let vc = UIImagePickerController()
        self.photoTag = sender.tag
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    @IBAction func deleteButtonTap(_ sender: UIButton) {
        sender.isHidden = true
        self.setDefaultImage(at: sender.tag)
    }
    
    private var isReceiptImagePost: Bool {
        return self.receiptImageButton.isSelected
    }
    
}

//MARK: 파이어베이스 & 작성 관련
extension TwinkleWriteViewController{
    
    //MARK: 트윙클 작성하기 버튼 눌렀을 때 : 파이어베이스 업로드 -> 서버 업로드
    @objc func postButtonTap() {
        let imageList = self.willPostImageList()
        if  imageList.count == 0 {
            self.showSallyNotationAlert(with: "클로버 사용 증명사진을\n올려주세요.")
            return
        }
        if !isReceiptImagePost {
            self.showSallyNotationAlert(with: "영수증 증명사진을\n올려주세요.")
            return
        }
        if textView.text.count == 0 || validate(textView: textView) {
            self.showSallyNotationAlert(with: "트윙클 내용을\n올려주세요.")
            return
        }
        guard let receiptImage = receiptImageButton.currentImage else {
            print("이미지 뜯기 실패")
            return
        }
        guard let receiptImagePng = receiptImage.pngData() else {
            print("이미지 png화 실패")
            return
        }
        self.showTransparentIndicator()
        //let index = 0
        //트윙클 사진들 파이어베이스에 올리기
        for index in 0..<imageList.count{
            let uuid = UUID.init()
            self.storage.child("test/twinkle/\(uuid).png").putData(imageList[index], metadata: nil, completion: { [weak self] _ , error in
                guard let strongSelf = self else { return }
                guard error == nil else {
                    print("파이어베이스에 업로드하는데 실패하였습니다.")
                    return
                }
                strongSelf.storage.child("test/twinkle/\(uuid).png").downloadURL { url, error in
                    guard let url = url , error == nil else {
                        print(error?.localizedDescription ?? "")
                        return
                    }
                    DispatchQueue.global().sync {
                        let urlString = url.absoluteString
                        print("파이어베이스에 등록된 트윙클 이미지 URL주소 : \(urlString)")
                        strongSelf.imageUrl.append(urlString)
                        if index + 1 == imageList.count {
                            print(strongSelf.imageUrl)
                            strongSelf.uploadFirbaseImages(with: receiptImagePng)
                        }
                    }
                }
            })
        
        }
    }
    
    func validate(textView textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            return false
        }

        return true
    }
    
    //영수증 사진 파이어베이스에 올리기
    private func uploadFirbaseImages(with data:Data){
        let uuid = UUID.init()
        self.storage.child("test/receipt/\(uuid).png").putData(data, metadata: nil, completion: { [weak self] _ , error in
            guard let strongSelf = self else { return }
            guard error == nil else {
                print("파이어베이스에 업로드하는데 실패하였습니다.")
                return
            }
            strongSelf.storage.child("test/receipt/\(uuid).png").downloadURL { url, error in
                guard let url = url , error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                DispatchQueue.global().sync {
                    let urlString = url.absoluteString
                    print("파이어베이스에 등록된 영수증 이미지 URL주소 : \(urlString)")
                    strongSelf.receiptImageURL = urlString
                    let input = TwinkleWriteInput(giftIndex: strongSelf.giftIndex,
                                                  content: strongSelf.textView.text!,
                                                  receiptImageUrl: strongSelf.receiptImageURL,
                                                  twinkleImaageList: strongSelf.imageUrl)
                    strongSelf.attemptFetchTwinkleWrite(with: input)
                    strongSelf.dismissIndicator()
                }
            }
        })
    }
    
    //버튼에 있는 이미지들 pngData로 바꾸기
    private func willPostImageList() -> [Data] {
        var cloverImageList = [Data]()
        for button in imageButtonList {
            if button.isSelected {
                guard let image = button.currentImage else {
                    print("이미지 뜯기 실패")
                    return []
                }
                guard let imagePng = image.pngData() else {
                    print("이미지 png화 실패")
                    return []
                }
                cloverImageList.append(imagePng)
            }
        }
        return cloverImageList
    }
}

//MARK: 이미지 선택시 배치하기
extension TwinkleWriteViewController: UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.setSelectedImage(with: image, at: photoTag)
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func setSelectedImage(with image:UIImage, at tag: Int){
        if tag == 0 {
            self.imageFirstButton.setImage(image, for: .normal)
            self.imageFirstButton.isSelected = true
            self.deleteFirstButton.isHidden = false
        }else if tag == 1 {
            self.imageSecondButton.setImage(image, for: .normal)
            self.imageSecondButton.isSelected = true
            self.deleteSecondButton.isHidden = false
        }else if tag == 2 {
            self.imageThirdButton.setImage(image, for: .normal)
            self.imageThirdButton.isSelected = true
            self.deleteThirdButton.isHidden = false
        }else {
            self.receiptImageButton.setImage(image, for: .normal)
            self.receiptImageButton.isSelected = true
            self.receiptDeleteButton.isHidden = false
        }
    }
    
    private func setDefaultImage(at tag: Int){
        if tag == 0 {
            self.imageFirstButton.setImage(#imageLiteral(resourceName: "buttonPhotoAdd"), for: .normal)
            self.imageFirstButton.isSelected = false
        }else if tag == 1 {
            self.imageSecondButton.setImage(#imageLiteral(resourceName: "buttonPhotoAdd"), for: .normal)
            self.imageSecondButton.isSelected = false
        }else if tag == 2 {
            self.imageThirdButton.setImage(#imageLiteral(resourceName: "buttonPhotoAdd"), for: .normal)
            self.imageThirdButton.isSelected = false
        }else {
            self.receiptImageButton.setImage(#imageLiteral(resourceName: "buttonPhotoAdd"), for: .normal)
            self.receiptImageButton.isSelected = false
        }
    }
}

// MARK: 트윙클 작성 API
extension TwinkleWriteViewController {
    
    private func attemptFetchTwinkleWrite(with input :TwinkleWriteInput) {
        
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.viewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }
        
        self.viewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.viewModel.error {
                    print("서버에서 통신 원활하지 않음 ->  +\(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.viewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        self.viewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                //Code
                if strongSelf.viewModel.failCode == 353 {

                }
            }
        }
        self.viewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("트윙클 작성에 성공했습니다 !! ")
                strongSelf.showSallyNotationAlert(with: "트윙클이 작성되었습니다.") {
                    strongSelf.delegate?.didTwinkleWrite()
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        }
        self.viewModel.fetchTwinkleWrite(with: input)
    }
}


//MARK: 키보드가 올라가거나 내려갈때, 입력 필드의 배치 지정해주기
extension TwinkleWriteViewController {
    
    //아무곳이나 클릭하면 키보드 내려가게 하기
    private func hideKeyboardWhenTappedAround() {
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
}

//MARK: 텍스트뷰 관련
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
    
    private func updateCharacterCount() {
        let reviewsCount = self.textView.text.count
        self.countLabel.text = "(\(reviewsCount)/1000)"
    }
    
    private func placeholderSetting() {
        self.textView.text = "트윙클 내용을 입력해주세요."
        self.textView.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
    }
    
    //초기셋팅
    private func updateUI(){
        self.title = "내 트윙클 추가하기"
        self.giftNameLabel.text = giftName
        self.cloverLabel.text = "\(clover)"
        self.textView.layer.borderWidth = 0.5
        self.textView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        self.textView.layer.cornerRadius = 4
        self.textView.textContainer.lineFragmentPadding = 17;
        self.textView.textContainerInset = UIEdgeInsets(top: 17, left: 0, bottom: 0, right: 0);
        self.textView.delegate = self
        self.imageFirstButton.layer.cornerRadius = 4
        self.imageSecondButton.layer.cornerRadius = 4
        self.imageThirdButton.layer.cornerRadius = 4
        self.receiptImageButton.layer.cornerRadius = 4
        self.deleteFirstButton.isHidden = true
        self.deleteSecondButton.isHidden = true
        self.deleteThirdButton.isHidden = true
        self.receiptDeleteButton.isHidden = true
        placeholderSetting()
    }
}


//MARK: 좋아요와 관련된 프로토콜 정의
protocol TwinkleWriteDelegate{
    func didTwinkleWrite()
}
