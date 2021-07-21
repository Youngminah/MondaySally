//
//  TotalCloverCell.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class TotalCloverCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var cloverInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateUI(with data: AccumulateCloverHistoryInfo){
        self.dateLabel.text = data.time
        self.infoLabel.text = "\(data.worktime)시간 근무"
        self.cloverInfoLabel.text = "+\(data.clover) clover"
    }
}
