//
//  WorkingMemberPreViewCellCollectionViewCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit

class WorkingMemberPreViewCell: UICollectionViewCell {
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    func updateUI(with data: WorkingMember){
        self.statusView.layer.cornerRadius = self.statusView.bounds.width/2
        self.nickNameLabel.text = "\(data.nickname) / \(data.position)"
    }
}
