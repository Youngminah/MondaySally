//
//  TwinkleFeedCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit

class TwinkleFeedCell: UITableViewCell {

    @IBOutlet weak var profileImageButton: UIButton!
    
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
    }
    
    @IBAction func likeButtonTouchUp(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
}
