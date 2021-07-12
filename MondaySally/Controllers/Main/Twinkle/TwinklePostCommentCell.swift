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

}
