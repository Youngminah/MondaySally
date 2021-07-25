//
//  TwinkleTabViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class TwinkleTabViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = TwinkleViewModel(dataService: TwinkleDataService())
    private let likeViewModel = TwinkleLikeViewModel(dataService: TwinkleDataService())
    
    private var twinkleStatusViewController: TwinkleStatusViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self,
                                                      action: #selector(didPullToRefresh),
                                                      for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.refreshOfTwinkleTotal()
    }
    
    @objc private func didPullToRefresh() {
        print("기프트샵 컬렉션뷰 리프레시 시작!!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.refreshOfTwinkleTotal()
            self.twinkleStatusViewController.refreshCollectionview()
        }
    }
    
    //MARK: 컨테이너 뷰 연결
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "twinkleProveSegue" {
            let vc = segue.destination as? TwinkleStatusViewController
            twinkleStatusViewController = vc
            twinkleStatusViewController.attemptFetchProve(with: false)
        }
    }
    
    private func refreshOfTwinkleTotal(){
        self.viewModel.pageIndex = 1
        self.viewModel.endOfPage = false
        self.attemptFetchTwinkleTotal(with: false)
    }
}

extension TwinkleTabViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let number = self.viewModel.numOfTwinkle
        if number == 0 {
            self.tableView.setEmptyView(message: "아직 등록된 트윙클이 없어요.")
        } else {
            self.tableView.restore()
        }
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TwinkleTotalCell", for: indexPath) as? TwinkleTotalCell else {
            return UITableViewCell()
        }
        guard let data = self.viewModel.twinkleList(at: indexPath.row) else {
            return cell
        }
        cell.tableViewIndex = indexPath.row
        cell.delegate = self
        cell.updateUI(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = self.view.bounds.width + 190
        return size
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TwinklePostView") as? TwinklePostViewController else{
            return
        }
        guard let data = self.viewModel.twinkleList(at: indexPath.row) else {
            return
        }
        vc.tableViewIndex = indexPath.row
        vc.index = data.index
        vc.likeDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.viewModel.numOfTwinkle == 0 { return } //맨처음이라면 실행 x
        if self.viewModel.remainderOfTwinklePagination != 0 { return }
        if self.viewModel.endOfPage { return }
        let position = scrollView.contentOffset.y
        if position >= (tableView.contentSize.height - scrollView.frame.size.height) {
            guard !self.viewModel.isPagination else { return } // 이미 페이징 중이라면 실행 x
            self.tableView.tableFooterView = createSpinnerFooter()
            self.attemptFetchTwinkleTotal(with: true)
        }
    }
}



// MARK: 트윙클 리스트 조회 API
extension TwinkleTabViewController {
    private func attemptFetchTwinkleTotal(with pagination: Bool) {
        if tableView.refreshControl?.isRefreshing == false {
            self.viewModel.updateLoadingStatus = {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    let _ = strongSelf.viewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
                }
            }
        }
        self.viewModel.showAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                if let error = strongSelf.viewModel.error {
                    print("서버에서 통신 원활하지 않음 ->  +\(error.localizedDescription)")
                    strongSelf.networkFailToExit()
                }
                if let message = strongSelf.viewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                    strongSelf.tableView.tableFooterView = nil
                }
            }
        }
        self.viewModel.codeAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                //Code
                if strongSelf.viewModel.failCode == 353 {

                }
            }
        }
        self.viewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("트윙클 전체 조회에 성공했습니다 !! ")
                print("가져온 전체 트윙클 갯수 -> \(strongSelf.viewModel.numOfTwinkle)")
                strongSelf.tableView.reloadData()
                strongSelf.tableView.tableFooterView = nil
                strongSelf.tableView.refreshControl?.endRefreshing()
            }
        }
        self.viewModel.fetchTwinkleTotal(with: pagination)
    }
}


// MARK: 트윙클 좋아요 API
extension TwinkleTabViewController {
    
    private func attemptFetchTwinkleLike(with index :Int) {
        self.likeViewModel.didFinishFetch = { () in
            DispatchQueue.main.async {
                print("좋아요/좋아요취소 요청에 성공했습니다 !! ")
            }
        }
        self.likeViewModel.fetchTwinkleLike(with: index)
    }
}

// MARK: 트윙클 좋아요 셸과 통신 프로토콜
extension TwinkleTabViewController: LikeDelegate {
    func didLikePressButton(with tableViewIndex: Int, status: String, likeIndex: Int) {
        self.attemptFetchTwinkleLike(with: likeIndex)
        self.viewModel.setLike(at: tableViewIndex, status: status)
        self.tableView.reloadData()
    }
}

// MARK: 트윙클 리스트 네크워크로부터 UI 업데이트
extension TwinkleTabViewController {
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
