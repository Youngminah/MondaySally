//
//  GiftTabViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class GiftTabViewController: UIViewController {

    let viewModel = GiftListViewModel(dataService: DataService())
    @IBOutlet weak var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attemptFetchGiftList()
    }
    

}

extension GiftTabViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numOfGiftList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCell", for: indexPath) as? GiftCell else {
            return UICollectionViewCell()
        }
        let data = self.viewModel.giftListInfo(at: indexPath.row)
        cell.updateUI(with: data)
        return cell
    }
    
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 16)/2
        let height: CGFloat = width * 224/177
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GiftShopDetailView") as? GiftShopDetailViewController else{
            return
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 헤더뷰 표시
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind { // kind의 종류는 크게 해더와 푸터가 있음
        case UICollectionView.elementKindSectionHeader:
            //해더, footer등등 를 deque할 땐 supplementaryView임.
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "GiftHistoryHeader", for: indexPath) as? GiftHistoryHeader else {
                return UICollectionReusableView()
            }
            header.totalGiftCountLabel.text = "총 \(self.viewModel.numOfGiftList)건"
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
}


// MARK: - Networking
extension GiftTabViewController {

    //내 프로필 조회 API 호출 함수
    private func attemptFetchGiftList() {
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                let _ = strongSelf.viewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
            }
        }

        self.viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let error = self?.viewModel.error {
                    print("서버에서 통신 원활하지 않음 -> \(error.localizedDescription)")
                    self?.networkFailToExit()
                }
                if let message = self?.viewModel.failMessage {
                    print("서버에서 알려준 에러는 -> \(message)")
                }
            }
        }
        
        self.viewModel.logOutAlertClosure = { [weak self] () in
            guard let strongSelf = self else {
                return
            }
            DispatchQueue.main.async {

            }
        }

        self.viewModel.didFinishFetch = { [weak self] () in
            
            DispatchQueue.main.async {
                guard let strongSelf = self else {
                    return
                }
                print("기프트 리스트 조회에 성공했습니다 !! ")
                strongSelf.collectionView.reloadData()
            }
        }

        self.viewModel.fetchGiftList()
    }
    
}
