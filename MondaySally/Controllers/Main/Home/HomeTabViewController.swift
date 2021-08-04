//
//  HomeTabViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit
import Kingfisher

class HomeTabViewController: UIViewController {

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var totalCloverLabel: UILabel!
    @IBOutlet weak var currentCloverLabel: UILabel!
    @IBOutlet weak var usedCloverLabel: UILabel!
    @IBOutlet weak var totalCloverButtonView: UIView!
    @IBOutlet weak var usedCloverButtonView: UIView!
    @IBOutlet weak var currentCloverButtonView: UIView!
    @IBOutlet weak var firstRankingLabel: UILabel!
    @IBOutlet weak var secondRankingLabel: UILabel!
    @IBOutlet weak var thirdRankingLabel: UILabel!
    @IBOutlet weak var firstRankingNameLabel: UILabel!
    @IBOutlet weak var secondRankingNameLabel: UILabel!
    @IBOutlet weak var thirdRankingNameLabel: UILabel!
    @IBOutlet weak var firstRankingImageBorderView: UIView!
    @IBOutlet weak var secondRankingImageBorderView: UIView!
    @IBOutlet weak var thridRankingImageBorderView: UIView!
    @IBOutlet weak var firstRankingImageButton: UIButton!
    @IBOutlet weak var secondRankingImageButton: UIButton!
    @IBOutlet weak var thirdRankingImageButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private let viewModel = HomeViewModel(dataService: HomeDataService())
    private var giftHistoryPreViewController: GiftHistoryPreViewController!
    var delegate: GiftPreviewDelegate?
    
    private let boldAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.label,
        .font: UIFont(name: "NotoSansCJKkr-Bold", size: 23) as Any
    ]
    
    private let lightAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.label,
        .font: UIFont(name: "NotoSanskr-Light", size: 21) as Any
    ]
    
    private let mediumAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.label,
        .font: UIFont(name: "NotoSansCJKkr-Medium", size: 21) as Any
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
        self.attemptFetchHome()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if UserDefaults.standard.bool(forKey: "homeRefreshFlag") {
            self.attemptFetchHome()
            UserDefaults.standard.setValue(false, forKey: "homeRefreshFlag")
        }
    }
    
    //MARK: 테이블뷰/컬렉션뷰 위로 스크롤시 리프레시
    @objc private func didPullToRefresh() {
        print("홈뷰 리프레시 시작!!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.attemptFetchHome()
        }
    }
    
    //MARK: 컨테이너 뷰 연결
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "giftHistoryPreviewSegue" {
            let vc = segue.destination as? GiftHistoryPreViewController
            giftHistoryPreViewController = vc
            self.delegate = vc
        }
    }
    
    @IBAction func moveToCloverHistoryView(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CloverHistoryView") as? CloverHistoryViewController else{
            return
        }
        vc.tabTag = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: 네트워킹
extension HomeTabViewController {

