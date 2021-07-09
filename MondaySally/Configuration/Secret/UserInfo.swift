//
//  UserInfo.swift
//  MondaySally
//
//  Created by meng on 2021/07/09.
//

import Foundation


struct UserInfo {
    static var nickName: String = UserDefaults.standard.string(forKey: "nickName") ?? ""
    static var imageUrl: String = UserDefaults.standard.string(forKey: "imageUrl") ?? ""
    static var email: String = UserDefaults.standard.string(forKey: "email") ?? ""
    static var department: String = UserDefaults.standard.string(forKey: "department") ?? "부서 없음"
    static var position: String = UserDefaults.standard.string(forKey: "position") ?? "직급 없음"
    static var gender: String = UserDefaults.standard.string(forKey: "gender") ?? ""
    static var account: String = UserDefaults.standard.string(forKey: "account") ?? ""
    static var phoneNumber: String = UserDefaults.standard.string(forKey: "phoneNumber") ?? ""
    static var workingPeriod: String = UserDefaults.standard.string(forKey: "workingPeriod") ?? ""
    static var company: String = UserDefaults.standard.string(forKey: "company") ?? ""
}
