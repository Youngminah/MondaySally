//
//  TwinkleResponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/19.
//



struct TwinkleResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: [TwinkleInfo]?
}

struct TwinkleInfo: Decodable {
    var imgUrl: String?
    var nickname: String?
    var twinkleImg: String
    var date: String
    var content: String
    var likenum: Int
    var commentnum: Int
}
