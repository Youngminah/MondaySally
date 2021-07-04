//
//  HomeTabViewController.swift
//  MondaySally
//
//  Created by meng on 2021/07/03.
//

import UIKit

class HomeTabViewController: UIViewController {


    @IBOutlet weak var totalCloverButtonView: UIView!
    @IBOutlet weak var usedCloverButtonView: UIView!
    @IBOutlet weak var currentCloverButtonView: UIView!
    @IBOutlet weak var firstRankingLabel: UILabel!
    @IBOutlet weak var secondRankingLabel: UILabel!
    @IBOutlet weak var thirdRankingLabel: UILabel!
    @IBOutlet weak var firstRankingImageBorderView: UIView!
    @IBOutlet weak var secondRankingImageBorderView: UIView!
    @IBOutlet weak var thridRankingImageBorderView: UIView!
    @IBOutlet weak var firstRankingImageButton: UIButton!
    @IBOutlet weak var secondRankingImageButton: UIButton!
    @IBOutlet weak var thirdRankingImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    private func updateUI(){
        self.firstRankingImageButton.clipsToBounds = true
        self.secondRankingImageButton.clipsToBounds = true
        self.thirdRankingImageButton.clipsToBounds = true
        self.firstRankingLabel.clipsToBounds = true
        
        
        self.totalCloverButtonView.layer.cornerRadius = 10
        self.usedCloverButtonView.layer.cornerRadius = 10
        self.currentCloverButtonView.layer.cornerRadius = 10
        
        self.firstRankingLabel.layer.cornerRadius = 14
        self.secondRankingLabel.layer.cornerRadius = 14
        self.thirdRankingLabel.layer.cornerRadius = 14
        
        self.secondRankingLabel.layer.borderWidth = 1
        self.thirdRankingLabel.layer.borderWidth = 1
        self.secondRankingLabel.layer.borderColor = #colorLiteral(red: 0.9843137255, green: 0.4590537548, blue: 0.254901737, alpha: 1)
        self.thirdRankingLabel.layer.borderColor = #colorLiteral(red: 0.9843137255, green: 0.4590537548, blue: 0.254901737, alpha: 1)
        
        self.firstRankingImageBorderView.layer.borderWidth = 1
        self.secondRankingImageBorderView.layer.borderWidth = 1
        self.thridRankingImageBorderView.layer.borderWidth = 1
        self.firstRankingImageBorderView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.secondRankingImageBorderView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.thridRankingImageBorderView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
        self.firstRankingImageBorderView.layer.cornerRadius = self.firstRankingImageBorderView.bounds.width/2
        self.secondRankingImageBorderView.layer.cornerRadius = self.secondRankingImageBorderView.bounds.width/2
        self.thridRankingImageBorderView.layer.cornerRadius = self.thridRankingImageBorderView.bounds.width/2
        self.firstRankingImageButton.layer.cornerRadius = self.firstRankingImageButton.bounds.width/2
        self.secondRankingImageButton.layer.cornerRadius = self.secondRankingImageButton.bounds.width/2
        self.thirdRankingImageButton.layer.cornerRadius = self.thirdRankingImageButton.bounds.width/2
        
    }
    
}
