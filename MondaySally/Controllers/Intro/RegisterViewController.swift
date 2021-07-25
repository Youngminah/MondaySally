//
//  RegisterViewController.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    private let teamCodeViewModel = TeamCodeViewModel(dataService: AuthDataService())
    private let myProfileViewModel = MyProfileViewModel(dataService: AuthDataService())
    private let fCMTokenViewModel = FCMDeviceTokenViewModel(dataService: AuthDataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.codeTextField.delegate = self
    }
    
    
    @IBAction func completeButtonTab(_ sender: UIButton) {
        guard let teamCodeId = self.codeTextField.text else { return }
        if teamCodeId.count != 8 {
            self.showSallyNotationAlert(with: "팀코드는 8자리입니다.")
            return
        }
        if !teamCodeId.isValidTeamcode() {
            self.showSallyNotationAlert(with: "팀코드는 숫자또는 알파벳으로 이루어져야합니다.")
            return
        }
        self.attemptFetchTeamCode(withId :teamCodeId)
    }

    private func updateUI(){
        self.completeButton.layer.cornerRadius = 4
        self.codeTextField.layer.cornerRadius = 4
        self.codeTextField.clipsToBounds = true
        self.codeTextField.setLeftPaddingPoints(16)
        self.unselectedTextFieldUI()
        self.disableButtonSetting()
    }
    
    //화면 아무곳 클릭하면 키보드 내려가게 하기.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
    }
    
    //팀 코드가 유효할 경우 조인 페이지로 이동.
    private func moveToTermsOfServiceView(){
        guard let vc = self.storyboard?.instantiateViewController(identifier: "TermsOfServiceView") as? TermsOfServiceViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //팀 코드가 유효하지 않을 경우 실패 페이지로 이동.
    private func moveToFailView(){
        guard let vc = self.storyboard?.instantiateViewController(identifier: "FailView") as? FailViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - Networking
extension RegisterViewController {
    
    //MARK: JWT생성 하는 API 호출 함수
    private func attemptFetchTeamCode(withId teamCodeId: String) {
        //통신동안 인디케이터 표시
        self.teamCodeViewModel.updateLoadingStatus = { [weak self] () in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                let _ = strongSelf.teamCodeViewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }
        //서버와의 통신중 에러가 났을 경우 실행
        self.teamCodeViewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let error = self?.teamCodeViewModel.error {
                    print("서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    self?.networkFailToExit()
                }
                if let message = self?.teamCodeViewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                    self?.moveToFailView()
                }
            }
        }
        //성공적으로 통신 완료 경우 실행
        self.teamCodeViewModel.didFinishFetch = { [weak self] () in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                JwtToken.jwt = strongSelf.teamCodeViewModel.jwtToken
                Constant.HEADERS = ["x-access-token" : JwtToken.jwt]
                print("Jwt 발급에 성공했습니다 -> JWT: \(JwtToken.jwt)")
                print(Constant.HEADERS)
                UserDefaults.standard.setValue(strongSelf.teamCodeViewModel.jwtToken, forKey: "JwtToken")
                strongSelf.attemptFetchFCMTokenSend()
                strongSelf.moveToTermsOfServiceView()
            }
        }
        self.teamCodeViewModel.fetchJwt(with: teamCodeId)
    }
    
    
    //MARK: FCM 디바이스 토큰 서버에 전달 API 함수
    private func attemptFetchFCMTokenSend() {
        
        self.fCMTokenViewModel.updateLoadingStatus = { [weak self] () in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                let _ = strongSelf.fCMTokenViewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }
        
        self.fCMTokenViewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let error = self?.fCMTokenViewModel.error {
                    print("ERROR : 서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    self?.networkFailToExit()
                }
                if let message = self?.fCMTokenViewModel.failMessage {
                    print("ERROR : 서버에서 알려준 에러는 -> \(message)")
                    self?.networkFailToExit()
                }
            }
        }
        
        self.fCMTokenViewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                print("SUCCESS : FCM으로부터 생성된 디바이스 토큰을 서버 전달에 성공했습니다 !! ")
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

//MARK: - 텍스트뷰 관련 코드
extension RegisterViewController : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (codeTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if newText.count > 0 {
            self.enableButtonSetting()
        } else {
            self.disableButtonSetting()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectedTextFieldUI()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.unselectedTextFieldUI()
    }
    
    private func enableButtonSetting(){
        self.completeButton.layer.backgroundColor = #colorLiteral(red: 1, green: 0.4284791946, blue: 0.2459045947, alpha: 1)
        self.completeButton.isEnabled = true
    }
    
    private func disableButtonSetting(){
        self.completeButton.layer.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        self.completeButton.isEnabled = false
    }
    
    private func selectedTextFieldUI(){
        self.codeTextField.layer.borderWidth = 1
        self.codeTextField.layer.borderColor = #colorLiteral(red: 1, green: 0.4705882353, blue: 0.3058823529, alpha: 1)
    }
    
    private func unselectedTextFieldUI(){
        self.codeTextField.layer.borderWidth = 0.5
        self.codeTextField.layer.borderColor = #colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1)
    }
}
