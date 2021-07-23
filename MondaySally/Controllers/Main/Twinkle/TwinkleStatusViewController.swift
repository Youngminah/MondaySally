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
        vc.giftIndex = data.idx
        vc.giftName = data.name
        vc.clover = data.usedClover
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 16)/5
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
}

// MARK: 트윙클 미증빙/증빙 조회 API
extension TwinkleStatusViewController {
    
    func attemptFetchProve() {
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
                print("트윙클 미증빙/증빙 조회에 성공했습니다 !! ")
                strongSelf.collectionView.reloadData()
            }
        }
        self.viewModel.fetchTwinkleProve()
    }
}


// MARK: 트윙클 작성 완료시 네트워크 다시 요청
extension TwinkleStatusViewController: TwinkleWriteDelegate{
    func didTwinkleWrite() {
        self.viewModel.fetchTwinkleProve()
    }
}
