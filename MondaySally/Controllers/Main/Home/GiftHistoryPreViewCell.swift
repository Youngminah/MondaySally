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
    @IBOutlet weak var coverView: UIView!
    
    func updateUI(with data: MyGiftLogInfo){
        //self.historyImageView.image  = data.imgUrl.convertProfileImage
        self.updateAccptedStatus(with: data.isAccepted)
        self.updateStatus(with: data.isProved)
        self.approvementLabel.clipsToBounds = true
        self.approvementLabel.layer.cornerRadius = self.approvementLabel.bounds.width/2
        self.historyImageView.clipsToBounds = true
        self.historyImageView.layer.cornerRadius = 8
        self.updateThumbnail(imageUrl : data.imgUrl)
    }
    
    private func updateThumbnail(imageUrl : String){
        self.historyImageView.showViewIndicator()
        let urlString = URL(string: imageUrl)
        self.historyImageView.kf.setImage(with: urlString) { result in
            switch result {
            case .success(_):
                self.historyImageView.dismissViewndicator()
            case .failure(let error):
                print(error)
                self.historyImageView.dismissViewndicator()
            }
        }
    }
    
    private func updateAccptedStatus(with data: String?) {
        guard let data = data else {
            self.approvementLabel.text = "승인\n보류"
            return
        }
        if data == "Y" {
            self.approvementLabel.text = "승인\n완료"
        }else {
            self.approvementLabel.text = "승인\n거절"
        }
    }
    
    private func updateStatus(with response: String){
        if response == "N" {
            self.coverView.isHidden = true
        }else {
            self.coverView.isHidden = false
            self.coverView.backgroundColor = .white
            self.coverView.alpha = 0.65
        }
    }
}
