//
//  TwinkleRankingCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit
import Kingfisher

class CloverRankingCell: UITableViewCell {

    @IBOutlet weak var rankingNumberLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cloverLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImageView.layer.cornerRadius = self.userImageView.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(with data: CloverRankingInfo){
        self.rankingNumberLabel.text = "\(data.ranking)등"
        self.userNameLabel.text = data.nickname
        self.cloverLabel.text = "\(data.currentClover) clover"
        self.setProfileImage(with: data.imgUrl)
    }
    
    private func setProfileImage(with url: String?){
        guard let url = url else {
            self.userImageView.image = #imageLiteral(resourceName: "illustSallyBlank")
            return
        }
        if url == "" {
            self.userImageView.image = #imageLiteral(resourceName: "illustSallyBlank")
            return
        }
        self.userImageView.showViewIndicator()
        let urlString = URL(string: url)
        self.userImageView.kf.setImage(with: urlString){ result in
            switch result {
            case .success(_):
                self.userImageView.dismissViewndicator()
            case .failure(let error):
                print(error)
                self.userImageView.dismissViewndicator()
            }
        }
    }
}
