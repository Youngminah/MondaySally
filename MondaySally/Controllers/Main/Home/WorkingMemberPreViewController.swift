//
//  WorkingMemberPreViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/04.
//

import UIKit

class WorkingMemberPreViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}


extension WorkingMemberPreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = 50
        if number == 0 {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height))
            noDataLabel.text = "현재 근무중인 멤버가 없어요"
            noDataLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
            noDataLabel.textColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.collectionView.backgroundView = noDataLabel
        }
        return number
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
        let width: CGFloat = (collectionView.bounds.width - 28)/3
        let height: CGFloat = collectionView.bounds.width/160 * 16
        return CGSize(width: width, height: height)
    }
}
