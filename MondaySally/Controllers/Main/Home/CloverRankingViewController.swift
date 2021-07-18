//
//  TwinkleRankingViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class CloverRankingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstUserNameLabel: UILabel!
    @IBOutlet weak var firstUserCloverLabel: UILabel!
    @IBOutlet weak var firstUserImageView: UIImageView!
    
    private let viewModel = CloverRankingViewModel(dataService: CloverDataService())
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attemptFetchCloverRanking()
    }
}

extension CloverRankingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.viewModel.numOfCloverRankingList else { return 0 }
        var num = 0
        if count != 0 {
            num = count - 1
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CloverRankingCell", for: indexPath) as? CloverRankingCell else {
            return UITableViewCell()
        }
        guard let data = self.viewModel.cloverRankingList(at: indexPath.row + 1) else { return cell }
        cell.updateUI(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 71
    }
}

// MARK: 클로버 랭킹 조회 API
extension CloverRankingViewController {
    
    private func attemptFetchCloverRanking() {
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
                print("클로버 랭킹 조회에 성공했습니다 !! ")
                strongSelf.updateFirstRankingUI()
                strongSelf.tableView.reloadData()
            }
        }
        self.viewModel.fetchCloverRanking()
    }
    
    private func updateFirstRankingUI(){
        guard let data = self.viewModel.cloverRankingList(at: 0) else {
            return
        }
        self.firstUserNameLabel.text = data.nickname
        self.firstUserCloverLabel.text = "\(data.currentClover)".insertComma
        //self.firstUserImageView.image =
    }
}
