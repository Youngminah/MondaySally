//
//  MyGiftLogInfo.swift
//  MondaySally
//
//  Created by meng on 2021/07/16.
//

struct GiftHistoryResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: [MyGiftLogInfo]?
}

struct MyGiftLogInfo: Decodable{
    var imgUrl: String
    var isAccepted: String?
    var isProved: String
    var name: String
    var usedClover: Int
    var money: Int
}
