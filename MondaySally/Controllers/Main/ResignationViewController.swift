//
//  ResignationViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class ResignationViewController: UIViewController {
    
    let viewModel = ResignationViewModel(dataService: DataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func resignButtonTap(_ sender: UIButton) {
        self.attemptFetchResignation()
    }
    
}

// MARK: - Networking
extension ResignationViewController {
    
    //유요한 팀코드로 jwt생성 하는 API 호출 함수
    private func attemptFetchResignation() {
        self.viewModel.fetchResignation()
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let _ = strongSelf.viewModel.isLoading ? strongSelf.activityIndicatorStart() : strongSelf.activityIndicatorStop()
            }
        }
        
        self.viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                print("서버에서 알려준 에러는 -> \(error.localizedDescription)")
            }
            if let message = self.viewModel.failMessage {
                print("success값은 false입니다 메세지는 -> \(message)")
            }
        }
        
        self.viewModel.didFinishFetch = {
            print("성공했습니다 !! -> \(self.viewModel.message)")
            //삭제할 값들 추가
            JwtToken.jwt = ""
            UserDefaults.standard.removeObject(forKey: "JwtToken")
            self.moveToIntroView()
        }
    }
    
    // MARK: - 네트워크 통신중 UI표시 Setup
    private func activityIndicatorStart() {
        // Code for show activity indicator view
        self.showIndicator()
        print("인디케이터 시작")
    }
    
    private func activityIndicatorStop() {
        // Code for stop activity indicator view
        self.dismissIndicator()
        print("인디케이터 스탑")
    }
    
    private func moveToIntroView(){
        guard let vc = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(identifier: "IntroView") as? IntroViewController else{
            return
        }
        self.changeRootViewController(vc)
    }
    

}
