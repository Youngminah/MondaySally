//
//  CloverHistoryViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class CloverHistoryViewController: UIViewController {

    @IBOutlet weak var totalCloverButton: UIButton!
    @IBOutlet weak var usedCloverButton: UIButton!
    @IBOutlet weak var currentButton: UIButton!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    private let viewModel = CloverHistoryViewModel(dataService: CloverDataService())
    private var myClover: [Int] = [0,0,0] // 인덱스 0: 누적클로버, 1: 현재클로버, 2: 사용클로버
    private var totalCloverInfo = [TotalCloverInfo]()
    private var usedCloverInfo = [UsedCloverInfo]()
    var tabTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "클로버 히스토리"
        self.attemptFetchGiftHistory()
    }
    
    @IBAction func topTabBarButtonTap(_ sender: UIButton) {
        if sender.tag == 0 {
            self.totalCloverSelected()
            self.changeViewToTotalCloverView()
        } else if sender.tag == 1{
            self.currentCloverSelected()
            self.changeViewToCurrentCloverView()
        }
        else{
            self.usedCloverSelected()
            self.changeViewToUsedCloverView()
        }
    }
    
    private func initailSetting(){
        if tabTag == 0 {
            self.totalCloverSelected()
            self.changeViewToTotalCloverView()
        }else if tabTag == 1{
            self.currentCloverSelected()
            self.changeViewToCurrentCloverView()
        }else {
            self.usedCloverSelected()
            self.changeViewToUsedCloverView()
        }
    }
    
    //기본 클로버들 모은 리스트 업뎃
    private func myCloverUpdate(){
        guard let data = self.viewModel.cloverHistoryInfo else { return }
        self.myClover = [data.accumulatedClover, data.currentClover,data.usedClover]
    }
}

// MARK: 클로버 히스토리 조회 API
extension CloverHistoryViewController {
    private func attemptFetchGiftHistory() {
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
                    print("서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.viewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        
        self.viewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {

            }
        }

        self.viewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("클로버 히스토리 조회에 성공했습니다 !! ")
                strongSelf.myCloverUpdate()
                strongSelf.totalCloverInfo = strongSelf.viewModel.totalCloverList ?? []
                strongSelf.usedCloverInfo = strongSelf.viewModel.usedCloverList ?? []
                strongSelf.initailSetting()
            }
        }
        self.viewModel.fetchCloverHistory()
    }
}

//MARK: 화면 전환에 관한 함수들
extension CloverHistoryViewController {
    
    //MARK: 언더바 인디케이터 애니메이션 이동
    private func slideViewAnimation(moveX: CGFloat){
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8,initialSpringVelocity: 1, options: .allowUserInteraction,
                       animations: {
                        //변하기 전의 모습으로는 identity로 접근이 가능함.
                        self.animationView.transform = CGAffineTransform(translationX: moveX, y: 0)
                       }, completion: {_ in
                       })
    }
    
    // MARK: Custom TopTabBar 누적클로버 화면전환
    private func changeViewToTotalCloverView(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TotalCloverView") as? TotalCloverViewController else {
            return
        }
        vc.clover = myClover[0]
        vc.totalCloverInfo = self.totalCloverInfo
        for view in self.containerView.subviews{
            view.removeFromSuperview()
        }
        vc.willMove(toParent: self)
        self.containerView.frame = vc.view.bounds
        self.containerView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    // MARK: Custom TopTabBar 현재클로버 화면전환
    private func changeViewToCurrentCloverView(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CurrentCloverView") as? CurrentCloverViewController else {
            return
        }
        vc.clover = myClover[1]
        for view in self.containerView.subviews{
            view.removeFromSuperview()
        }
        vc.willMove(toParent: self)
        self.containerView.frame = vc.view.bounds
        self.containerView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    // MARK: Custom TopTabBar 사용클로버 화면전환
    private func changeViewToUsedCloverView(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "UsedCloverView") as? UsedCloverViewController else {
            return
        }
        vc.clover = myClover[2]
        vc.usedCloverInfo = self.usedCloverInfo
        for view in self.containerView.subviews{
            view.removeFromSuperview()
        }
        vc.willMove(toParent: self)
        self.containerView.frame = vc.view.bounds
        self.containerView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    private func totalCloverSelected(){
        self.totalCloverButton.setTitleColor(#colorLiteral(red: 0.9843137255, green: 0.4590537548, blue: 0.254901737, alpha: 1), for: .normal)
        self.totalCloverButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
        self.usedCloverButton.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        self.currentButton.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        self.usedCloverButton.titleLabel?.font = UIFont(name: "NotoSansKR-Thin", size: 15)
        self.currentButton.titleLabel?.font = UIFont(name: "NotoSansKR-Thin", size: 15)
        self.slideViewAnimation(moveX: 0)
    }
    
    private func currentCloverSelected(){
        self.usedCloverButton.setTitleColor(#colorLiteral(red: 0.9843137255, green: 0.4590537548, blue: 0.254901737, alpha: 1), for: .normal)
        self.usedCloverButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
        self.totalCloverButton.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        self.currentButton.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        self.totalCloverButton.titleLabel?.font = UIFont(name: "NotoSansKR-Thin", size: 15)
        self.currentButton.titleLabel?.font = UIFont(name: "NotoSansKR-Thin", size: 15)
        self.slideViewAnimation(moveX: self.view.frame.width/3)
    }
    
    private func usedCloverSelected(){
        self.currentButton.setTitleColor(#colorLiteral(red: 0.9843137255, green: 0.4590537548, blue: 0.254901737, alpha: 1), for: .normal)
        self.currentButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
        self.totalCloverButton.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        self.usedCloverButton.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        self.totalCloverButton.titleLabel?.font = UIFont(name: "NotoSansKR-Thin", size: 15)
        self.usedCloverButton.titleLabel?.font = UIFont(name: "NotoSansKR-Thin", size: 15)
        self.slideViewAnimation(moveX: self.view.frame.width/3*2)
    }
}



