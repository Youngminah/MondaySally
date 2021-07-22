//
//  Date.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

extension Date {
    init(year: Int, month: Int, day: Int) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd"
        self = dateFormatter.date(from: "\(year).\(month).\(day)") ?? Date()
    }
    
    var text: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy. MM. dd"
        return dateFormatter.string(from: self)
    }
    
    var detailText: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd hh:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    // MARK: 이미지 파일을 저장할 때 마땅한 이름이 없는 경우 현재 일시를 파일 이름으로 사용하기도 합니다.
    var fileName: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddhhmmssSSS"
        return dateFormatter.string(from: self)
    }
}
