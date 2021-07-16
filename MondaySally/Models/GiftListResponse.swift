//
//  GiftListInfo.swift
//  MondaySally
//
//  Created by meng on 2021/07/15.
//



struct GiftListResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: [GiftInfo]?
}

struct GiftInfo: Decodable{
    var idx: Int
    var imgUrl: String
    var name: String
}
