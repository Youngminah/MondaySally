//
//  TwinkleTabViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class TwinkleTabViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TwinkleTabViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TwinkleFeedCell", for: indexPath) as? TwinkleFeedCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = self.view.bounds.width + 180
        return size
    }
    
    
}
