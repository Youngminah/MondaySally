//
//  TwinkleStatusCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit
import Kingfisher

class TwinkleStatusCell: UICollectionViewCell {
    @IBOutlet weak var statusBorderView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var starryBorderView: UIImageView!
    
    func updateUI(with data: TwinkleProveInfo){
        self.statusImageView.layer.cornerRadius = self.statusImageView.bounds.width/2
        if data.isProved == "Y" {
            self.statusBorderView.layer.borderWidth = 1
            self.statusBorderView.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
            self.starryBorderView.isHidden = true
            self.statusBorderView.layer.cornerRadius = self.statusBorderView.bounds.width/2
        }else{
            self.starryBorderView.isHidden = false
            self.statusBorderView.layer.borderWidth = 1.5
            self.statusBorderView.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
            self.statusBorderView.layer.cornerRadius = self.statusBorderView.bounds.width/2
        }
        self.setGiftImage(with: data.imgUrl)
    }
    
    private func setGiftImage(with url: String){
        let urlString = URL(string: url)
        self.statusImageView.kf.setImage(with: urlString)
    }
}
