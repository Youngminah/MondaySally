//
//  UsedCloverViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class UsedCloverViewController: UIViewController {
    
    @IBOutlet weak var cloverLabel: UILabel!
    var usedCloverInfo = [UsedCloverInfo]()
    var clover = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI() 
    }
    
    private func updateUI() {
        self.cloverLabel.text = "\(clover)".insertComma
    }
}


extension UsedCloverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usedCloverInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UsedCloverCell", for: indexPath) as? UsedCloverCell else {
            return UITableViewCell()
        }
        cell.updateUI(with: usedCloverInfo[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
}
