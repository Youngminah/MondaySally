//
//  TwinklePostImageCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/06.
//

import UIKit
import Kingfisher

class TwinklePostImageCell: UICollectionViewCell {
    @IBOutlet weak var twinkleImageView: UIImageView!
    
    func updateUI(with data: String){
        self.showViewIndicator()
        let urlString = URL(string: data)
        self.twinkleImageView.kf.setImage(with: urlString) { result in
            switch result {
            case .success( _):
                self.dismissViewndicator()
            case .failure(let error):
                print(error.errorDescription ?? "")
                self.dismissViewndicator()
            }
        }
    }
}
