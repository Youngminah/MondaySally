//
//  MyPageTableViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/22.
//

import UIKit
import Kingfisher

class MyPageTableViewController: UITableViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
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
        guard let data = viewModel.getMyProfileInfo else {
            return
        }
        self.nickNameLabel.text = data.nickname
        self.companyInfoLabel.text = (data.companyName)  + " | " +  (data.department ?? "개발부서")
        self.positionWorkInfoLabel.text = (data.position ?? "미정")  + " | " +  "\(data.workingYear ?? 0)"
        self.emailLabel.text = data.email
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
extension MyPageTableViewController  {
    
    //테이블 뷰 헤더 섹션의 높이 설정
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10.0
    }

    //테이블 뷰 해더 섹션 폰트, 폰트크기 정하기
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = #colorLiteral(red: 0.9635811237, green: 0.9635811237, blue: 0.9635811237, alpha: 1)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{ //로그아웃 버튼
            self.removeAllUserInfos()
            guard let vc = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(identifier: "RegisterNavigationView") as? RegisterNavigationViewController else{
                return
            }
            self.changeRootViewController(vc)
        }
    }
}


// MARK: - Networking
extension MyPageTableViewController {

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
        UserDefaults.standard.setValue(data.email, forKey: "email")
        UserDefaults.standard.setValue(data.imgUrl, forKey: "imageUrl")
        UserDefaults.standard.setValue(data.bankAccount, forKey: "account")
        UserDefaults.standard.setValue(data.phoneNumber, forKey: "phoneNumber")
    }
}
