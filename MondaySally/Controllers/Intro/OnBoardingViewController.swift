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
        self.startButton.layer.cornerRadius = 4
    }
    
    @IBAction func startButtonTab(_ sender: UIButton) {
        guard let registerVC = self.storyboard?.instantiateViewController(identifier: "RegisterNavigationView") as? RegisterNavigationViewController else{
            return
        }
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = registerVC
            UIView.transition(with: window, duration: 1.0, options: .transitionFlipFromRight, animations: nil)
        } else {
            registerVC.modalPresentationStyle = .overFullScreen
            self.present(registerVC, animated: true, completion: nil)
        }
        
    }
    
    private func addContentScrollView() {
        //MARK:  이 줄이 없다면 오토레이아웃이 맞지 않는다!
        scrollView.frame = view.bounds
        
        for i in 0..<infoViewModel.numOfBountyInfoList {
            let uiView = UIView()
            let xPos = self.view.frame.width * CGFloat(i)
            uiView.frame = CGRect(x: xPos, y: 0, width: self.scrollView.bounds.width, height: self.scrollView.bounds.height)
            
            let imageView = UIImageView()
            //상위뷰에 대한 상대적 위치라서 x는 0 이됨.
            let size = self.view.bounds.width/3
            imageView.frame = CGRect(x: view.bounds.width/2 - size,
                                     y: self.view.bounds.height/5,
                                     width: size * 2 ,
                                     height: size * 2 )
            imageView.image = infoViewModel.onBoardingInfo(at: i).image
            
            let titleLabel = UILabel()
            titleLabel.frame = CGRect(x: imageView.frame.origin.x,
                                      y: imageView.bottom + 20,
                                      width: imageView.bounds.width,
                                      height: 27)
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont(name: "NotoSansCJKkr-Medium", size: 18)
            titleLabel.text = infoViewModel.onBoardingInfo(at: i).titleLabel
            titleLabel.adjustsFontSizeToFitWidth = true
            titleLabel.minimumScaleFactor = 0.2

            let contentLabel = UILabel()
            contentLabel.frame = CGRect(x: titleLabel.frame.origin.x,
                                      y: titleLabel.bottom + 20,
                                      width: titleLabel.bounds.width,
                                      height: 52)
            contentLabel.textAlignment = .center
            contentLabel.font = UIFont(name: "NotoSansKR-Thin", size: 15)
            contentLabel.numberOfLines = 2
            contentLabel.text = infoViewModel.onBoardingInfo(at: i).contentLabel
            contentLabel.textColor = #colorLiteral(red: 0.4823529412, green: 0.4823529412, blue: 0.4823529412, alpha: 1)
            contentLabel.adjustsFontSizeToFitWidth = true
            contentLabel.minimumScaleFactor = 0.2
            
            scrollView.addSubview(uiView)
            uiView.addSubview(imageView)
            uiView.addSubview(titleLabel)
            uiView.addSubview(contentLabel)
            scrollView.contentSize.width = uiView.frame.width * CGFloat(i+1)
        }
    }
}

extension OnBoardingViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let value = targetContentOffset.pointee.x/scrollView.frame.size.width
        let currentPageNumber = Int(value)
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
