//
//  TwinkleResponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/19.
//


// 탭바에서 트윙클 화면 조회 
struct TwinkleResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: Twinkles?
}

struct Twinkles: Decodable {
    var twinkles: [TwinkleInfo]?
    
}

struct TwinkleInfo: Decodable{
    let index: Int
    let profileImage: String?
    let nickName: String?
    let giftName: String
    let clover: Int
    let thumbnailImage: String
    var isHearted: String
    let date: String
    let content: String
    var likeCount: Int
    let commentCount: Int
    
    enum CodingKeys:  String, CodingKey {
        case index = "idx"
        case profileImage = "imgUrl"
        case nickName = "nickname"
        case giftName = "name"
        case clover = "usedClover"
        case thumbnailImage = "twinkleImg"
        case isHearted = "isHearted"
        case date = "date"
        case content = "content"
        case likeCount = "likenum"
        case commentCount = "commentnum"
    }
}
