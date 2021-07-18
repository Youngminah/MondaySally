//
//  TotalCloverViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class TotalCloverViewController: UIViewController {

    @IBOutlet weak var cloverLabel: UILabel!
    var totalCloverInfo = [TotalCloverInfo]()
    var clover = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI() 
    }

    private func updateUI() {
        self.cloverLabel.text = "\(clover)".insertComma
    }
}

extension TotalCloverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalCloverInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCloverCell", for: indexPath) as? TotalCloverCell else {
            return UITableViewCell()
        }
        cell.updateUI(with: totalCloverInfo[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
}
