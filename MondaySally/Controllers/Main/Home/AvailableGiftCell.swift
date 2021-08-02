//
//  AvailableGiftCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class AvailableGiftCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var giftNameLabel: UILabel!
    
    func updateUI(with data: AvailableGiftInfo){
        self.thumbnailImage.layer.cornerRadius = 4
        self.setThumbnailImage(with: data.imageUrl)
        self.giftNameLabel.text = data.giftName
    }
    
    private func setThumbnailImage(with url: String){
        let urlString = URL(string: url)
        self.thumbnailImage.kf.setImage(with: urlString)
    }
}
