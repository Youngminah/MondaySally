//
//  ViewController.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

class IntroViewController: UIViewController {
    
    private let viewModel = AutoLoginViewModel(dataService: AuthDataService())
    private let fCMTokenViewModel = FCMDeviceTokenViewModel(dataService: AuthDataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkAutoLogin()
    }
    
    @IBAction func directStartButtonTap(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(identifier: "OnBoardingViewController") as? OnBoardingViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //JWT있는지 확인
    private func checkAutoLogin(){
        print("기계에 저장된 JWT토큰 값 \(JwtToken.jwt)")
        if JwtToken.jwt == "" { return } //토큰이 없으면 화면 그대로
        self.attemptFetchAutoLogin() //토큰이 있으면 자동로그인 API 호출
    }
}


// MARK: - Networking
extension IntroViewController {
    
    //MARK: 자동로그인 API 호출 함수
    private func attemptFetchAutoLogin() {
        
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
                    print("ERROR: 서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                
                if let message = self?.viewModel.failMessage {
                    print("ERROR: 서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        
        self.viewModel.didFinishFetch = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                print("SUCCESS: 자동 로그인에 성공했습니다 !! -> 서버에서 보내준 메세지: \(strongSelf.viewModel.message)")
                strongSelf.attemptFetchFCMTokenSend()
                strongSelf.changeRootViewToMainTabBar()
            }
        }
        self.viewModel.fetchAutoLogin()
    }
    
    //MARK: FCM 디바이스 토큰 서버에 전달 API 함수
    private func attemptFetchFCMTokenSend() {
        self.fCMTokenViewModel.updateLoadingStatus = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                let _ = strongSelf.fCMTokenViewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }
        
        self.fCMTokenViewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = self?.fCMTokenViewModel.error {
                    print("ERROR : 서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.fCMTokenViewModel.failMessage {
                    print("ERROR : 서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        
        self.fCMTokenViewModel.didFinishFetch = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                print("SUCCESS : FCM으로부터 생성된 디바이스 토큰을 서버 전달에 성공했습니다 !! ")
                //strongSelf.moveToMainTabBar()
            }
        }
        
        guard let token = UserDefaults.standard.string(forKey: "FCMToken") else {
            print("ERROR : FCM 디바이스 토큰이 없음 !!")
            self.networkFailToExit()
            return
        }
        self.fCMTokenViewModel.fetchFCMDeivceToken(with: token)
    }
}
