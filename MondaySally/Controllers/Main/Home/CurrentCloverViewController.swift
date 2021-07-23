//
//  CurrentCloverViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class CurrentCloverViewController: UIViewController {

    @IBOutlet weak var cloverLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    private let viewModel = CloverCurrentViewModel(dataService: CloverDataService())
    private var nickName = UserDefaults.standard.string(forKey: "nickName")
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attemptFetchCloverCurrent()
    }
    
    @IBAction func showDetailButtonTap(_ sender: UIButton) {
        self.tabBarController?.selectedViewController = self.tabBarController?.children[0]
    }
    
    private func updateUI() {
        self.infoLabel.text = (nickName ?? "") + "님의 현재 클로버"
        self.dateLabel.text = "\(Date().text) 기준"
        self.cloverLabel.text = "\(self.viewModel.currentClover)".insertComma
    }
}

extension CurrentCloverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = self.viewModel.numOfAvailableGift
        if number == 0 {
            self.collectionView.setEmptyView(message: "현재 클로버로 이용 가능한 기프트가 없어요.")
        } else {
            self.collectionView.restore()
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableGiftCell", for: indexPath) as? AvailableGiftCell else {
            return UICollectionViewCell()
        }
        guard let data = self.viewModel.availableGiftList(at: indexPath.item) else {
            return cell
        }
        cell.updateUI(with :data)
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 18)/2.5
        let height: CGFloat = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
}


// MARK: 클로버 히스토리 조회 API
extension CurrentCloverViewController {
    private func attemptFetchCloverCurrent() {
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
                print("현재 클로버 히스토리 조회에 성공했습니다 !! ")
                strongSelf.updateUI()
                strongSelf.collectionView.reloadData()
            }
        }
        self.viewModel.fetchCloverCurrent()
    }
}
