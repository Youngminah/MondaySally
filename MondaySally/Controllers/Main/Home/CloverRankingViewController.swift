//
//  TwinkleRankingViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit
import Kingfisher

class CloverRankingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstUserNameLabel: UILabel!
    @IBOutlet weak var firstUserCloverLabel: UILabel!
    @IBOutlet weak var firstUserImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    private let viewModel = CloverRankingViewModel(dataService: CloverDataService())
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateMainUI()
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self,
                                                      action: #selector(didPullToRefresh),
                                                      for: .valueChanged)
        self.refreshOfRanking()
    }
    
    @objc private func didPullToRefresh() {
        print("기프트샵 컬렉션뷰 리프레시 시작!!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.refreshOfRanking()
        }
    }
    
    private func updateMainUI(){
        self.firstUserImageView.layer.cornerRadius = self.firstUserImageView.width / 2
        self.dateLabel.text = "\(Date().text) 기준"
    }
    
    private func setProfileImage(with url: String?){
        guard let url = url else { return }
        let urlString = URL(string: url)
        self.firstUserImageView.kf.setImage(with: urlString)
    }
    
    private func refreshOfRanking(){
        self.viewModel.pageIndex = 1
        self.viewModel.endOfPage = false
        self.attemptFetchCloverRanking(with: false)
    }
}

extension CloverRankingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = self.viewModel.numOfCloverRankingList
        if number == 0 {
            self.tableView.setEmptyView(message: "트윙클 랭킹이 아직 없어요.")
        } else {
            self.tableView.restore()
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CloverRankingCell", for: indexPath) as? CloverRankingCell else {
            return UITableViewCell()
        }
        guard let data = self.viewModel.cloverRankingList(at: indexPath.row ) else { return cell }
        cell.updateUI(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.viewModel.numOfCloverRankingList == 0 { return } //맨처음이라면 실행 x
        if self.viewModel.remainderOfCloverRankingPagination != 0 { return }
        if self.viewModel.endOfPage { return }
        let position = scrollView.contentOffset.y
        if position >= (tableView.contentSize.height - scrollView.frame.size.height) {
            guard !self.viewModel.isPagination else { return } // 이미 페이징 중이라면 실행 x
            self.attemptFetchCloverRanking(with: true)
        }
    }
}

// MARK: 클로버 랭킹 조회 API
extension CloverRankingViewController {
    
    private func attemptFetchCloverRanking(with pagination: Bool) {
        
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                if strongSelf.tableView.refreshControl?.isRefreshing == false {
                    let _ = strongSelf.viewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
                }
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
                    strongSelf.tableView.refreshControl?.endRefreshing()
                }
            }
        }
        
//        self.viewModel.codeAlertClosure = { [weak self] () in
//            guard let strongSelf = self else { return }
//            DispatchQueue.main.async {
//                strongSelf.showSallyNotationAlert(with: "로그아웃합니다."){
//                    strongSelf.removeAllUserInfos()
//                    guard let vc = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(identifier: "RegisterNavigationView") as? RegisterNavigationViewController else{
//                        return
//                    }
//                    strongSelf.changeRootViewController(vc)
//                }
//            }
//        }

        self.viewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("클로버 랭킹 조회에 성공했습니다 !! ")
                print("가져온 랭킹 갯수 -> \(strongSelf.viewModel.numOfCloverRankingList) 페이지 넘버 -> \(strongSelf.viewModel.pageIndex)")
                strongSelf.updateFirstRankingUI()
                strongSelf.tableView.reloadData()
                strongSelf.tableView.tableFooterView = nil
                strongSelf.tableView.refreshControl?.endRefreshing()
            }
        }
        self.viewModel.fetchCloverRanking(with: pagination)
    }
    
    private func updateFirstRankingUI(){
        guard let data = self.viewModel.cloverRankingList(at: 0) else {
            return
        }
        self.setProfileImage(with : data.imgUrl)
        self.firstUserNameLabel.text = data.nickname
        self.firstUserCloverLabel.text = "\(data.currentClover)".insertComma
        //self.firstUserImageView.image =
    }
}

// MARK: 페이징중 footer뷰 생성
extension CloverRankingViewController {
    //MARK: 페이징 중에 밑에 footer뷰 생성.
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}
