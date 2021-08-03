//
//  MyGiftLogInfo.swift
//  MondaySally
//
//  Created by meng on 2021/07/16.
//

struct GiftHistoryResponse: Decodable{
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: GiftHistoryPagination?
}

struct GiftHistoryPagination: Decodable {
    let totalCount: Int
    let giftLogs: [MyGiftLogInfo]?
}

struct MyGiftLogInfo: Decodable{
    let giftLogIdx: Int
    let imgUrl: String
    let isAccepted: String?
    let isProved: String
    let twinkleIdx: Int?
    let name: String
    let usedClover: Int
}
