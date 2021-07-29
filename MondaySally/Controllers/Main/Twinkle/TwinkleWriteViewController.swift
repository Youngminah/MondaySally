//
//  TwinkleWriteViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/07.
//

import UIKit
import FirebaseStorage
import Kingfisher

//MARK: 좋아요와 관련된, 이전화면으로 돌아갔을 때 reFresh하는 프로토콜 정의
protocol RefreshDelegate{
    func doRefresh()
}

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
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let writeViewModel = TwinkleWriteViewModel(dataService: TwinkleDataService())
    private let editViewModel = TwinkleEditViewModel(dataService: TwinkleDataService())
    private let storage = Storage.storage().reference()
    private var imageUrl = [String]()
    private var receiptImageURL = String()
    private var imageButtonList = [UIButton]()
    private var photoTag: Int = 0 //이미지 피커 때 사용할 버튼의 태그 번호
    var giftName = String() // 이전화면에서 받아와야하는 기프트 이름
    var clover = Int() // 이전화면에서 받아와야하는 사용클로버 정보
    var reviewsCount = 0 //텍스트뷰 카운트
    var delegate: RefreshDelegate?
    
    //처음 작성시 API로 보낼 미증빙/ 증빙기프트 인덱스
    var giftIndex = Int() // 트윙클 작성 서버 요청시 쿼리로 보낼 트윙클 인덱스
    
    //수정을 위한 데이터
    var editTwinkleIndex = Int() //수정시 쿼리로 보내야하는 트윙클 인덱스
    var editFlag = Bool()
    var editImageList = [String]()
    var editReceipt = String()
    var editContent = String()
    var imageEditFlag : [Int] = [0,0,0]
    var receiptEditFlag = 0
    var keyboardValue = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.imageButtonList = [self.imageFirstButton, self.imageSecondButton, self.imageThirdButton]
        if self.editFlag{
            self.originImageTwinkleBeforeEdit()
            self.originReceiptImageBeforEdit()
            self.editWillLoad()
        }else {
            self.notEditWillLoad()
        }
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
    
    //초기셋팅
    private func updateUI(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "게시", style: .plain, target: self, action: #selector(postButtonTap))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.label
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
        self.countLabel.text = "(\(self.editContent.count)/1000)"
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
        self.placeholderSetting()
    }
    
    private func notEditWillLoad(){
        self.title = "내 트윙클 추가하기"
    }
}

//MARK: 트윙클 수정일 때 프로토콜
extension TwinkleWriteViewController{
    // 수정시 초기 이미지 셋팅
    private func originImageTwinkleBeforeEdit() {
        let deleteButtonList = [self.deleteFirstButton, self.deleteSecondButton, self.deleteThirdButton]
        for i in 0..<editImageList.count{
            self.imageButtonList[i].showViewIndicator()
            let urlString = URL(string: editImageList[i])
            self.imageButtonList[i].kf.setImage(with: urlString, for: .normal, completionHandler:  { [weak self] result in
                guard let strongself = self else{ return }
                switch result {
                case .success( _):
                    strongself.imageButtonList[i].isSelected = true
                    strongself.imageButtonList[i].dismissViewndicator()
                    deleteButtonList[i]?.isHidden = false
                case .failure(let error):
                    print(error)
                    strongself.imageButtonList[i].dismissViewndicator()
                }
            })
        }
    }
    
    private func originReceiptImageBeforEdit(){
        self.receiptImageButton.showViewIndicator()
        let urlString = URL(string: editReceipt)
        print(editReceipt)
        self.receiptImageButton.kf.setImage(with: urlString, for: .normal, completionHandler:  { [weak self] result in
            guard let strongself = self else{ return }
            switch result {
            case .success( _):
                strongself.receiptImageButton.dismissViewndicator()
                strongself.receiptImageButton.isSelected = true
                strongself.receiptDeleteButton.isHidden = false
            case .failure(let error):
                print(error.errorDescription ?? "")
                strongself.receiptImageButton.dismissViewndicator()
            }
        })
    }
    //수정시 UI 셋팅
    private func editWillLoad(){
        self.title = "내 트윙클 수정하기"
        self.textView.text = editContent
        self.textView.textColor = UIColor.label
        self.reviewsCount = self.textView.text.count
    }
}


