//
//  CloverHistoryResponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/18.
//

struct CloverAccumulateResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: AccumulateCloverInfo?
}

struct AccumulateCloverInfo: Decodable{
    var cloverTotal: Int
    var cloverHistoryList: [AccumulateCloverHistoryInfo]?
    
    enum CodingKeys:  String, CodingKey {
        case cloverTotal = "accumulatedClover"
        case cloverHistoryList = "clovers"
    }
}

struct AccumulateCloverHistoryInfo: Decodable{
    var index: Int
    var time: String
    var worktime: Int
    var clover: Int
    
    enum CodingKeys:  String, CodingKey {
        case index = "idx"
        case time = "time"
        case worktime = "worktime"
        case clover = "point"
    }
}




