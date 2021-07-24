//
//  TwinkleEditInput.swift
//  MondaySally
//
//  Created by meng on 2021/07/24.
//

struct TwinkleEditInput: Encodable {
    var content: String
    var receiptImageUrl: String
    var twinkleImaageList: [String]
    
    var toDictionary: [String: Any] {
        let dict: [String: Any]  = ["content": content, "receiptImgUrl": receiptImageUrl, "updateTwinkleImgList": twinkleImaageList]
        return dict
    }
}
