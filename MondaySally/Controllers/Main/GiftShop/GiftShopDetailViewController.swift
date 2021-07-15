//
//  GiftShopDetailViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class GiftShopDetailViewController: UIViewController {
    
    let viewModel = GiftDetailViewModel(dataService: DataService())
    var giftIndex: Int = -1
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var giftContentLabel: UILabel!
    @IBOutlet weak var giftRuleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "기프트 샵"
        if giftIndex != -1 {
            self.attemptFetchGiftList(with: giftIndex)
        }
    }
    
    @IBAction func giftApplyButton(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GiftCompletedView") as? GiftCompletedViewController else{
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
// MARK: - Networking
extension GiftShopDetailViewController {

    //내 프로필 조회 API 호출 함수
    private func attemptFetchGiftList(with index:Int) {
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let _ = strongSelf.viewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }

        self.viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let error = self?.viewModel.error {
                    print("서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    self?.networkFailToExit()
                }
                if let message = self?.viewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        
        self.viewModel.logOutAlertClosure = { [weak self] () in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {

            }
        }

        self.viewModel.didFinishFetch = { [weak self] () in
            
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                print("기프트 상세 조회에 성공했습니다 !! ")
                strongSelf.updateGiftDetailUI()
            }
        }

        self.viewModel.fetchGiftDetail(with: index)
    }
    
    private func updateGiftDetailUI(){
        guard let data = self.viewModel.getGiftInfo else {
            print("디테일 기프트 정보를 뜯지 못했습니다.")
            return
        }
        self.giftNameLabel.text = data.name
    }
    
}
