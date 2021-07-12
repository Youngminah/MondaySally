//
//  CloverHistoryViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/05.
//

import UIKit

class CloverHistoryViewController: UIViewController {

    @IBOutlet weak var totalCloverButton: UIButton!
    @IBOutlet weak var usedCloverButton: UIButton!
    @IBOutlet weak var currentButton: UIButton!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var containerView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.totalCloverButton.setTitleColor(#colorLiteral(red: 0.9843137255, green: 0.4590537548, blue: 0.254901737, alpha: 1), for: .normal)
        self.totalCloverButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
        self.changeViewToTotalCloverView()
    }
    
    @IBAction func topTabBarButtonTap(_ sender: UIButton) {
        if sender.tag == 0 {
            self.totalCloverSelected()
            self.changeViewToTotalCloverView()
        } else if sender.tag == 1{
            self.usedCloverSelected()
            self.changeViewToUsedCloverView()
        }
        else{
            self.currentCloverSelected()
            self.changeViewToCurrentCloverView()
        }
    }
    
    private func slideViewAnimation(moveX: CGFloat){
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8,initialSpringVelocity: 1, options: .allowUserInteraction,
                       animations: {
                        //변하기 전의 모습으로는 identity로 접근이 가능함.
                        self.animationView.transform = CGAffineTransform(translationX: moveX, y: 0)
                       }, completion: {_ in
                       })
    }
    
    // MARK: Custom TopTabBar 누적클로버 화면전환
    private func changeViewToTotalCloverView(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TotalCloverView") as? TotalCloverViewController else {
            return
        }
        for view in self.containerView.subviews{
            view.removeFromSuperview()
        }
        vc.willMove(toParent: self)
        self.containerView.frame = vc.view.bounds
        self.containerView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    // MARK: Custom TopTabBar 사용클로버 화면전환
    private func changeViewToUsedCloverView(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "UsedCloverView") as? UsedCloverViewController else {
            return
        }
        for view in self.containerView.subviews{
            view.removeFromSuperview()
        }
        vc.willMove(toParent: self)
        self.containerView.frame = vc.view.bounds
        self.containerView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    // MARK: Custom TopTabBar 현재클로버 화면전환
    private func changeViewToCurrentCloverView(){
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CurrentCloverView") as? CurrentCloverViewController else {
            return
        }
        for view in self.containerView.subviews{
            view.removeFromSuperview()
        }
        vc.willMove(toParent: self)
        self.containerView.frame = vc.view.bounds
        self.containerView.addSubview(vc.view)
        self.addChild(vc)
        vc.didMove(toParent: self)
    }
    
    private func totalCloverSelected(){
        self.totalCloverButton.setTitleColor(#colorLiteral(red: 0.9843137255, green: 0.4590537548, blue: 0.254901737, alpha: 1), for: .normal)
        self.totalCloverButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
        self.usedCloverButton.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        self.currentButton.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        self.usedCloverButton.titleLabel?.font = UIFont(name: "NotoSansKR-Thin", size: 15)
        self.currentButton.titleLabel?.font = UIFont(name: "NotoSansKR-Thin", size: 15)
        self.slideViewAnimation(moveX: 0)
    }
    
    private func usedCloverSelected(){
        self.usedCloverButton.setTitleColor(#colorLiteral(red: 0.9843137255, green: 0.4590537548, blue: 0.254901737, alpha: 1), for: .normal)
        self.usedCloverButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
        self.totalCloverButton.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        self.currentButton.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        self.totalCloverButton.titleLabel?.font = UIFont(name: "NotoSansKR-Thin", size: 15)
        self.currentButton.titleLabel?.font = UIFont(name: "NotoSansKR-Thin", size: 15)
        self.slideViewAnimation(moveX: self.view.frame.width/3)
    }
    
    private func currentCloverSelected(){
        self.currentButton.setTitleColor(#colorLiteral(red: 0.9843137255, green: 0.4590537548, blue: 0.254901737, alpha: 1), for: .normal)
        self.currentButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 15)
        self.totalCloverButton.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        self.usedCloverButton.setTitleColor(#colorLiteral(red: 0.6862745098, green: 0.6862745098, blue: 0.6862745098, alpha: 1), for: .normal)
        self.totalCloverButton.titleLabel?.font = UIFont(name: "NotoSansKR-Thin", size: 15)
        self.usedCloverButton.titleLabel?.font = UIFont(name: "NotoSansKR-Thin", size: 15)
        self.slideViewAnimation(moveX: self.view.frame.width/3*2)
    }
    
}
