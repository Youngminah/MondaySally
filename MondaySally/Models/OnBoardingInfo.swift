//
//  OnBoardingInfo.swift
//  MondaySally
//
//  Created by meng on 2021/07/01.
//

import UIKit

struct OnBoardingInfo{
    let titleLabel: String
    let contentLabel: String
    let imageName: String
    var image: UIImage? {
        return UIImage(named: "\(imageName).jpg")
    }
    
    init(imageName: String, title: String, content: String){
        self.imageName = imageName
        self.titleLabel = title
        self.contentLabel = content
    }
}
