//
//  UITableView.swift
//  MondaySally
//
//  Created by meng on 2021/07/21.
//

import UIKit


extension UITableView {
    
    func showTableViewIndicator() {
        let indicator = UIActivityIndicatorView()
        indicator.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        self.addSubview(indicator)
        indicator.startAnimating()
    }
    
    func dismissTableViewIndicator() {
        for view in self.subviews {
            if let indicator = view as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
    
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
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.numberOfRows(inSection:  self.numberOfSections-1) == 0{
                return
            }
            let indexPath = IndexPath(
                row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1,
                section: self.numberOfSections - 1)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }

     func scrollToTop() {
         DispatchQueue.main.async {
             let indexPath = IndexPath(row: 0, section: 0)
            if self.hasRowAtIndexPath(indexPath: indexPath) {
                 self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
         }
     }

     func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
         return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
     }
}
