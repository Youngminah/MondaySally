//
//  GiftDetailInfo.swift
//  MondaySally
//
//  Created by meng on 2021/07/15.
//

struct GiftDetailResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: GiftDetailInfo
}

struct GiftDetailInfo: Decodable{
    var thumnail: String
    var name: String
    var info: String
    var rule: String
    var option: [OptionInfo]
}

struct OptionInfo: Decodable{
    var usedClover: Int
    var money: Int
}
