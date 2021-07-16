//
//  GiftShopDetailViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class GiftShopDetailViewController: UIViewController {
    
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var giftContentLabel: UILabel!
    @IBOutlet weak var giftRuleLabel: UILabel!
    
    var input: GiftRequestInput?
    let giftDetailViewModel = GiftDetailViewModel(dataService: GiftDataService())
    let giftRequestViewModel = GiftRequestViewModel(dataService: GiftDataService())
    var giftIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "기프트 샵"
        if giftIndex != -1 {
            self.attemptFetchGiftDetail(with: giftIndex)
        }
    }
    
    @IBAction func giftApplyButton(_ sender: UIButton) {
        input = GiftRequestInput(giftIdx: giftIndex, usedClover: 30)
        guard let input = input else { return }
        attemptFetchGiftRequest(with :input)
    }
    
}


// MARK: 기프트 리스트 조회 API
extension GiftShopDetailViewController {

    private func attemptFetchGiftDetail(with index:Int) {
        self.giftDetailViewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.giftDetailViewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }

        self.giftDetailViewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.giftDetailViewModel.error {
                    print("서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.giftDetailViewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                    strongSelf.dismiss(animated: true)
                }
            }
        }
        
        self.giftDetailViewModel.logOutAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {

            }
        }

        self.giftDetailViewModel.didFinishFetch = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                print("기프트 상세 조회에 성공했습니다 !! ")
                strongSelf.updateGiftDetailUI()
            }
        }

        self.giftDetailViewModel.fetchGiftDetail(with: index)
    }
    
    private func updateGiftDetailUI(){
        guard let data = self.giftDetailViewModel.getGiftInfo else {
            print("디테일 기프트 정보를 뜯지 못했습니다.")
            return
        }
        self.giftNameLabel.text = data.name
        //self.giftContentLabel.text = data.info
        //self.giftRuleLabel.text = data.rule
    }
}


// MARK: 기프트 신청 API
extension GiftShopDetailViewController {
    private func attemptFetchGiftRequest(with input: GiftRequestInput) {
        self.giftRequestViewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.giftRequestViewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }

        self.giftRequestViewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.giftRequestViewModel.error {
                    print("서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.giftRequestViewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        
        self.giftRequestViewModel.logOutAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {

            }
        }

        self.giftRequestViewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("기프트 신청에 성공했습니다 !! ")
                strongSelf.moveToCompletedView()
            }
        }

        self.giftRequestViewModel.fetchGiftRequest(with: input)
    }
    
    private func moveToCompletedView(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GiftCompletedView") as? GiftCompletedViewController else{
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
