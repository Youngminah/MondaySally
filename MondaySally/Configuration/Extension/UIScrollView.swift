//
//  UIScrollView.swift
//  MondaySally
//
//  Created by meng on 2021/07/21.
//
import UIKit

extension UIScrollView {

    // Bonus: Scroll to top
    func scrollViewToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
    }

    // Bonus: Scroll to bottom
    func scrollViewToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > -1) {
            setContentOffset(bottomOffset, animated: true)
        }
    }

}
