//
//  CloverRankingResponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/18.
//

struct CloverRankingResponse: Decodable{
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: Rank?
}

struct Rank: Decodable {
    let ranks: [CloverRankingInfo]?
}

struct CloverRankingInfo: Decodable {
    let ranking: Int
    let imgUrl: String?
    let nickname: String?
    let currentClover: Int
}
