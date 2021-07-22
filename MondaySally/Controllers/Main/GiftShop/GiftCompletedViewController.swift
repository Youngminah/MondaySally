//
//  GiftCompletedViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/06.
//

import UIKit

class GiftCompletedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "기프트 샵"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "홈으로", style: .plain, target: self, action: #selector(homeButtonPressed))
    }
    
    
    @objc private func homeButtonPressed(_ sender: Any) {
        self.changeRootViewToMainTabBar()
    }
    
    @IBAction func twinkleWriteButton(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TwinkleWriteView") as? TwinkleWriteViewController else{
            return
        }
//        vc.giftIndex = data.idx
//        vc.giftName = data.name
//        vc.clover = data.usedClover
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
