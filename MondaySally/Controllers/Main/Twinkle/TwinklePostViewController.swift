//
//  TwinklePostViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/06.
//

import UIKit


class TwinklePostViewController: UIViewController {

    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextFieldBottom: NSLayoutConstraint!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var twinkleDateLabel: UILabel!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var cloverLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var index = Int()
    
    private let detailViewModel = TwinkleDetailViewModel(dataService: TwinkleDataService())
    private let deleteViewModel = TwinkleDeleteViewModel(dataService: TwinkleDataService())
    private let commentWriteViewModel = TwinkleCommentWriteViewModel(dataService: TwinkleDataService())
    private let commentDeleteViewModel = TwinkleCommentDeleteViewModel(dataService: TwinkleDataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attemptFetchDetail(with : index)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustInputView),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustInputView),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        //self.hideKeyboardWhenTappedAround()
        self.updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func commentWriteButtonTap(_ sender: UIButton) {
        guard let content = self.commentTextField.text else {
            return
        }
        if content == ""{
            self.showSallyNotationAlert(with: "댓글을 입력해 주세요.")
        }
        self.commentTextField.text = ""
        self.attemptFetchCommentWrite(with: index, with: content)
        self.tableView.scrollToBottom()
    }
    
    @IBAction func likeButtonTouchUp(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    //MARK: 트윙클 수정 버튼 눌렀을 때
    @IBAction func editButtonTap(_ sender: UIButton) {
        
    }
    
    //MARK: 트윙클 삭제 버튼 눌렀을 때
    @IBAction func deleteButtonTap(_ sender: UIButton) {
        self.attemptFetchDelete(with: index)
    }
    
    private func updateUI(){
        self.postTextView.textContainer.lineFragmentPadding = 0;
        self.postTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        self.commentTextField.layer.borderWidth = 1
        self.commentTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
        self.commentTextField.layer.cornerRadius = self.commentTextField.bounds.height/2 - 3
        self.commentTextField.setLeftPaddingPoints(16)
        self.commentButton.layer.cornerRadius = self.commentButton.bounds.height/2 - 3
    }
}

//키보드가 올라가거나 내려갈때, 입력 필드의 배치 지정해주기. && 글자수 제한.
extension TwinklePostViewController : UITextFieldDelegate {
    
    //아무곳이나 클릭하면 키보드 내려가게 하기
    private func hideKeyboardWhenTappedAround() {
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
            print(commentTextFieldBottom.constant)
            print(adjustmentHeight)
            commentTextFieldBottom.constant = adjustmentHeight
        } else {
            commentTextFieldBottom.constant = 0
        }
    }
}

// MARK: 트윙클 테이블 프로토콜
extension TwinklePostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = self.detailViewModel.numOfComment
        if number == 0 {
            self.tableView.setEmptyView(message: "등록된 댓글이 없어요.")
        } else {
            self.tableView.restore()
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TwinklePostCommentCell", for: indexPath) as? TwinklePostCommentCell else {
            return UITableViewCell()
        }
        guard let data = self.detailViewModel.twinkleDetailInfo?.commentList?[indexPath.row] else {
            return cell
        }
        cell.updateUI(with: data)
        cell.delegate = self //코멘트 관련 프로토콜
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112 // also UITableViewAutomaticDimension can be used
    }
}


// MARK: 트윙클 상세 API
extension TwinklePostViewController {
    
    private func attemptFetchDetail(with index: Int, completion: (() -> Void)? = nil) {
        self.detailViewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.detailViewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }
        self.detailViewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.detailViewModel.error {
                    print("서버에서 통신 원활하지 않음 ->  +\(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.detailViewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        self.detailViewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                //Code
                if strongSelf.detailViewModel.failCode == 353 {

                }
            }
        }
        self.detailViewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("트윙클 디테일 조회에 성공했습니다 !! ")
                strongSelf.updateNetworkUI()
                strongSelf.tableView.reloadData()
                if completion != nil {
                    completion!()
                }
            }
        }
        self.detailViewModel.fetchTwinkleDetail(with: index)
    }
}

