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
    
    private let viewModel = GiftHistoryViewModel(dataService: GiftDataService())
    
    override func viewDidLoad() {
        self.navigationItem.backButtonTitle = " "
        super.viewDidLoad()
        self.attemptFetchGiftHistory(with: false)
    }
    
}

// MARK: 트윙클 작성 완료시 네트워크 다시 요청
extension GiftHistoryViewController: RefreshDelegate{
    func doRefresh() {
        self.viewModel.pageIndex = 1
        self.attemptFetchGiftHistory(with: false)
    }
}


extension GiftHistoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GiftHistoryCell", for: indexPath) as? GiftHistoryCell else {
            return UICollectionViewCell()
        }
        if indexPath.item == self.viewModel.numOfGiftLogInfo {
            self.viewModel.isPagination ? cell.contentView.showViewIndicator() : cell.contentView.dismissViewndicator()
        }
        guard let data = viewModel.myGiftLogInfo(at: indexPath.item) else { return cell }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let data = self.viewModel.myGiftLogInfo(at: indexPath.item) else { return }
        if data.isProved == "Y" {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TwinklePostView") as? TwinklePostViewController else{
                return
            }
            guard let twinkleIndex = data.twinkleIdx else { return }
            vc.index = twinkleIndex
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TwinkleWriteView") as? TwinkleWriteViewController else{
                return
            }
            vc.giftIndex = data.giftLogIdx
            vc.giftName = data.name
            vc.clover = data.usedClover
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: 기프트 히스토리 조회 페이징 적용
extension GiftHistoryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.viewModel.numOfGiftLogInfo == 0 { return } //맨처음이라면 실행 x
        if self.viewModel.remainderOfGiftPagination != 0 { return }
        let position = scrollView.contentOffset.y
        if position >= (collectionView.contentSize.height - 10 - scrollView.frame.size.height) {
            guard !self.viewModel.isPagination else { return } // 이미 페이징 중이라면 실행 x
            self.attemptFetchGiftHistory(with: true)
        }
    }
}

// MARK: 기프트 히스토리 조회 API
extension GiftHistoryViewController {
    
    private func attemptFetchGiftHistory(with pagination: Bool) {
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
                print("기프트 히스토리 조회에 성공했습니다 !! ")
                if !pagination {
                    strongSelf.updateAPIUI()
                }
                print("총 기프트 히스토리 갯수 -> \(strongSelf.viewModel.numOfGiftLogInfo) 페이지 넘버 -> \(strongSelf.viewModel.pageIndex)")
                strongSelf.collectionView.reloadData()
            }
        }
        self.viewModel.fetchMyGiftLog(with: pagination)
    }
    
    private func updateAPIUI(){
        self.totalHistoryLabel.text = "총 \(viewModel.numOfTotalGiftLogInfo)건의 기프트"
    }
}
