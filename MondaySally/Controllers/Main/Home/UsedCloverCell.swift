//
//  UsedCloverCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class UsedCloverCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cloverInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUI(with data: UsedCloverInfo){
        self.dateLabel.text = data.time
        self.titleLabel.text = data.name
        self.cloverInfoLabel.text = "-\(data.clover) clover"
    }
}
