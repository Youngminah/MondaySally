//
//  TwinkleStatusViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit

class TwinkleStatusViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let viewModel = TwinkleProveViewModel(dataService: TwinkleDataService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TwinkleStatusViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = self.viewModel.numOfTwinkleTotal
        if number == 0 {
            self.collectionView.setEmptyView(message: "쓰러갈 내 트윙클 목록이 없어요.")
        } else {
            self.collectionView.restore()
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwinkleStatusCell", for: indexPath) as? TwinkleStatusCell else {
            return UICollectionViewCell()
        }
        guard let data = self.viewModel.twinkleProveList(at: indexPath.row) else {
            return cell
        }
        cell.updateUI(with :data)
        return cell
    }
    
    //MARK: cell 클릭했을때 트윙클 쓰러가기로 이동.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TwinkleWriteView") as? TwinkleWriteViewController else{
            return
        }
        guard let data = self.viewModel.twinkleProveList(at: indexPath.row) else { return }
        if data.isProved == "Y"{
            return
        }else {
            vc.editFlag = false
            vc.giftIndex = data.idx
            vc.giftName = data.name
            vc.clover = data.usedClover
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 16)/5
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
}

//MARK: 페이징 API 호출
extension TwinkleStatusViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.viewModel.numOfTwinkleTotal == 0 { return } //맨처음이라면 실행 x
        if self.viewModel.remainderOfTwinklePagination != 0 { return }
        if self.viewModel.endOfPage { return }
        let position = scrollView.contentOffset.x
        if position >= (collectionView.contentSize.width - scrollView.frame.size.width) {
            guard !self.viewModel.isPagination else { return } // 이미 페이징 중이라면 실행 x
            self.attemptFetchProve(with: true)
        }
    }
    
    //MARK: 페이징 중에 밑에 footer뷰 생성.
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
}

// MARK: 트윙클 미증빙/증빙 조회 API
extension TwinkleStatusViewController {
    
    func attemptFetchProve(with pagination: Bool) {
        self.viewModel.updateLoadingStatus = {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                let _ = strongSelf.viewModel.isLoading ? strongSelf.collectionView.showViewIndicator() : strongSelf.collectionView.dismissViewndicator()
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
                print("트윙클 미증빙/증빙 조회에 성공했습니다 !! ")
                print("가져온 미증빙/증빙 트윙클 갯수 -> \(strongSelf.viewModel.numOfTwinkleTotal) 페이지 넘버 -> \(strongSelf.viewModel.pageIndex)")
                strongSelf.collectionView.reloadData()
            }
        }
        self.viewModel.fetchTwinkleProve(with: pagination)
    }
    
    func refreshCollectionview(){
        self.viewModel.pageIndex = 1
        self.viewModel.endOfPage = false
        self.attemptFetchProve(with: false)
        self.collectionView.scrollToleft()
    }
}


// MARK: 트윙클 작성 완료시 네트워크 다시 요청
extension TwinkleStatusViewController: RefreshDelegate{
    func doRefresh() {
        self.viewModel.pageIndex = 1
        self.viewModel.endOfPage = false
        self.viewModel.fetchTwinkleProve(with: false)
    }
}
