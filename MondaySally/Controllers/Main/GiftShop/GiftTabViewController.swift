//
//  GiftTabViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class GiftTabViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    private let viewModel = GiftListViewModel(dataService: GiftDataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.attemptFetchGiftList()
        self.collectionView.refreshControl = UIRefreshControl()
        self.collectionView.refreshControl?.addTarget(self,
                                                      action: #selector(didPullToRefresh),
                                                      for: .valueChanged)
    }
    
    //MARK: 테이블뷰/컬렉션뷰 위로 스크롤시 리프레시
    @objc private func didPullToRefresh() {
        print("기프트샵 컬렉션뷰 리프레시 시작!!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.attemptFetchGiftList()
        }
    }
    

}

extension GiftTabViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numOfGiftList ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftCell", for: indexPath) as? GiftCell else {
            return UICollectionViewCell()
        }
        guard let data = self.viewModel.giftListInfo(at: indexPath.item) else {
            return cell
        }
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
        guard let data = self.viewModel.giftListInfo(at: indexPath.item) else {
            return
        }
        vc.giftIndex = data.idx
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
            header.totalGiftCountLabel.text = "총 \(self.viewModel.numOfGiftList ?? 0)건"
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
}


// MARK: - Networking
extension GiftTabViewController {

    //메인탭바 [기프트샵]화면 API 호출 함수
    private func attemptFetchGiftList() {
        if collectionView.refreshControl?.isRefreshing == false {
            self.viewModel.updateLoadingStatus = {
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else {
                        return
                    }
                    let _ = strongSelf.viewModel.isLoading ? strongSelf.showIndicator() : strongSelf.dismissIndicator()
                }
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
        
        //jwt 토큰에 문제가 있을 경우 로그아웃 시켜야함.
        self.viewModel.codeAlertClosure = { [weak self] () in
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
                strongSelf.collectionView.refreshControl?.endRefreshing()
            }
        }
        
        self.viewModel.fetchGiftList()
    }
    
}
