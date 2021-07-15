//
//  MyGiftLogInfo.swift
//  MondaySally
//
//  Created by meng on 2021/07/16.
//

struct MyGiftLogResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: [MyGiftLogInfo]?
}

struct MyGiftLogInfo: Decodable{
    var imgUrl: Int
    var isAccepted: String
    var isProved: String
    var name: String
    var usedClover: Int
    var money: Int
}
