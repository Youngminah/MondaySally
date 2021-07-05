//
//  TwinkleRankingViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class TwinkleRankingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension TwinkleRankingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TwinkleRankingCell", for: indexPath) as? TwinkleRankingCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
}
