//
//  GiftHistoryCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class GiftHistoryCell: UICollectionViewCell {
    @IBOutlet weak var badgeLabel: UILabel!
    
    func updateUI(){
        self.badgeLabel.layer.cornerRadius = self.badgeLabel.bounds.width/2
    }
    
}
