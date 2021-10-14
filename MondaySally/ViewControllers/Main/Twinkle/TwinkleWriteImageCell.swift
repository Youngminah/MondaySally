//
//  TwinkleWriteImageCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/17.
//

import UIKit

class TwinkleWriteImageCell: UICollectionViewCell {
    
    @IBOutlet weak var addImageView: UIImageView!
    @IBOutlet weak var deleteImageButton: UIButton!
    
    
    func updateUI(with image: UIImage){
        self.addImageView.image = image
        self.deleteImageButton.isHidden = false
    }
    
    func updateDefaultUI(){
        self.addImageView.image = #imageLiteral(resourceName: "buttonPhotoAdd")
        self.deleteImageButton.isHidden = true
    }
}
