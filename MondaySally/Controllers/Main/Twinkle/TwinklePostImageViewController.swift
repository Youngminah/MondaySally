//
//  TwinklePostImageViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/06.
//

import UIKit

class TwinklePostImageViewController: UIViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var imageList =  [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pageControl.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
    }
}

extension TwinklePostImageViewController: TwinkleImagePreviewDelegate{
    func showImage(with data: [String]) {
        self.imageList = data
        if imageList.count == 1{
            self.pageControl.isHidden = true
        }else {
            self.pageControl.numberOfPages = imageList.count
        }
        self.collectionView.reloadData()
    }

}


extension TwinklePostImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let number = self.imageList.count
        if number == 0 {
            self.collectionView.setEmptyView(message: "등록한 트윙클이 없어요")
        } else {
            self.collectionView.restore()
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TwinklePostImageCell", for: indexPath) as? TwinklePostImageCell else {
            return UICollectionViewCell()
        }
        cell.updateUI(with: imageList[indexPath.item])
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    // MARK: UICollectionViewDelegate에 있는 메소드
    // 사용자가 직접 광고 CollectionView를 스크롤할 경우를 대비한 메소드
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / self.view.frame.width)
        self.pageControl.currentPage = page
    }
}

