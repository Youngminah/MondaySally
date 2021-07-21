//
//  CurrentCloverViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class CurrentCloverViewController: UIViewController {

    @IBOutlet weak var cloverLabel: UILabel!
    
    private let viewModel = CloverCurrentViewModel(dataService: CloverDataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attemptFetchCloverCurrent()
    }
    
    private func updateUI() {
        self.cloverLabel.text = "\(self.viewModel.currentClover)".insertComma
    }
}


// MARK: 클로버 히스토리 조회 API
extension CurrentCloverViewController {
    private func attemptFetchCloverCurrent() {
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.viewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }

        self.viewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.viewModel.error {
                    print("서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.viewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        
        self.viewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {

            }
        }

        self.viewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("현재 클로버 히스토리 조회에 성공했습니다 !! ")
                strongSelf.updateUI()
            }
        }
        self.viewModel.fetchCloverCurrent()
    }
}
