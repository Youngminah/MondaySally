//
//  GiftHistoryViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class GiftHistoryViewController: UIViewController {

    @IBOutlet weak var totalHistoryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = GiftHistoryViewModel(dataService: DataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attemptFetchGiftHistory()
    }

}

extension GiftHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfGiftLogInfo
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftHistoryCell", for: indexPath) as? GiftHistoryCell else {
            return UICollectionViewCell()
        }
        let data = viewModel.myGiftLogInfo(at: indexPath.item)
        cell.updateUI(with : data)
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 16)/2
        let height: CGFloat = width / 163 * 229
        return CGSize(width: width, height: height)
    }
    
    
    // 헤더뷰 어떻게 표시할까?
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind { // kind의 종류는 크게 해더와 푸터가 있음
        case UICollectionView.elementKindSectionHeader:
            //해더, footer등등 를 deque할 땐 supplementaryView임.
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GiftHistoryHeader", for: indexPath) as? GiftHistoryHeader else {
                return UICollectionReusableView()
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

// MARK: 기프트 히스토리 조회 API
extension GiftHistoryViewController {
    
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
        
        self.viewModel.logOutAlertClosure = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {

            }
        }

        self.viewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("기프트 히스토리 조회에 성공했습니다 !! ")
                strongSelf.updateAPIUI()
                strongSelf.collectionView.reloadData()
            }
        }

        self.viewModel.fetchMyGiftLog()
    }
    
    private func updateAPIUI(){
        self.totalHistoryLabel.text = "총 \(viewModel.numOfGiftLogInfo)건의 기프트"
    }
}
