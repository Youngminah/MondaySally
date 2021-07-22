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
        delegate?.didPressDeleteButton(with: index)
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
        guard let url = url else { return }
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


//MARK: 코멘트 CRUD와 관련된 프로토콜 정의
protocol CommentDelegate{
    func didPressDeleteButton(with index: Int)
}
