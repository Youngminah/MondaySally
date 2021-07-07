//
//  TwinkleFeedCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit

class TwinkleFeedCell: UITableViewCell {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImageButton.layer.cornerRadius = self.profileImageButton.bounds.width/2
        addContentScrollView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func addContentScrollView() {
        //MARK:  이 줄이 없다면 오토레이아웃이 맞지 않는다!
        self.scrollView.frame = self.imageContentView.bounds
        
        for i in 0..<3 {
            let imageView = UIImageView()
            let xPos = self.imageContentView.bounds.width * CGFloat(i)
            print(self.imageContentView.bounds)
            imageView.frame = CGRect(x: xPos, y: 0, width: self.imageContentView.bounds.width, height: self.imageContentView.bounds.height)
            imageView.image = #imageLiteral(resourceName: "dummyImage3")
            scrollView.addSubview(imageView)
            scrollView.contentSize.width = imageView.frame.width * CGFloat(i+1)
        }
    }

}
