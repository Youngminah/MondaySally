//
//  FCMDeviceTokenInput.swift
//  MondaySally
//
//  Created by meng on 2021/07/17.
//

struct FCMDeviceTokenInput: Encodable {
    var token: String
    
    var toDictionary: [String: Any] {
        let dict: [String: Any]  = ["token": token]
        return dict
    }
}
