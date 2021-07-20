//
//  GiftRequestInput.swift
//  MondaySally
//
//  Created by meng on 2021/07/16.
//

struct GiftRequestInput: Encodable {
    var giftIdx: Int
    var usedClover: Int
    
    var toDictionary: [String: Int] {
        let dict: [String: Int]  = ["giftIdx": giftIdx, "usedClover": usedClover]
        return dict
    }
}
