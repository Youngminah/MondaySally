//
//  GiftRequestResponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/16.
//

struct GiftRequestResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: GiftProveInfo?
}

struct GiftProveInfo: Decodable{
    var idx: Int
    var name: String
    var clover: Int
}
