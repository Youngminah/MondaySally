//
//  TwinkleRankingCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class CloverRankingCell: UITableViewCell {

    @IBOutlet weak var rankingNumberLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cloverLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(with data: CloverRankingInfo){
        self.rankingNumberLabel.text = "\(data.ranking)등"
        self.userNameLabel.text = data.nickname
        self.cloverLabel.text = "\(data.currentClover) clover"
        //self.userImageView.image = 
        //self.rankingNumberLabel.text = "\(data.ranking)등"
    }
}
