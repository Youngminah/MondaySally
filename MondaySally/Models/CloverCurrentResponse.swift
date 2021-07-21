//
//  CloverCurrentResponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/21.
//

struct CloverCurrentResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: CurrentCloverInfo?
}

struct CurrentCloverInfo: Decodable{
    var cloverTotal: Int
    var availableGiftList: [AvailableGiftInfo]?
    
    enum CodingKeys:  String, CodingKey {
        case cloverTotal = "currentClover"
        case availableGiftList = "gifts"
    }
}

struct AvailableGiftInfo: Decodable{
    var index: Int
    var imageUrl: String
    var giftName: String
    
    enum CodingKeys:  String, CodingKey {
        case index = "idx"
        case imageUrl = "imgUrl"
        case giftName = "name"
    }
}
