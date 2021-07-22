//
//  ResignationViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class ResignationViewController: UIViewController {
    
    private let viewModel = ResignationViewModel(dataService: AuthDataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func resignButtonTap(_ sender: UIButton) {
        self.showSallyNotationAlert(with: "정말로 퇴사하시겠습니까?", message: "퇴사 신청 철회는 불가능합니다.")
        //self.attemptFetchResignation()
    }
    
}

// MARK: - Networking
extension ResignationViewController {
    
    //유요한 팀코드로 jwt생성 하는 API 호출 함수
    private func attemptFetchResignation() {
        
        self.viewModel.updateLoadingStatus = { [weak self] () in
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
                    print("서버와 통신이 원활하지 않습니다 -> \(error.localizedDescription)")
                    self?.networkFailToExit()
                }
                if let message = self?.viewModel.failMessage {
                    print("통신은 되었으나 false 서버에서 알려준 에러는-> \(message)")
                }
            }
        }
        
        self.viewModel.didFinishFetch = { [weak self] () in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                print("퇴사에 성공했습니다 !! -> \(strongSelf.viewModel.message)")
                //삭제할 값들 추가
                strongSelf.removeAllUserInfos()
                strongSelf.changeRootViewToIntro()
            }
        }
        
        self.viewModel.fetchResignation()
    }
}
