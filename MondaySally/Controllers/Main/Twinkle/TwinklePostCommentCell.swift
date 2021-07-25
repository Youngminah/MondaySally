//
//  TwinklePostCommentCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/06.
//

import UIKit

class TwinklePostCommentCell: UITableViewCell {

    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    private var index = Int()
    var delegate: CommentDelegate?
    
    private let regularAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.label,
        .font: UIFont(name: "NotoSansCJKkr-Regular", size: 14) as Any
    ]
    
    private let mediumAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.label,
        .font: UIFont(name: "NotoSansCJKkr-Medium", size: 14) as Any
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commentTextView.textContainer.lineFragmentPadding = 0;
        self.commentTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        self.profileImageView.layer.borderWidth = 1
        self.profileImageView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    @IBAction func deleteButtonTap(_ sender: UIButton) {
        self.showSallyQuestionAlert(with: "댓글을 삭제하시겠습니까?", message: "삭제된 댓글은 복구가 불가능합니다.") { [weak self] () in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.didPressDeleteButton(with: strongSelf.index)
        }
    }
    
    func updateUI(with data: TwinkleCommentInfo){
        //self.commentTextView =
        index = data.index
        let attributedString = NSMutableAttributedString(string: "")
        attributedString.append(NSAttributedString(string: data.nickName, attributes: mediumAttributes))
        attributedString.append(NSAttributedString(string: "  " + data.content, attributes: regularAttributes))
        self.commentTextView.attributedText = attributedString
        self.dateLabel.text = data.date
        self.setProfileImage(with: data.profileImage)
        self.setButtonHidden(with: data.isWriter)
    }

    private func setProfileImage(with url: String?){
        guard let url = url else {
            self.profileImageView.image = #imageLiteral(resourceName: "illustSallyBlank")
            return
        }
        let urlString = URL(string: url)
        self.profileImageView.kf.setImage(with: urlString)
    }
    
    private func setButtonHidden(with isWriter: String){
        if isWriter == "N" {
            self.deleteButton.isHidden = true
        }else {
            self.deleteButton.isHidden = false
        }
    }
}

extension TwinklePostCommentCell {
    
    // MARK: 커스텀 샐리 알림창 표시
    func showSallyQuestionAlert(with title: String , message: String ,complition: (() -> Void)? = nil) {
        SallyNotificationAlert.shared.showQuestionAlert(with: title, message: message)
        SallyNotificationAlert.shared.selectedYes = {
            print("확인누름")
            if complition != nil {
                complition!()
            }
        }
    }
    
    // MARK: 커스텀 샐리 확인 알림창 사라짐
    @objc func yesAlert() {
        SallyNotificationAlert.shared.yesAlert()
    }
    
    // MARK: 커스텀 샐리 취소 알림창 사라짐
    @objc func noAlert() {
        SallyNotificationAlert.shared.noAlert()
    }
    
}


//MARK: 코멘트 CRUD와 관련된 프로토콜 정의
protocol CommentDelegate{
    func didPressDeleteButton(with index: Int)
}
