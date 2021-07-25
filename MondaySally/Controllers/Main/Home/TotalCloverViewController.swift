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
        self.attemptFetchCloverAccumulate()
    }

    private func updateUI() {
        self.infoLabel.text = (nickName ?? "") + "님의 누적 클로버"
        self.dateLabel.text = "\(Date().text) 기준"
        self.cloverLabel.text = "\(self.viewModel.accumulateClover)".insertComma
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
}


// MARK: 클로버 히스토리 조회 API
extension TotalCloverViewController {
    private func attemptFetchCloverAccumulate() {
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
                print("누적 클로버 히스토리 조회에 성공했습니다 !! ")
                strongSelf.updateUI()
                strongSelf.tableView.reloadData()
            }
        }
        self.viewModel.fetchCloverAccumulate()
    }
}
