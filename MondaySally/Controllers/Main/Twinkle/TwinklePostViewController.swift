//
//  TwinklePostViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/06.
//

import UIKit


//MARK: 트윙클 이미지 뷰컨트롤러와 연결된 프로토콜 정의
protocol TwinkleImagePreviewDelegate{
    func showImage(with data: [String])
}

class TwinklePostViewController: UIViewController {

    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var tableHeaderView: UIView!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var commentTextFieldBottom: NSLayoutConstraint!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var twinkleDateLabel: UILabel!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var cloverLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var editOrDeleteButton: UIButton!
    
    var index = Int() //트윙클 고유인덱스
    var tableViewIndex = Int() //테이블뷰 인덱스
    private var likeCount = Int()
    private let detailViewModel = TwinkleDetailViewModel(dataService: TwinkleDataService())
    private let deleteViewModel = TwinkleDeleteViewModel(dataService: TwinkleDataService())
    private let commentWriteViewModel = TwinkleCommentWriteViewModel(dataService: TwinkleDataService())
    private let commentDeleteViewModel = TwinkleCommentDeleteViewModel(dataService: TwinkleDataService())
    private let likeViewModel = TwinkleLikeViewModel(dataService: TwinkleDataService())
    
    private var twinklePostImageViewController : TwinklePostImageViewController!
    var imageDelegate: TwinkleImagePreviewDelegate?
    var likeDelegate: LikeDelegate?
    var refreshDelegate: RefreshDelegate?
    private var originHeartStatus = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialSet()
        self.hideKeyboardWhenTappedAround()
        self.updateUI()
        self.commentTextView.delegate = self
        self.attemptFetchDetail(with : index)

    }
    
    //MARK: 컨테이너 뷰 연결
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TwinkleImageSegue" {
            let vc = segue.destination as? TwinklePostImageViewController
            twinklePostImageViewController = vc
            self.imageDelegate = vc
        }
    }
    
    @IBAction func editOrDeleteButtonTap(_ sender: UIButton) {
        self.showActionsheet()
    }
    
    @IBAction func commentWriteButtonTap(_ sender: UIButton) {
        guard let content = self.commentTextView.text else {
            return
        }
        if content == ""{
            self.showSallyNotationAlert(with: "댓글을 입력해 주세요.")
            return
        }
        self.commentTextView.text = ""
        self.attemptFetchCommentWrite(with: index, with: content)
        self.tableView.scrollToBottom()
    }
    
    @IBAction func likeButtonTouchUp(_ sender: UIButton) {
        self.attemptFetchTwinkleLike(with: index)
    }
}


//MARK: 액션시트 관련 함수
extension TwinklePostViewController{
    private func showActionsheet(){
        let actionsheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: {_ in
            print("취소 버튼 누름")
        })
        actionsheet.addAction(cancel)
        
//        //MARK: 트윙클 삭제 버튼 눌렀을 때
//        let album = UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
//            guard let strongself = self else { return }
//            strongself.deleteTwinkleButtonTap()
//        })
//        actionsheet.addAction(album)
        
        //MARK: 트윙클 수정 버튼 눌렀을 때
        let basic = UIAlertAction(title: "수정", style: .default, handler: { [weak self] _ in
            guard let strongself = self else { return }
            strongself.editTwinkleButtonTap()
        })
        actionsheet.addAction(basic)
        
        present(actionsheet,animated: true)
    }
    
    private func deleteTwinkleButtonTap(){
        self.showSallyQuestionAlert(with: "삭제하시겠습니까?", message: "삭제된 트윙클은 복구가 불가능합니다.") { [weak self] () in
            guard let strongSelf = self else { return }
            strongSelf.attemptFetchDelete(with: strongSelf.index)
        }
    }
    
    private func editTwinkleButtonTap(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TwinkleWriteView") as? TwinkleWriteViewController else{
            return
        }
        guard let imageList = self.detailViewModel.twinkleImageList else { return }
        guard let data = self.detailViewModel.twinkleDetailInfo else { return }
        vc.editFlag = true
        vc.editImageList = imageList
        vc.editContent = data.content
        vc.editReceipt = data.receiptImageUrl
        vc.editTwinkleIndex = index
        vc.isAcceptedFlag = data.isAccepted
        vc.giftName = data.giftName
        vc.clover = data.clover
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



