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
    let viewModel = TeamCodeViewModel(dataService: DataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.codeTextField.delegate = self
    }
    
    
    @IBAction func completeButtonTab(_ sender: UIButton) {
        guard let teamCodeId = self.codeTextField.text else {
            print("텍스트 필드에 유저가 입력한 값이 없어서 API 호출 함수가 실행되지 않습니다.")
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
    private func moveToJoinView(){
        guard let vc = self.storyboard?.instantiateViewController(identifier: "JoinView") as? JoinViewController else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //팀 코드가 유요하지 않을 경우 실패 페이지로 이동.
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
    
    //유요한 팀코드로 jwt생성 하는 API 호출 함수
    private func attemptFetchTeamCode(withId teamCodeId: String) {
        
        self.viewModel.updateLoadingStatus = { [weak self] () in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
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
                    self?.moveToFailView()
                }
            }
        }
        
        self.viewModel.didFinishFetch = { [weak self] () in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {
                JwtToken.jwt = strongSelf.viewModel.jwtToken
                print("Jwt 성공적으로 저장완료! JWT: \(JwtToken.jwt)")
                print(Constant.HEADERS)
                UserDefaults.standard.setValue(strongSelf.viewModel.jwtToken, forKey: "JwtToken")
                //UserDefaults.standard.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
                //UserDefaults.standard.removeObject(forKey: "JwtToken")
                strongSelf.moveToJoinView()
            }
        }
        
        self.viewModel.fetchJwt(with: teamCodeId)
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
