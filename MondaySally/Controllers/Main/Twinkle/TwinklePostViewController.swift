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
    
    let ex:[String] = ["그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~!그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~!그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요!그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요!", "그동안 고생했", "그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! ", "그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요!그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! " ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postTextView.text = "그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~!그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~!"
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardWhenTappedAround()
        self.updateUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
    }
    
    @IBAction func likeButtonTouchUp(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    private func updateUI(){
        self.postTextView.textContainer.lineFragmentPadding = 0;
        self.postTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        let contentSize = self.postTextView.sizeThatFits(self.postTextView.bounds.size)
        self.postTextView.frame = CGRect(x: 0 , y:0, width: contentSize.width, height: contentSize.height)
        self.tableHeaderView.frame.size.height = self.tableHeaderView.bounds.height + self.postTextView.contentSize.height
        self.title = "미누스님의 트윙클"
        self.commentTextField.layer.borderWidth = 1
        self.commentTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
        self.commentTextField.layer.cornerRadius = self.commentTextField.bounds.height/2
        self.commentTextField.setLeftPaddingPoints(16)
        self.commentButton.layer.cornerRadius = self.commentButton.bounds.height/2
    }
}

//키보드가 올라가거나 내려갈때, 입력 필드의 배치 지정해주기. && 글자수 제한.
extension TwinklePostViewController {
    
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



extension TwinklePostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TwinklePostCommentCell", for: indexPath) as? TwinklePostCommentCell else {
            return UITableViewCell()
        }
        cell.commentTextView.text = ex[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112 // also UITableViewAutomaticDimension can be used
    }
    
    
}
