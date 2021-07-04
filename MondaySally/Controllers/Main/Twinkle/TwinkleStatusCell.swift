//
//  TwinkleStatusCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit

class TwinkleStatusCell: UICollectionViewCell {
    @IBOutlet weak var statusBorderView: UIView!
    @IBOutlet weak var statueImageButton: UIButton!
    
    func updateUI(){
        self.statusBorderView.layer.borderWidth = 1
        self.statusBorderView.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
        self.statusBorderView.layer.cornerRadius = self.statusBorderView.bounds.width/2
        self.statueImageButton.layer.cornerRadius = self.statueImageButton.bounds.width/2
    }
    
}