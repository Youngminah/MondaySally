//
//  WorkingMemberPreViewCellCollectionViewCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit

class WorkingMemberPreViewCell: UICollectionViewCell {
    @IBOutlet weak var statusView: UIView!
    
    func updateUI(){
        self.statusView.layer.cornerRadius = self.statusView.bounds.width/2
    }
    
}
