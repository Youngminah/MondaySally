//
//  GiftHistoryCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit
import Kingfisher

class GiftHistoryCell: UICollectionViewCell {
    
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var coverView: UIView!
    
    var status: Bool = false
    
    func updateUI(with data: MyGiftLogInfo){
        self.badgeLabel.layer.cornerRadius = self.badgeLabel.bounds.width/2
        self.updateStampUI(with: data.isAccepted ?? "U")
        self.updateStatus(with: data.isProved)
        self.giftNameLabel.text = data.name
        self.updateThumbnail(imageUrl: data.imgUrl)
    }
    
    func updateThumbnail(imageUrl : String){
        self.showViewIndicator()
        let urlString = URL(string: imageUrl)
        self.imageView.kf.setImage(with: urlString) { result in
            switch result {
            case .success(_):
                self.dismissViewndicator()
            case .failure(let error):
                print(error)
                self.dismissViewndicator()
            }
        }
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
            self.statusLabel.text = "트윙클 대기"
            self.coverView.isHidden = true
        }else {
            self.status = true
            self.statusLabel.text = "트윙클 완료"
            self.coverView.isHidden = false
            self.coverView.backgroundColor = .white
            self.coverView.layer.cornerRadius = 4
            self.coverView.alpha = 0.65
        }
    }
    
}
