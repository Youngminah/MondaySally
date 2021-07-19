//
//  TwinkleWriteInput.swift
//  MondaySally
//
//  Created by meng on 2021/07/19.
//

struct TwinkleWriteInput: Encodable {
    var giftIndex: Int
    var content: String
    var receiptImageUrl: String
    var twinkleImaageList: [String]
    
    var toDictionary: [String: Any] {
        let dict: [String: Any]  = ["giftLogIdx": giftIndex, "content": content, "receiptImgUrl": receiptImageUrl, "twinkleImgList": twinkleImaageList]
        return dict
    }
}
