//
//  GiftShopDetailViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class GiftShopDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "기프트 샵"

    }
    
    @IBAction func giftApplyButton(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GiftCompletedView") as? GiftCompletedViewController else{
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
