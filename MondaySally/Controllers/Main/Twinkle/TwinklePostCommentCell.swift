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
    @IBOutlet weak var editButton: UIButton!
    
    
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
        self.commentTextView.text = "그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~! 그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~!그동안 열심히 일한 보람이 있네요! 드디어 쌓아왔던 포인트로 가족들에게 쐈습니다 ㅎㅎ 덕분에 가족들에게 좋은 소리들었네요! 다들 포인트 활용해보세요~!"
        self.commentTextView.textContainer.lineFragmentPadding = 0;
        self.commentTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        self.profileImageView.layer.borderWidth = 1
        self.profileImageView.layer.borderColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width/2

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func updateUI(with data: TwinkleCommentInfo){
        //self.commentTextView =
        let attributedString = NSMutableAttributedString(string: "")
        attributedString.append(NSAttributedString(string: data.nickName, attributes: mediumAttributes))
        attributedString.append(NSAttributedString(string: " " + data.content, attributes: regularAttributes))
        self.commentTextView.attributedText = attributedString
        self.dateLabel.text = data.date
        self.setProfileImage(with: data.profileImage)
        self.setButtonHidden(with: data.isWriter)
    }

    private func setProfileImage(with url: String?){
        guard let url = url else { return }
        let urlString = URL(string: url)
        self.profileImageView.kf.setImage(with: urlString)
    }
    
    private func setButtonHidden(with isWriter: String){
        if isWriter == "Y" {
            self.deleteButton.isHidden = true
            self.editButton.isHidden = true
        }else {
            self.deleteButton.isHidden = false
            self.editButton.isHidden = false
        }
    }
}
