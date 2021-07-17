//
//  CloverHistoryResponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/18.
//

struct CloverHistoryResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: CloverHistoryInfo?
}

struct CloverHistoryInfo: Decodable{
    var currentClover: Int
    var accumulatedClover: Int
    var usedClover: Int
    var accumulatedCloverList: [TotalCloverInfo]?
    var usedCloverList: [UsedCloverInfo]?
}

struct TotalCloverInfo: Decodable{
    var time: String
    var worktime: Int
    var clover: Int
}

struct UsedCloverInfo: Decodable{
    var time: String
    var name: String
    var clover: Int
}