    //메인탭바 [홈]화면 API 호출 함수
    private func attemptFetchHome() {
        
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                if strongSelf.scrollView.refreshControl?.isRefreshing == false {
                    let _ = strongSelf.viewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
                }
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
        
        //jwt 토큰에 문제가 있을 경우 로그아웃 시켜야함.
        self.viewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.showSallyNotationAlert(with: "로그아웃합니다."){
                    strongSelf.removeAllUserInfos()
                    guard let vc = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(identifier: "RegisterNavigationView") as? RegisterNavigationViewController else{
                        return
                    }
                    strongSelf.changeRootViewController(vc)
                }
            }
        }

        self.viewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("홈 조회에 성공했습니다 !! ")
                strongSelf.updateAfterAPIUI()
                strongSelf.collectionView.reloadData()
                strongSelf.delegate?.showGiftPreview(with: strongSelf.viewModel.homeInfo?.giftHistory ?? [])
                strongSelf.scrollView.refreshControl?.endRefreshing()
            }
        }
        self.viewModel.fetchHome()
    }
    
    private func updateAfterAPIUI(){
        guard let data = self.viewModel.homeInfo else { return }
        UserDefaults.standard.setValue(data.nickname , forKey: "nickName")
        UserDefaults.standard.setValue(data.companyIdx , forKey: "companyIndex")
        UserDefaults.standard.setValue(data.status , forKey: "workingStatus")
        self.setMainLabel(with :data)
        self.setCompanyLogoImage(with :data)
        self.totalCloverLabel.text = "\(data.accumulatedClover)".insertComma
        self.currentCloverLabel.text = "\(data.currentClover)".insertComma
        self.usedCloverLabel.text = "\(data.usedClover)".insertComma
        if self.viewModel.numOfTwinkleRank == 1 {
            self.setFirstRankingImage(with :data)
            self.firstRankingNameLabel.text = data.twinkleRank?[0].nickname
            self.secondRankingLabel.isHidden = true
            self.thirdRankingLabel.isHidden = true
            self.secondRankingNameLabel.isHidden = true
            self.thirdRankingNameLabel.isHidden = true
            self.secondRankingImageButton.isHidden = true
            self.thirdRankingImageButton.isHidden = true
            self.secondRankingImageBorderView.isHidden = true
            self.thridRankingImageBorderView.isHidden = true
        }
        else if self.viewModel.numOfTwinkleRank == 2 {
            self.setFirstRankingImage(with :data)
            self.setSecondRankingImage(with :data)
            self.firstRankingNameLabel.text = data.twinkleRank?[0].nickname
            self.secondRankingNameLabel.text = data.twinkleRank?[1].nickname
            self.thirdRankingLabel.isHidden = true
            self.thirdRankingNameLabel.isHidden = true
            self.thirdRankingImageButton.isHidden = true
            self.thridRankingImageBorderView.isHidden = true
        } else {
            self.setFirstRankingImage(with :data)
            self.setSecondRankingImage(with :data)
            self.setThirdRankingImage(with :data)
            self.firstRankingNameLabel.text = data.twinkleRank?[0].nickname
            self.secondRankingNameLabel.text = data.twinkleRank?[1].nickname
            self.thirdRankingNameLabel.text = data.twinkleRank?[2].nickname
        }
    }
}


//MARK: 현재 출근 멤버 컬렉션 뷰
extension HomeTabViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = self.viewModel.numOfWorkingMember ?? 0
        if number == 0 {
            self.collectionView.setEmptyView(message: "현재 근무중인 멤버가 없어요")
        }else {
            self.collectionView.restore()
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkingMemberPreViewCell", for: indexPath) as? WorkingMemberPreViewCell else {
            return UICollectionViewCell()
        }
        guard let data = self.viewModel.workingMemberList(at: indexPath.row) else {
            return cell
        }
        cell.updateUI(with :data)
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 28)/3
        let height: CGFloat = collectionView.bounds.width/160 * 16
        return CGSize(width: width, height: height)
    }
}


// MARK: 업데이트 UI
extension HomeTabViewController {
    
