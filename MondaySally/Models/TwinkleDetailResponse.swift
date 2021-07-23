//
//  TwinkleDetailResponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/21.
//

// 탭바에서 트윙클 화면 조회
struct TwinkleDetailResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: TwinkleDetailInfo?
}


struct TwinkleDetailInfo: Decodable{
    let isWriter: String
    let writerName: String
    let date: String
    let twinkleImageList: [TwinkleImageInfo]
    let content: String
    let giftName: String
    let clover: Int
    let isAccepted: String?
    let likeCount: Int
    let isHearted: String
    let commentCount: Int
    let commentList: [TwinkleCommentInfo]?

    enum CodingKeys:  String, CodingKey {
        case isWriter = "isWriter"
        case writerName = "writerName"
        case date = "twinkleCreatedAt"
        case twinkleImageList = "twinkleImglists"
        case content = "content"
        case giftName = "giftName"
        case clover = "option"
        case isAccepted = "isAccepted"
        case likeCount = "likeNum"
        case isHearted = "isHearted"
        case commentCount = "commentNum"
        case commentList = "commentLists"
    }
}


struct TwinkleImageInfo: Decodable{
    let index: Int
    let imageUrl: String

    enum CodingKeys:  String, CodingKey {
        case index = "idx"
        case imageUrl = "imgUrl"
    }
}

struct TwinkleCommentInfo: Decodable{
    let index: Int
    let nickName: String
    let profileImage: String?
    let content: String
    let date: String
    let isWriter: String

    enum CodingKeys:  String, CodingKey {
        case index = "idx"
        case nickName = "commentWriterName"
        case profileImage = "commentWriterImg"
        case content = "commentContent"
        case date = "commentCreatedAt"
        case isWriter = "isCommentWrited"
    }
}
