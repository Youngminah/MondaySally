//
//  CloverRankingResponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/18.
//

struct CloverRankingResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: [CloverRankingInfo]?
}

struct CloverRankingInfo: Decodable {
    var ranking: Int
    var imgUrl: String?
    var nickname: String?
    var currentClover: Int
    var accumulatedClover: Int
    var totalworktime: String?
}
