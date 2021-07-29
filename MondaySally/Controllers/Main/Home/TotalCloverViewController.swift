//
//  TotalCloverViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class TotalCloverViewController: UIViewController {

    @IBOutlet weak var cloverLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    private let viewModel = CloverAccumulateViewModel(dataService: CloverDataService())
    private var nickName = UserDefaults.standard.string(forKey: "nickName")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self,
                                                      action: #selector(didPullToRefresh),
                                                      for: .valueChanged)
        self.refreshOfAccumulated()
    }
    
    @objc private func didPullToRefresh() {
        print("기프트샵 컬렉션뷰 리프레시 시작!!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.refreshOfAccumulated()
        }
    }

    private func updateUI() {
        self.infoLabel.text = (nickName ?? "") + "님의 누적 클로버"
        self.dateLabel.text = "\(Date().text) 기준"
        self.cloverLabel.text = "\(self.viewModel.accumulateClover)".insertComma
    }
    
    private func refreshOfAccumulated(){
        self.viewModel.pageIndex = 1
        self.viewModel.endOfPage = false
        self.attemptFetchCloverAccumulate(with: false)
    }
}

extension TotalCloverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = self.viewModel.numOfTotalClover
        if number == 0 {
            self.tableView.setEmptyView(message: "클로버 히스토리가 없어요.")
        } else {
            self.tableView.restore()
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TotalCloverCell", for: indexPath) as? TotalCloverCell else {
            return UITableViewCell()
        }
        guard let data = self.viewModel.accumulateCloverList(at: indexPath.row) else {
            return cell
        }
        cell.updateUI(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.viewModel.numOfTotalClover == 0 { return } //맨처음이라면 실행 x
        if self.viewModel.remainderOfCloverAccumulatePagination != 0 { return }
        if self.viewModel.endOfPage { return }
        let position = scrollView.contentOffset.y
        if position >= (tableView.contentSize.height - scrollView.frame.size.height) {
            guard !self.viewModel.isPagination else { return } // 이미 페이징 중이라면 실행 x
            self.attemptFetchCloverAccumulate(with: true)
        }
    }
}


// MARK: 클로버 히스토리 조회 API
extension TotalCloverViewController {
    private func attemptFetchCloverAccumulate(with pagination: Bool) {
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
                print("누적 클로버 히스토리 조회에 성공했습니다 !! ")
                print("가져온 누적 클로버 갯수 -> \(strongSelf.viewModel.numOfTotalClover) 페이지 넘버 -> \(strongSelf.viewModel.pageIndex)")
                strongSelf.updateUI()
                strongSelf.tableView.reloadData()
                strongSelf.tableView.tableFooterView = nil
                strongSelf.tableView.refreshControl?.endRefreshing()
            }
        }
        self.viewModel.fetchCloverAccumulate(with: pagination)
    }
}

// MARK: 페이징중 footer뷰 생성
extension TotalCloverViewController {
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
