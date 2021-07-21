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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.attemptFetchTwinkleTotal()
    }
    
    //MARK: 컨테이너 뷰 연결
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "twinkleProveSegue" {
            let vc = segue.destination as? TwinkleStatusViewController
            twinkleStatusViewController = vc
            twinkleStatusViewController.attemptFetchProve()
        }
    }
}

extension TwinkleTabViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        guard let data = self.viewModel.twinkleList(at: indexPath.row)?.index else {
            return
        }
        vc.index = data
        self.navigationController?.pushViewController(vc, animated: true)
    }
}



// MARK: 트윙클 리스트 조회 API
extension TwinkleTabViewController {
    
    private func attemptFetchTwinkleTotal() {
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
                    print("서버에서 통신 원활하지 않음 ->  +\(error.localizedDescription)")
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
                //Code
                if strongSelf.viewModel.failCode == 353 {

                }
            }
        }
        self.viewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("트윙클 전체 조회에 성공했습니다 !! ")
                strongSelf.tableView.reloadData()
            }
        }
        self.viewModel.fetchTwinkleTotal()
    }
}


// MARK: 트윙클 좋아요 API
extension TwinkleTabViewController {
    
    private func attemptFetchTwinkleLike(with index :Int) {
        self.likeViewModel.didFinishFetch = { () in
            DispatchQueue.main.async {
                print("좋아요 요청에 성공했습니다 !! ")
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
    
}
