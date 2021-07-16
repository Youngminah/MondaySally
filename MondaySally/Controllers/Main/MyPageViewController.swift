//
//  MyPageViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var companyInfoLabel: UILabel!
    @IBOutlet weak var positionWorkInfoLabel: UILabel!
    
    let viewModel = MyProfileViewModel(dataService: AuthDataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.updateProfileUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateProfileUI()
    }
    
    private func updateUI(){
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.borderColor = #colorLiteral(red: 0.8980392157, green: 0.8980392157, blue: 0.8980392157, alpha: 1)
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.width/2
    }
    
    private func updateProfileUI(){
        //strongSelf.profileImage.image =
        self.nameLabel.text = UserInfo.nickName
        self.companyInfoLabel.text = "\(UserInfo.company) \(UserInfo.department)"
        self.positionWorkInfoLabel.text = "\(UserInfo.position) | \(UserInfo.workingPeriod )"
        self.emailLabel.text = UserInfo.email
    }
    
}


//// MARK: - Networking
//extension MyPageViewController {
//
//    //내 프로필 조회 API 호출 함수
//    private func attemptFetchMyProfile() {
//
//        self.viewModel.updateLoadingStatus = {
//            DispatchQueue.main.async { [weak self] in
//                guard let strongSelf = self else {
//                    return
//                }
//                let _ = strongSelf.viewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
//            }
//        }
//
//        self.viewModel.showAlertClosure = { [weak self] () in
//            DispatchQueue.main.async {
//                if let error = self?.viewModel.error {
//                    print("서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
//                    self?.networkFailToExit()
//                }
//
//                if let message = self?.viewModel.failMessage {
//                    print("서버에서 알려준 에러는 -> \(message)")
//                }
//            }
//        }
//
//        self.viewModel.didFinishFetch = { [weak self] () in
//            DispatchQueue.main.async {
//                guard let strongSelf = self else {
//                    return
//                }
//                print("프로필 조회에 성공했습니다 !! ")
//                guard let data = strongSelf.viewModel.getMyProfileInfo else {
//                    print("성공했으나 들어온 데이터를 뜯지 못했습니다.")
//                    return
//                }
//                strongSelf.updateProfileUI(with: data)
//            }
//        }
//
//        self.viewModel.fetchMyProfile()
//    }
//}
