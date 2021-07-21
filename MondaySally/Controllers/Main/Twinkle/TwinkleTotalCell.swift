//
//  TwinkleFeedCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit
import Kingfisher

class TwinkleTotalCell: UITableViewCell {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var cloverLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var delegate: LikeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.bounds.width/2
        addContentScrollView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func addContentScrollView() {
    }
    
    @IBAction func likeButtonTouchUp(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func updateUI(with data: TwinkleInfo) {
        self.nickNameLabel.text = data.nickName
        self.giftNameLabel.text = data.giftName
        self.cloverLabel.text = "\(data.clover)"
        self.contentLabel.text = data.content
        self.likeLabel.text = "좋아요 \(data.likeCount)개"
        self.commentLabel.text = "댓글 \(data.commentCount)개"
        self.dateLabel.text = data.date
        self.setProfileImage(with :data.profileImage)
        self.setThumbnailImage(with :data.thumbnailImage)
    }
    
    private func setProfileImage(with url: String?){
        guard let url = url else { return }
        let urlString = URL(string: url)
        self.profileImageButton.kf.setImage(with: urlString, for: .normal)
    }
    
    private func setThumbnailImage(with url: String){
        let urlString = URL(string: url)
        self.thumbnailImageView.kf.setImage(with: urlString)
    }
    
}


//MARK: 좋아요와 관련된 프로토콜 정의
protocol LikeDelegate{
    func didLikePressButton(with index: Int)
}
