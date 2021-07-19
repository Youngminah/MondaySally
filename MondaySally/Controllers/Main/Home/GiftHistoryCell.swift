//
//  GiftHistoryCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class GiftHistoryCell: UICollectionViewCell {
    
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coverView: UIView!
    
    var status: Bool = false
    
    func updateUI(with data: MyGiftLogInfo?){
        self.badgeLabel.layer.cornerRadius = self.badgeLabel.bounds.width/2
        guard let data = data else { return }
        self.updateStampUI(with: data.isAccepted ?? "U")
        self.updateStatus(with: data.isProved)
        self.giftNameLabel.text = data.name
    }
    
    private func updateStampUI(with response: String){
        if response == "N" {
            self.badgeLabel.text = "승인\n" + "거절"
        }else if response == "U"{
            self.badgeLabel.text = "승인\n" + "보류"
        }else {
            self.badgeLabel.text = "승인\n" + "완료"
        }
    }
    
    private func updateStatus(with response: String){
        if response == "N" {
            self.status = false
            self.statusLabel.text = "증빙대기"
        }else {
            self.status = true
            self.statusLabel.text = "증빙완료"
        }
        
        if status {
            self.coverView.backgroundColor = .white
            self.coverView.layer.cornerRadius = 4
            self.coverView.alpha = 0.65
        }
    }
    
}
