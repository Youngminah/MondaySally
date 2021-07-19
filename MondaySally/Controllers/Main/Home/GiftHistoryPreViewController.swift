//
//  GiftHistoryPreViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit

class GiftHistoryPreViewController: UIViewController {


    @IBOutlet weak var collectionView: UICollectionView!
    
    private let viewModel = GiftHistoryViewModel(dataService: GiftDataService())
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension GiftHistoryPreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = self.viewModel.numOfGiftLogInfo
        if number == 0 {
            self.collectionView.setEmptyView(message: "아직 사용하신 히스토리가 없어요")
        } else {
            self.collectionView.restore()
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftHistoryPreViewCell", for: indexPath) as? GiftHistoryPreViewCell else {
            return UICollectionViewCell()
        }
        guard let data = self.viewModel.myGiftLogInfo(at: indexPath.row) else {
            return cell
        }
        cell.updateUI(with : data)
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 18)/2.7
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
    
}


// MARK: 기프트 히스토리 조회 API
extension GiftHistoryPreViewController {
    
    func attemptFetchGiftHistory() {
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
                print("기프트 미리보기 히스토리 조회에 성공했습니다 !! ")
                strongSelf.collectionView.reloadData()
            }
        }

        self.viewModel.fetchMyGiftLog()
    }
}
