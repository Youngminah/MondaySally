//
//  TwinkleProveResponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/19.
//


struct TwinkleProveResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: TwinkleIsProveInfo?
}



struct TwinkleIsProveInfo: Decodable {
    var notProvedList: [TwinkleProveInfo]?
    var provedList: [TwinkleProveInfo]?
}

struct TwinkleProveInfo: Decodable {
    var idx: Int
    var imgUrl: String
    var name: String
    var isProved: String
    var usedClover: Int
}

