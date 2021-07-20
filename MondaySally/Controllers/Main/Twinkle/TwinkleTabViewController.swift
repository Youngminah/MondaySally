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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attemptFetchTwinkleTotal()
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
                print("기프트 신청에 성공했습니다 !! ")
                strongSelf.tableView.reloadData()
            }
        }
        self.viewModel.fetchTwinkleTotal()
    }
}


// MARK: 트윙클 리스트 네크워크로부터 UI 업데이트
extension TwinkleTabViewController {
    
}
