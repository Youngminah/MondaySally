//
//  ViewController.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

class IntroViewController: UIViewController {
    
    let viewModel = AutoLoginViewModel(dataService: DataService())
    
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
        self.viewModel.fetchAutoLogin()
        self.viewModel.updateLoadingStatus = {
            let _ = self.viewModel.isLoading ? self.activityIndicatorStart() : self.activityIndicatorStop()
        }
        
        self.viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                print("서버에서 알려준 에러는 -> \(error.localizedDescription)")
            }
            if let message = self.viewModel.failMessage {
                print(message)
            }
        }
        self.viewModel.didFinishFetch = {
            print(self.viewModel.message)
            self.moveToMainTabBar()
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
    

}
