//
//  HomeReponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/20.
//

struct HomeResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: HomeInfo?
}

struct HomeInfo: Decodable{
    var nickname: String
    var companyIdx: Int
    var logoImgUrl: String?
    var totalWorkTime: String
    var status: String
    var accumulatedClover: Int
    var currentClover: Int
    var usedClover: Int
    var giftHistory: [GiftHistoryPreview]?
    var twinkleRank: [TwinkleRankingPreview]?
    var workingMemberlist: [WorkingMember]?
}

struct GiftHistoryPreview: Decodable{
    var imgUrl: String
    var isAccepted: String?
    var isProved: String
    var name: String
}

struct TwinkleRankingPreview: Decodable{
    var ranking: Int
    var imgUrl: String?
    var nickname: String
    var currentClover: Int
}


struct WorkingMember: Decodable{
    var status: String
    var nickname: String
    var position: String
}
