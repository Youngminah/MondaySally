//
//  ViewController.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

class IntroViewController: UIViewController {
    
    let viewModel = AutoLoginViewModel(dataService: AuthDataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("토큰 현재 값 \(JwtToken.jwt)")
        if JwtToken.jwt == "" {
            return
        }
        self.attemptFetchAutoLogin()
    }
    
    @IBAction func directStartButtonTap(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "OnBoardingViewController") as? OnBoardingViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    private func moveToMainTabBar(){
        guard let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainNavigationView") as? MainNavigationViewController else{
            return
        }
        self.changeRootViewController(mainTabBarController)
    }

}


// MARK: - Networking
extension IntroViewController {
    
    //유요한 팀코드로 jwt생성 하는 API 호출 함수
    private func attemptFetchAutoLogin() {
        
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
        self.viewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                print("자동 로그인에 성공했습니다 !! -> 서버에서 보내준 메세지: \(strongSelf.viewModel.message)")
                strongSelf.moveToMainTabBar()
            }
        }
        self.viewModel.fetchAutoLogin()
    }
    

}
