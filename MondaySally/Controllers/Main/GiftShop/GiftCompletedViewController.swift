//
//  GiftCompletedViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/06.
//

import UIKit

class GiftCompletedViewController: UIViewController {

    var giftInfo : GiftWriteInfo?
    
    @IBOutlet weak var twinkleWriteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "기프트 샵"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "홈으로", style: .plain, target: self, action: #selector(homeButtonPressed))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.label
    }
    
    @objc private func homeButtonPressed(_ sender: Any) {
        self.changeRootViewToMainTabBar()
    }
    
    @IBAction func twinkleWriteButton(_ sender: UIButton) {
        self.showSallyQuestionAlert(with: "트윙클을 지금 작성하시겠습니까?", message: "지금 작성하지 않더라도\n 내트윙클현황에서 작성이 가능합니다.", messageLine: 2) {
            DispatchQueue.main.async { [weak self] in
                guard let strongself = self else { return }
                guard let data = strongself.giftInfo else { return }
                guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TwinkleWriteView") as? TwinkleWriteViewController else{
                    return
                }
                vc.giftIndex = data.idx
                vc.giftName = data.name
                vc.clover = data.clover
                vc.delegate = self
                strongself.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

// MARK: 트윙클 작성 완료시 네트워크 다시 요청
extension GiftCompletedViewController: RefreshDelegate{
    func doRefresh() {
        self.twinkleWriteButton.isEnabled = false
        self.twinkleWriteButton.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        self.twinkleWriteButton.setTitle("트윙클이 작성되었습니다.", for: .normal)
    }
}


struct GiftWriteInfo: Decodable{
    var idx: Int
    var name: String
    var clover: Int
}
