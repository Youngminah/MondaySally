//
//  AvailableGiftViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class AvailableGiftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}


extension AvailableGiftViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailableGiftCell", for: indexPath) as? AvailableGiftCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 18)/2.5
        let height: CGFloat = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
}