//MARK: 파이어베이스 & 작성 관련
extension TwinkleWriteViewController{
    
    //MARK: 버튼에 있는 이미지들 pngData로 바꾸기
    private func willPostImageList() -> [Data] {
        var cloverImageList = [Data]()
        for i in 0..<imageButtonList.count {
            if self.imageButtonList[i].isSelected {
                guard let image = self.imageButtonList[i].currentImage else { return [] }
                guard let imagePng = image.pngData() else { return [] }
                cloverImageList.append(imagePng)
            }
        }
        return cloverImageList
    }
    
    //MARK: 트윙클 작성하기 버튼 눌렀을 때 : 파이어베이스 업로드 -> 서버 업로드
    @objc func postButtonTap() {
        self.view.endEditing(true)
        let imageList = self.willPostImageList()
        if  imageList.count == 0 {
            self.showSallyNotationAlert(with: "클로버 사용 증명사진을\n올려주세요.")
            return
        }
        if !self.receiptImageButton.isSelected {
            self.showSallyNotationAlert(with: "영수증 증명사진을\n올려주세요.")
            return
        }
        if self.reviewsCount == 0  {
            self.showSallyNotationAlert(with: "트윙클 내용을\n올려주세요.")
            return
        }
        self.showTransparentIndicator()
        guard let receiptImage = receiptImageButton.currentImage else { return }
        guard let receiptImagePng = receiptImage.pngData() else { return }
        self.uploadTwinkleImages(with :imageList , index: 0, receipt: receiptImagePng)
    }
    
    //MARK: 트윙클 사진 파이어베이스에 올리기
    private func uploadTwinkleImages(with data: [Data] ,index count: Int, receipt receiptDate: Data){
        //마지막에 영수증 올리기
        if count == data.count {
            self.uploadReciptImage(with: receiptDate)
            return
        }
        if editFlag{
            if self.imageEditFlag[count] == 0{
                self.imageUrl.append(self.editImageList[count])
                self.uploadTwinkleImages(with: data, index: count + 1, receipt: receiptDate)
                return
            }
        }
        let uuid = UUID.init()
        self.storage.child("\(Constant.FIREBASE_URL)/twinkle/\(uuid)").putData(data[count], metadata: nil, completion: { [weak self] _ , error in
            guard let strongSelf = self else { return }
            guard error == nil else {
                print("파이어베이스에 업로드하는데 실패하였습니다.")
                return
            }
            strongSelf.storage.child("\(Constant.FIREBASE_URL)/twinkle/\(uuid)").downloadURL { url, error in
                guard let url = url , error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                DispatchQueue.global().sync {
                    let urlString = url.absoluteString
                    print("파이어베이스에 등록된 트윙클 이미지 URL주소 : \(urlString) 인덱스 : \(count)")
                    strongSelf.imageUrl.append(urlString)
                    strongSelf.uploadTwinkleImages(with: data, index: count + 1, receipt: receiptDate)
                }
            }
        })
    }
    
    //MARK: 영수증 사진 파이어베이스에 올리기
    private func uploadReciptImage(with data:Data){
        if editFlag{
            if self.receiptEditFlag == 0{
                self.receiptImageURL = self.editReceipt
                self.editFlag ? self.requestEditAPI() : self.requestWriteAPI()
                return
            }
        }
        let uuid = UUID.init()
        self.storage.child("\(Constant.FIREBASE_URL)/receipt/\(uuid)").putData(data, metadata: nil, completion: { [weak self] _ , error in
            guard let strongSelf = self else { return }
            guard error == nil else {
                print("파이어베이스에 업로드하는데 실패하였습니다.")
                return
            }
            strongSelf.storage.child("\(Constant.FIREBASE_URL)/receipt/\(uuid)").downloadURL { url, error in
                guard let url = url , error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                DispatchQueue.global().sync {
                    let urlString = url.absoluteString
                    print("파이어베이스에 등록된 영수증 이미지 URL주소 : \(urlString)")
                    strongSelf.receiptImageURL = urlString
                    strongSelf.editFlag ? strongSelf.requestEditAPI() : strongSelf.requestWriteAPI()
                    strongSelf.dismissIndicator()
                }
            }
        })
    }
    
