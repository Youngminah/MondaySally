//
//  GiftHistoryPreViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit

class GiftHistoryPreViewController: UIViewController {


    @IBOutlet weak var collectionView: UICollectionView!
    
    private var giftHistoryPreviewList = [MyGiftLogInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension GiftHistoryPreViewController: GiftPreviewDelegate{
    func showGiftPreview(with data: [MyGiftLogInfo]) {
        self.giftHistoryPreviewList = data
        self.collectionView.reloadData()
    }
}

extension GiftHistoryPreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = self.giftHistoryPreviewList.count
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
        cell.updateUI(with : giftHistoryPreviewList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.giftHistoryPreviewList[indexPath.row]
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
            //vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 18)/2.7
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
    
}



