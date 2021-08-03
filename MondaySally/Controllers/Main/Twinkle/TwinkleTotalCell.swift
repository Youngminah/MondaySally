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
    @IBOutlet weak var likeButton: UIButton!
    
    var delegate: LikeDelegate?
    var tableViewIndex:Int?
    var likeIndex = Int()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.bounds.width/2
        self.addContentScrollView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func addContentScrollView() {
    }
    
    @IBAction func likeButtonTouchUp(_ sender: UIButton) {
        guard let index = tableViewIndex else {return}
        //sender.isSelected = !sender.isSelected
        if sender.isSelected {
            delegate?.didLikePressButton(with: index, status: "N", likeIndex: likeIndex)
        }else{
            delegate?.didLikePressButton(with: index, status: "Y", likeIndex: likeIndex)
        }
    }
    
    func updateUI(with data: TwinkleInfo) {
        self.likeIndex = data.index
        self.setLikeButtonStatus(with : data.isHearted)
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
    
    private func setLikeButtonStatus(with status: String){
        if status == "Y"{
            self.likeButton.isSelected = true
        }else {
            self.likeButton.isSelected = false
        }
    }
    
    private func setProfileImage(with url: String?){
        guard let imageUrl = url, url != "" else {
            self.profileImageButton.setImage(#imageLiteral(resourceName: "illustSallyBlank"), for: .normal)
            return
        }
        self.profileImageButton.showViewIndicator()
        let urlString = URL(string: imageUrl)
        self.profileImageButton.kf.setImage(with: urlString, for: .normal, completionHandler:  { result in
            switch result {
            case .success(_):
                self.profileImageButton.dismissViewndicator()
            case .failure(let error):
                print(error)
                self.profileImageButton.dismissViewndicator()
            }
        })
    }
    
    private func setThumbnailImage(with url: String){
        self.thumbnailImageView.showViewIndicator()
        let urlString = URL(string: url)
        self.thumbnailImageView.kf.setImage(with: urlString){ result in
            switch result {
            case .success(_):
                self.thumbnailImageView.dismissViewndicator()
            case .failure(let error):
                print(error)
                self.thumbnailImageView.dismissViewndicator()
            }
        }
    }
    
}


//MARK: 좋아요와 관련된 프로토콜 정의
protocol LikeDelegate{
    func didLikePressButton(with tableViewIndex: Int, status: String, likeIndex: Int)
}
