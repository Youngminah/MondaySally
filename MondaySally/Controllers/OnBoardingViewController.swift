//
//  OnBoardingViewController.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var startButton: UIButton!
    
    let infoViewModel = OnBoardingViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.addContentScrollView()
    }
    
    private func addContentScrollView() {
        
        for i in 0..<infoViewModel.numOfBountyInfoList {
            let uiView = UIView()
            let xPos = self.view.frame.width * CGFloat(i)
            uiView.frame = CGRect(x: xPos, y: 0, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
            
            let imageView = UIImageView()
            //상위뷰에 대한 상대적 위치라서 x는 0 이됨.
            imageView.frame = CGRect(x: self.view.frame.width/6,
                                     y: self.view.frame.height/5,
                                     width: (self.scrollView.bounds.width/3) * 2 ,
                                     height: (self.scrollView.bounds.width/3) * 2 )
            imageView.image = infoViewModel.onBoardingInfo(at: i).image
            
            let titleLabel = UILabel()
            titleLabel.frame = CGRect(x: imageView.frame.origin.x,
                                      y: imageView.bottom + 20,
                                      width: imageView.bounds.width,
                                      height: 27)
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont(name: "NotoSansCJKkr-Medium", size: 18)
            titleLabel.text = infoViewModel.onBoardingInfo(at: i).titleLabel
            
            let contentLabel = UILabel()
            contentLabel.frame = CGRect(x: titleLabel.frame.origin.x,
                                      y: titleLabel.bottom + 20,
                                      width: titleLabel.bounds.width,
                                      height: 52)
            contentLabel.textAlignment = .center
            contentLabel.font = UIFont(name: "NotoSansKR-Thin", size: 15)
            contentLabel.numberOfLines = 2
            contentLabel.text = infoViewModel.onBoardingInfo(at: i).contentLabel
        
            
            uiView.addSubview(imageView)
            uiView.addSubview(titleLabel)
            uiView.addSubview(contentLabel)
            scrollView.addSubview(uiView)
            scrollView.contentSize.width = uiView.frame.width * CGFloat(i+1)
        }
        
    }
    
}

extension OnBoardingViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let value = scrollView.contentOffset.x/scrollView.frame.size.width
//        let currentPageNumber = Int(round(value))
//        print("\(currentPageNumber)")
//        setPageControlSelectedPage(currentPage: currentPageNumber)
//    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let value = targetContentOffset.pointee.x/scrollView.frame.size.width
        let currentPageNumber = Int(value)
        print("\(currentPageNumber)")
        setPageControlSelectedPage(currentPage: currentPageNumber)
        setButtonTitle(currentPage: currentPageNumber)
    }
    
    
    private func setPageControlSelectedPage(currentPage: Int){
        self.pageControl.currentPage = currentPage
    }
    
    private func setButtonTitle(currentPage: Int){
        if currentPage == 2 {
            self.startButton.setTitle("시작하기", for: .normal)
        }
        else {
            self.startButton.setTitle("건너뛰기", for: .normal)
        }
    }
}
