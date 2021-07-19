//
//  UICollectionView.swift
//  MondaySally
//
//  Created by meng on 2021/07/20.
//

import  UIKit

extension UICollectionView {
    
    func setEmptyView(message: String) {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        noDataLabel.text = message
        noDataLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        noDataLabel.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        noDataLabel.textAlignment = NSTextAlignment.center
        self.backgroundView = noDataLabel
        
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