// MARK: 트윙클 작성 완료시 네트워크 다시 요청
extension TwinklePostViewController: RefreshDelegate{
    func doRefresh() {
        self.attemptFetchDetail(with : index)
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
                let _ = strongSelf.detailViewModel.isLoading ? strongSelf.showTransparentIndicator() : strongSelf.dismissIndicator()
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
                //트윙클 삭제된 경우
                if strongSelf.detailViewModel.failCode == 367 {
                    self?.showSallyNotationAlert(with: "해당 트윙클은 삭제되었습니다.") {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        self.detailViewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("트윙클 디테일 조회에 성공했습니다 !! ")
                guard let data = strongSelf.detailViewModel.twinkleImageList else { return }
                strongSelf.imageDelegate?.showImage(with: data)
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
                let _ = strongSelf.deleteViewModel.isLoading ? strongSelf.showTransparentIndicator() : strongSelf.dismissIndicator()
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
                strongSelf.refreshDelegate?.doRefresh()
                strongSelf.showSallyNotationAlert(with: "트윙클이 삭제되었습니다."){
                    strongSelf.navigationController?.popViewController(animated: true)
                }
            }
        }
        self.deleteViewModel.fetchTwinkleDelete(with: index)
    }
}

// MARK: 트윙클 좋아요 API
extension TwinklePostViewController {
    private func attemptFetchTwinkleLike(with index :Int) {
        self.likeViewModel.didFinishFetch = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                print("좋아요/좋아요취소 요청에 성공했습니다 !! ")
                strongSelf.likeButton.isSelected = !strongSelf.likeButton.isSelected
                if strongSelf.likeButton.isSelected{
                    strongSelf.likeCount = strongSelf.likeCount + 1
                    strongSelf.likeCountLabel.text = "좋아요 \(strongSelf.likeCount)개"
                }else{
                    strongSelf.likeCount = strongSelf.likeCount - 1
                    strongSelf.likeCountLabel.text = "좋아요 \(strongSelf.likeCount)개"
                }
                strongSelf.refreshDelegate?.doRefresh()
            }
        }
        self.likeViewModel.fetchTwinkleLike(with: index)
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
                strongSelf.refreshDelegate?.doRefresh()
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
                print("댓글 삭제에 성공했습니다 !! ")
                strongSelf.refreshDelegate?.doRefresh()
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
        self.updateHeartButton(with: data.isHearted)
        self.title = "\(data.writerName)님의 트윙클"
        self.twinkleDateLabel.text = data.date
        self.giftNameLabel.text = data.giftName
        self.cloverLabel.text = "\(data.clover)"
        self.commentCountLabel.text = "댓글 \(data.commentCount)개"
        self.likeCount = data.likeCount
        self.likeCountLabel.text = "좋아요 \(data.likeCount)개"
        self.originHeartStatus = self.likeButton.isSelected
        self.postTextView.text = data.content
        let contentSize = self.postTextView.sizeThatFits(self.postTextView.bounds.size)
        self.postTextView.frame = CGRect(x: 0 , y:0, width: contentSize.width, height: contentSize.height)
        self.tableHeaderView.frame.size.height = self.view.width + 166 + self.postTextView.contentSize.height
    }
    
    //삼한연산자로 바꾸기
    private func showIfWriter(with isWriter: String){
        if isWriter == "Y"{
            self.editOrDeleteButton.isHidden = false
        }else{
            self.editOrDeleteButton.isHidden = true
        }
    }
    
    //삼한연산자로 바꾸기
    private func updateHeartButton(with isHeart: String){
        if isHeart == "Y"{
            self.likeButton.isSelected = true
        }else {
            self.likeButton.isSelected = false
        }
    }
    
    private func updateUI(){
        self.navigationItem.backButtonTitle = " "
        self.postTextView.textContainer.lineFragmentPadding = 0;
        self.postTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        self.commentTextView.layer.borderWidth = 1
        self.commentTextView.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
        self.commentTextView.layer.cornerRadius = self.commentTextView.bounds.height/2 - 3
        self.commentTextView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16);
        //self.commentTextView.setRightPaddingPoints(16)
        self.commentButton.layer.cornerRadius = self.commentButton.bounds.height/2 - 3
    }
}


//키보드가 올라가거나 내려갈때, 입력 필드의 배치 지정해주기. && 글자수 제한.
extension TwinklePostViewController : UITextViewDelegate {

    //텍스트뷰 글자수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 100
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1) {
            self.commentTextView.text = nil
            self.commentTextView.textColor = UIColor.label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.commentTextView.text = "댓글을 입력해주세요."
            self.commentTextView.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        }
    }
    
    private func placeholderSetting() {
        self.commentTextView.text = "댓글을 입력해주세요."
        self.commentTextView.textColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
    }
    
    private func setInitialSet(){
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustInputView),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(adjustInputView),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        self.placeholderSetting()
    }
    
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
            commentTextFieldBottom.constant = adjustmentHeight
        } else {
            commentTextFieldBottom.constant = 0
        }
    }
}
