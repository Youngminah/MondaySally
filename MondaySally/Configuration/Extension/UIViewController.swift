//
//  UIViewController.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

extension UIViewController {
    
    // MARK: 빈 화면을 눌렀을 때 키보드가 내려가도록 처리
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    // MARK: UIWindow의 rootViewController를 변경하여 화면전환
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    //MARK: 루트 뷰 인트로로 이동
    func changeRootViewToIntro(){
        guard let vc = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(identifier: "IntroView") as? IntroViewController else{
            return
        }
        self.changeRootViewController(vc)
    }
    
    func changeRootViewToMainTabBar(){
        guard let mainTabBarController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainNavigationView") as? MainNavigationViewController else{
            return
        }
        self.changeRootViewController(mainTabBarController)
    }
    
    // MARK: 네트워크 문제시 알림 후 앱 꺼버리기
    func networkFailToExit(){
        self.showSallyNotationAlert(with: "서버와의 연결이 원활하지 않습니다.\n다시 시도해 주세요.") {
            DispatchQueue.main.async {
                exit(0)
            }
        }
    }

    // MARK: 유저 모든 정보 삭제
    func removeAllUserInfos() {
        JwtToken.jwt = ""
        Constant.HEADERS = ["x-access-token" : ""]
        UserDefaults.standard.removeObject(forKey: "JwtToken")
        UserDefaults.standard.removeObject(forKey: "nickName")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "imageUrl")
        UserDefaults.standard.removeObject(forKey: "department")
        UserDefaults.standard.removeObject(forKey: "position")
        UserDefaults.standard.removeObject(forKey: "gender")
        UserDefaults.standard.removeObject(forKey: "account")
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        UserDefaults.standard.removeObject(forKey: "workingPeriod")
        UserDefaults.standard.removeObject(forKey: "company")
    }
}


//MARK: 팝업 관련 기능
extension UIViewController {
    
    // MARK: 인디케이터 표시
    func showIndicator() {
        print("인디케이터 시작")
        IndicatorView.shared.show()
        IndicatorView.shared.showIndicator()
    }
    
    // MARK: 인디케이터 숨김
    @objc func dismissIndicator() {
        print("인디케이터 스탑")
        IndicatorView.shared.dismiss()
    }
    
    // MARK: 커스텀 샐리 알림창 표시
    func showSallyNotationAlert(with title: String , complition: (() -> Void)? = nil) {
        SallyNotificationAlert.shared.showAlert(with: title, message: "")
        SallyNotificationAlert.shared.didDismiss = {
            if complition != nil {
                complition!()
            }
        }
    }
    
    // MARK: 커스텀 샐리 알림창 사라짐
    @objc func dismissAlert() {
        SallyNotificationAlert.shared.dismissAlert()
    }
    
    // MARK: 취소와 확인이 뜨는 UIAlertController
    func presentAlert(title: String, message: String? = nil,
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .alert,
                      handler: ((UIAlertAction) -> Void)? = nil) {
        self.dismissIndicator()
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let actionDone = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(actionDone)
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: 커스텀 UIAction이 뜨는 UIAlertController
    func presentAlert(title: String, message: String? = nil,
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .alert,
                      with actions: UIAlertAction ...) {
        self.dismissIndicator()
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
}
