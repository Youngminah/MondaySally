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
    
    func scrollToleft() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
           if self.hasRowAtIndexPath(indexPath: indexPath) {
            self.scrollToItem(at: indexPath, at: .left, animated: true)
           }
        }
    }
    
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.item < self.numberOfItems(inSection: indexPath.section)
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
