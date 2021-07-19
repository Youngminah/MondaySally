//
//  MyPageViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit
import Kingfisher

class MyPageViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var companyInfoLabel: UILabel!
    @IBOutlet weak var positionWorkInfoLabel: UILabel!
    
    private let viewModel = MyProfileViewModel(dataService: AuthDataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.attemptFetchMyProfile()
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
        self.nameLabel.text = UserDefaults.standard.string(forKey: "nickName")
        self.companyInfoLabel.text = (UserDefaults.standard.string(forKey: "company") ?? "미정")  + " | " +  (UserDefaults.standard.string(forKey: "department") ?? "미정")
        self.positionWorkInfoLabel.text = (UserDefaults.standard.string(forKey: "position") ?? "미정")  + " | " +  "\((UserDefaults.standard.integer(forKey: "workingPeriod") ))"
        self.emailLabel.text = UserDefaults.standard.string(forKey: "email")
        self.updateProfileImage()
    }
    
    //MARK: Kingfisher로 프로필 이미지 가져오고 , 예외 처리
    private func updateProfileImage(){
        guard let urlImage = UserDefaults.standard.string(forKey: "imageUrl") else {
            return
        }
        let url = URL(string: urlImage)
        self.profileImage.kf.setImage(with: url) { [weak self] result in
            guard let strongself = self else { return }
            switch result {
            case .success(let value):
                print("프로필 이미지를 성공적으로 가져옴!!: \(value.source.url?.absoluteString ?? "")")
            case .failure( _):
                print("프로필 이미지 URL의 이미지를 가져올 수 없음!!")
                strongself.profileImage.image = #imageLiteral(resourceName: "illustSallyBlank")
            }
        }
    }
    
}


// MARK: - Networking
extension MyPageViewController {

    //MARK: 내 프로필 조회 API 호출 함수
    private func attemptFetchMyProfile() {
        
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.viewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }
        
        self.viewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = self?.viewModel.error {
                    print("ERROR : 서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = self?.viewModel.failMessage {
                    print("ERROR : 서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        
        self.viewModel.didFinishFetch = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                print("SUCCESS : 프로필 조회에 성공했습니다 !! ")
                guard let data = strongSelf.viewModel.getMyProfileInfo else {
                    print("ERROR : 성공했으나 들어온 데이터를 뜯지 못했습니다.")
                    return
                }
                strongSelf.saveUserInfo(with: data)
                strongSelf.updateProfileUI()
            }
        }
        self.viewModel.fetchMyProfile()
    }
    
    
    private func saveUserInfo(with data: MyProfileInfo){
        UserDefaults.standard.setValue(data.nickname, forKey: "nickName")
        UserDefaults.standard.setValue(data.email, forKey: "email")
        UserDefaults.standard.setValue(data.imgUrl, forKey: "imageUrl")
        UserDefaults.standard.setValue(data.department, forKey: "department")
        UserDefaults.standard.setValue(data.position, forKey: "position")
        UserDefaults.standard.setValue(data.gender, forKey: "gender")
        UserDefaults.standard.setValue(data.bankAccount, forKey: "account")
        UserDefaults.standard.setValue(data.phoneNumber, forKey: "phoneNumber")
        UserDefaults.standard.setValue("\(data.workingYear ?? 0)", forKey: "workingPeriod")
        UserDefaults.standard.setValue(data.companyName, forKey: "company")
    }
}
