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
    
    var images = [ #imageLiteral(resourceName: "illustTimePoint"), #imageLiteral(resourceName: "illustGift"), #imageLiteral(resourceName: "illustTwinkleChicken") ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.addContentScrollView()
    }
    
    private func setPageControlSelectedPage(currentPage: Int){
        self.pageControl.currentPage = currentPage
        if self.pageControl.currentPage == 2 {
            self.startButton.titleLabel?.text = "시작하기"
        }
    }
    
    private func addContentScrollView() {
        
        for i in 0..<3 {
            let uiView = UIView()
            let xPos = self.view.frame.width * CGFloat(i)
            uiView.frame = CGRect(x: xPos, y: 0, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
            
            let imageView = UIImageView()
            //상위뷰에 대한 상대적 위치라서 x는 0 이됨.
            imageView.frame = CGRect(x: self.view.frame.width/6,
                                     y: self.view.frame.height/5,
                                     width: (self.scrollView.bounds.width/3) * 2 ,
                                     height: (self.scrollView.bounds.width/3) * 2 )
            imageView.image = images[i]
            uiView.addSubview(imageView)
            
            let titleLabel = UILabel()
            titleLabel.frame = CGRect(x: imageView.frame.origin.x,
                                      y: imageView.bottom + 20,
                                      width: imageView.bounds.width,
                                      height: 27)
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont(name: "NotoSansCJKkr-Medium", size: 18)
            titleLabel.text = "출퇴근 시간에 따른 포인트"
            
            let textLabel = UILabel()
            textLabel.frame = CGRect(x: titleLabel.frame.origin.x,
                                      y: titleLabel.bottom + 20,
                                      width: titleLabel.bounds.width,
                                      height: 52)
            textLabel.textAlignment = .center
            textLabel.font = UIFont(name: "NotoSansKR-Thin", size: 15)
            textLabel.numberOfLines = 2
            textLabel.text = """
출퇴근 시 QR 코드 인증을 통해
근무시간을 포인트화 해보세요.
"""
        
            
            uiView.addSubview(titleLabel)
            uiView.addSubview(textLabel)
            scrollView.addSubview(uiView)
            scrollView.contentSize.width = uiView.frame.width * CGFloat(i+1)
        }
        
    }
    
}

extension OnBoardingViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/scrollView.frame.size.width
        let currentPageNumber = Int(round(value))
        print("\(currentPageNumber)")
        setPageControlSelectedPage(currentPage: currentPageNumber)
    }
    
}
