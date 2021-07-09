//
//  MyProfileInfo.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//

struct MyProfileResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: MyProfileInfo
}

struct MyProfileInfo: Decodable{
    var nickname: String
    var email: String?
    var imgUrl: String?
    var department: String?
    var position: String?
    var gender: String?
    var bankAccount: String?
    var phoneNumber: String?
    var workingYear: Int?
    var companyName: String
}