    private func updateUI(){
        UserDefaults.standard.setValue(false, forKey: "homeRefreshFlag")
        self.scrollView.refreshControl = UIRefreshControl()
        self.scrollView.refreshControl?.addTarget(self,
                                                      action: #selector(didPullToRefresh),
                                                      for: .valueChanged)
        self.firstRankingImageButton.clipsToBounds = true
        self.secondRankingImageButton.clipsToBounds = true
        self.thirdRankingImageButton.clipsToBounds = true
        self.firstRankingLabel.clipsToBounds = true
        
        
        self.totalCloverButtonView.layer.cornerRadius = 10
        self.usedCloverButtonView.layer.cornerRadius = 10
        self.currentCloverButtonView.layer.cornerRadius = 10
        
        self.firstRankingLabel.layer.cornerRadius = 10
        self.secondRankingLabel.layer.cornerRadius = 10
        self.thirdRankingLabel.layer.cornerRadius = 10
        
        self.secondRankingLabel.layer.borderWidth = 1
        self.thirdRankingLabel.layer.borderWidth = 1
        self.secondRankingLabel.layer.borderColor = #colorLiteral(red: 0.9843137255, green: 0.4590537548, blue: 0.254901737, alpha: 1)
        self.thirdRankingLabel.layer.borderColor = #colorLiteral(red: 0.9843137255, green: 0.4590537548, blue: 0.254901737, alpha: 1)
        
        self.firstRankingImageBorderView.layer.borderWidth = 1
        self.secondRankingImageBorderView.layer.borderWidth = 1
        self.thridRankingImageBorderView.layer.borderWidth = 1
        self.firstRankingImageBorderView.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        self.secondRankingImageBorderView.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        self.thridRankingImageBorderView.layer.borderColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        
        self.firstRankingImageBorderView.layer.cornerRadius = self.firstRankingImageBorderView.bounds.width/2
        self.secondRankingImageBorderView.layer.cornerRadius = self.secondRankingImageBorderView.bounds.width/2
        self.thridRankingImageBorderView.layer.cornerRadius = self.thridRankingImageBorderView.bounds.width/2
        self.firstRankingImageButton.layer.cornerRadius = self.firstRankingImageButton.bounds.width/2
        self.secondRankingImageButton.layer.cornerRadius = self.secondRankingImageButton.bounds.width/2
        self.thirdRankingImageButton.layer.cornerRadius = self.thirdRankingImageButton.bounds.width/2
        self.logoImageView.layer.cornerRadius = self.logoImageView.bounds.width/2
    }
    
    //MARK: 1등 랭킹 프로필화면 셋팅
    private func setFirstRankingImage(with data: HomeInfo){
        guard let data = data.twinkleRank else { return }
        guard let url = data[0].imgUrl else {
            return
        }
        let urlString = URL(string: url)
        self.firstRankingImageButton.kf.setImage(with: urlString, for: .normal)
    }
    
    //MARK: 2등 랭킹 프로필화면 셋팅
    private func setSecondRankingImage(with data: HomeInfo){
        guard let data = data.twinkleRank else { return }
        guard let url = data[1].imgUrl else {
            return
        }
        let urlString = URL(string: url)
        self.secondRankingImageButton.kf.setImage(with: urlString, for: .normal)
    }
    
    //MARK: 3등 랭킹 프로필화면 셋팅
    private func setThirdRankingImage(with data: HomeInfo){
        guard let data = data.twinkleRank else { return }
        guard let url = data[2].imgUrl else {
            return
        }
        let urlString = URL(string: url)
        self.thirdRankingImageButton.kf.setImage(with: urlString, for: .normal)
    }
    
    //MARK: 기업로고 셋팅
    private func setCompanyLogoImage(with data: HomeInfo){
        guard let url = data.logoImgUrl else {
            return
        }
        let urlString = URL(string: url)
        self.logoImageView.kf.setImage(with: urlString)
    }

    //MARK: 메인 라벨 셋팅
    private func setMainLabel(with data: HomeInfo){
        let attributedString = NSMutableAttributedString(string: "")
        attributedString.append(NSAttributedString(string: "\(data.nickname)님", attributes: boldAttributes))
        attributedString.append(NSAttributedString(string: "의\n누적 근무 시간은\n", attributes: lightAttributes))
        attributedString.append(NSAttributedString(string: "총 '\(data.totalWorkTime)시간'", attributes: mediumAttributes))
        attributedString.append(NSAttributedString(string: "입니다.☀️", attributes: lightAttributes))
        self.mainLabel.attributedText = attributedString
    }
}


//MARK: 좋아요와 관련된 프로토콜 정의
protocol GiftPreviewDelegate{
    func showGiftPreview(with data: [MyGiftLogInfo])
}
