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
        self.refreshOfCurrent()
    }
    
    @IBAction func showDetailButtonTap(_ sender: UIButton) {
        
    }
    
    private func updateUI() {
        self.infoLabel.text = (nickName ?? "") + "님의 현재 클로버"
        self.dateLabel.text = "\(Date().text) 기준"
        self.cloverLabel.text = "\(self.viewModel.currentClover)".insertComma
    }
    
    private func refreshOfCurrent(){
        self.viewModel.pageIndex = 1
        self.viewModel.endOfPage = false
        self.attemptFetchCloverCurrent(with: false)
    }
}

extension CurrentCloverViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = self.viewModel.numOfAvailableGift
        if number == 0 {
            self.collectionView.setEmptyView(message: "현재 클로버로 이용 가능한 기프트가 없어요")
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GiftShopDetailView") as? GiftShopDetailViewController else{
            return
        }
        guard let data = self.viewModel.availableGiftList(at: indexPath.item) else {
            return
        }
        vc.giftIndex = data.index
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 34) / 2.7
        let height: CGFloat = width / 127 * 160
        return CGSize(width: width, height: height)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.viewModel.numOfAvailableGift == 0 { return } //맨처음이라면 실행 x
        if self.viewModel.remainderOfCloverCurrentPagination != 0 { return }
        if self.viewModel.endOfPage { return }
        let position = scrollView.contentOffset.y
        if position >= (collectionView.contentSize.height - scrollView.frame.size.height) {
            guard !self.viewModel.isPagination else { return } // 이미 페이징 중이라면 실행 x
            self.attemptFetchCloverCurrent(with: true)
        }
    }
}


// MARK: 클로버 히스토리 조회 API
extension CurrentCloverViewController {
    private func attemptFetchCloverCurrent(with pagination: Bool) {
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.viewModel.isLoading ? strongSelf.collectionView.showCollectionViewIndicator(): strongSelf.collectionView.dismissCollectionViewIndicator()
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
        
//        self.viewModel.codeAlertClosure = { [weak self] () in
//            guard let strongSelf = self else { return }
//            DispatchQueue.main.async {
//
//            }
//        }

        self.viewModel.didFinishFetch = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                print("현재 클로버 히스토리 조회에 성공했습니다 !! ")
                print("가져온 현재 클로버 갯수 -> \(strongSelf.viewModel.numOfAvailableGift) 페이지 넘버 -> \(strongSelf.viewModel.pageIndex)")
                strongSelf.updateUI()
                strongSelf.collectionView.reloadData()
            }
        }
        self.viewModel.fetchCloverCurrent(with: pagination)
    }
}