    private func requestWriteAPI(){
        let input = TwinkleWriteInput(giftIndex: self.giftIndex, content: self.textView.text!, receiptImageUrl: self.receiptImageURL, twinkleImaageList: self.imageUrl)
        self.attemptFetchTwinkleWrite(with: input)
    }
    
    private func requestEditAPI(){
        let input = TwinkleEditInput(content: self.textView.text!, receiptImageUrl: self.receiptImageURL, twinkleImaageList: self.imageUrl)
        self.attemptFetchTwinkleEdit(twinkleIndex: self.editTwinkleIndex, with: input)
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
            if editFlag {
                self.imageEditFlag[0] = 1
            }
        }else if tag == 1 {
            self.imageSecondButton.setImage(image, for: .normal)
            self.imageSecondButton.isSelected = true
            self.deleteSecondButton.isHidden = false
            if editFlag {
                self.imageEditFlag[1] = 1
            }
        }else if tag == 2 {
            self.imageThirdButton.setImage(image, for: .normal)
            self.imageThirdButton.isSelected = true
            self.deleteThirdButton.isHidden = false
            if editFlag {
                self.imageEditFlag[2] = 1
            }
        }else {
            self.receiptImageButton.setImage(image, for: .normal)
            self.receiptImageButton.isSelected = true
            self.receiptDeleteButton.isHidden = false
            if editFlag {
                self.receiptEditFlag = 1
            }
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
        
        self.writeViewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.writeViewModel.isLoading ? strongSelf.showTransparentIndicator() : strongSelf.dismissIndicator()
            }
        }
        
        self.writeViewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.writeViewModel.error {
                    print("서버에서 통신 원활하지 않음 ->  +\(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.writeViewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        self.writeViewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                //Code
                if strongSelf.writeViewModel.failCode == 353 {

                }
            }
        }
        self.writeViewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("트윙클 작성에 성공했습니다 !! ")
                strongSelf.showSallyNotationAlert(with: "트윙클이 작성되었습니다.") {
                    strongSelf.delegate?.doRefresh()
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        }
        self.writeViewModel.fetchTwinkleWrite(with: input)
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
            let bottomOffset = CGPoint(x: 0, y: 50 + adjustmentHeight)
            if (bottomOffset.y > -1) {
                self.scrollView.setContentOffset(bottomOffset, animated: true)
            }
        } else {
            self.scrollViewBottom.constant = 0
            self.scrollView.scrollViewToTop(animated: true)
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
        self.reviewsCount = self.textView.text.count
        self.countLabel.text = "(\(self.reviewsCount)/1000)"
    }
    
    private func placeholderSetting() {
        self.textView.text = "트윙클 내용을 입력해주세요."
        self.textView.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
    }

}

// MARK: 트윙클 수정 API
extension TwinkleWriteViewController {
    
    private func attemptFetchTwinkleEdit(twinkleIndex index: Int, with input :TwinkleEditInput) {
        print("왜안되니?")
        self.editViewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.editViewModel.isLoading ? strongSelf.showTransparentIndicator() : strongSelf.dismissIndicator()
            }
        }
        
        self.editViewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.editViewModel.error {
                    print("서버에서 통신 원활하지 않음 ->  +\(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.editViewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        self.editViewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                //Code
                if strongSelf.editViewModel.failCode == 353 {

                }
            }
        }
        self.editViewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("트윙클 수정에 성공했습니다 !! ")
                strongSelf.showSallyNotationAlert(with: "트윙클이 수정되었습니다.") {
                    strongSelf.delegate?.doRefresh()
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        }
        self.editViewModel.fetchTwinkleEdit(twinkleIndex: index, with: input)
    }
}
