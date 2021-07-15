//
//  GiftCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit

class GiftCell: UICollectionViewCell {
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var giftNameLabel: UILabel!
    
    func updateUI(with giftInfo: GiftInfo){
        //MARK: 이미지값 넣어야됨.
        self.giftNameLabel.text = giftInfo.name
    }
    
}
