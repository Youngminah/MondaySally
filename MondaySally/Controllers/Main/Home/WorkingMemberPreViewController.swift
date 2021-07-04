//
//  WorkingMemberPreViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit

class WorkingMemberPreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}


extension WorkingMemberPreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WorkingMemberPreViewCell", for: indexPath) as? WorkingMemberPreViewCell else {
            return UICollectionViewCell()
        }
        cell.updateUI()
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 8)/3
        let height: CGFloat = (collectionView.bounds.height - 32)/4
        return CGSize(width: width, height: height)
    }
}