// MARK: 트윙클 삭제 API
extension TwinklePostViewController {

    private func attemptFetchDelete(with index: Int, completion: (() -> Void)? = nil) {
        self.deleteViewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.deleteViewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }
        self.deleteViewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.deleteViewModel.error {
                    print("서버에서 통신 원활하지 않음 ->  +\(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.deleteViewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        self.deleteViewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                //Code
                if strongSelf.deleteViewModel.failCode == 353 {

                }
            }
        }
        self.deleteViewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("트윙클 삭제 요청이 성공했습니다 !! ")
                strongSelf.showSallyNotationAlert(with: "트윙클이 삭제되었습니다."){
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        }
        self.deleteViewModel.fetchTwinkleDelete(with: index)
    }
}

// MARK: 트윙클 댓글 프로토콜
extension TwinklePostViewController: CommentDelegate {
    func didPressDeleteButton(with index: Int) {
        self.attemptFetchCommentDelete(with :index)
    }
}

// MARK: 트윙클 댓글 API
extension TwinklePostViewController {

    // MARK: 트윙클 댓글 작성 API
    private func attemptFetchCommentWrite(with index: Int, with content: String) {
        self.commentWriteViewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.commentWriteViewModel.isLoading ? strongSelf.showTransparentIndicator() : strongSelf.dismissIndicator()
            }
        }
        self.commentWriteViewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.commentWriteViewModel.error {
                    print("서버에서 통신 원활하지 않음 ->  +\(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.commentWriteViewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        self.commentWriteViewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                //Code
                if strongSelf.commentWriteViewModel.failCode == 353 {

                }
            }
        }
        self.commentWriteViewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("댓글 작성이 성공했습니다 !! ")
                strongSelf.attemptFetchDetail(with : index) {
                    strongSelf.tableView.scrollToBottom()
                }
            }
        }
        self.commentWriteViewModel.fetchTwinkleCommentWrite(with: index, with: content)
    }
    
    
    
    // MARK: 트윙클 댓글 삭제 API
    private func attemptFetchCommentDelete(with index: Int) {
        self.commentDeleteViewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.commentDeleteViewModel.isLoading ? strongSelf.showTransparentIndicator() : strongSelf.dismissIndicator()
            }
        }
        self.commentDeleteViewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.commentDeleteViewModel.error {
                    print("서버에서 통신 원활하지 않음 ->  +\(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.commentDeleteViewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        self.commentDeleteViewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                //Code
                if strongSelf.commentDeleteViewModel.failCode == 353 {

                }
            }
        }
        self.commentDeleteViewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("댓글 작성이 성공했습니다 !! ")
                strongSelf.attemptFetchDetail(with : strongSelf.index)
            }
        }
        self.commentDeleteViewModel.fetchTwinkleCommentDelete(with: index)
    }
}

// MARK: 트윙클 디테일 네크워크로부터 UI 업데이트
extension TwinklePostViewController {
    private func updateNetworkUI(){
        guard let data = self.detailViewModel.twinkleDetailInfo else { return }
        self.showIfWriter(with :data.isWriter)
        self.title = "\(data.writerName)님의 트윙클"
        self.twinkleDateLabel.text = data.date
        self.giftNameLabel.text = data.giftName
        self.cloverLabel.text = "\(data.clover)"
        self.postTextView.text = data.content
        let contentSize = self.postTextView.sizeThatFits(self.postTextView.bounds.size)
        self.postTextView.frame = CGRect(x: 0 , y:0, width: contentSize.width, height: contentSize.height)
        //self.tableHeaderView.frame.size.height = self.tableHeaderView.bounds.height + self.postTextView.contentSize.height - 20
        self.commentCountLabel.text = "댓글 \(data.commentCount)개"
        self.likeCountLabel.text = "좋아요 \(data.likeCount)개"
    }
    
    private func showIfWriter(with isWriter: String){
        if isWriter == "Y"{
            self.deleteButton.isHidden = false
            self.editButton.isHidden = false
        }else{
            self.deleteButton.isHidden = true
            self.editButton.isHidden = true
        }
    }
}
