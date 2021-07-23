//
//  CloverUsedResponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/21.
//

struct CloverUsedResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: UsedCloverInfo?
}

struct UsedCloverInfo: Decodable{
    var cloverTotal: Int
    var cloverHistoryList: [UsedCloverHistoryInfo]?
    
    enum CodingKeys:  String, CodingKey {
        case cloverTotal = "usedClover"
        case cloverHistoryList = "clovers"
    }
}

struct UsedCloverHistoryInfo: Decodable{
    var index: Int
    var time: String
    var giftName: String
    var clover: Int
    
    enum CodingKeys:  String, CodingKey {
        case index = "idx"
        case time = "time"
        case giftName = "name"
        case clover = "clover"
    }
}
