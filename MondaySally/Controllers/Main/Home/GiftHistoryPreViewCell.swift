//
//  GiftHistoryPreViewCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit

class GiftHistoryPreViewCell: UICollectionViewCell {
    
    @IBOutlet weak var approvementLabel: UILabel!
    @IBOutlet weak var historyImageView: UIImageView!
    
    func updateUI(){
        self.approvementLabel.clipsToBounds = true
        self.approvementLabel.layer.cornerRadius = self.approvementLabel.bounds.width/2
        self.historyImageView.clipsToBounds = true
        self.historyImageView.layer.cornerRadius = 8
    }
    
}
