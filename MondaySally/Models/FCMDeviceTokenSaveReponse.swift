//
//  FCMDeviceTokenSaveReponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/13.
//

struct FCMDeviceTokenSaveReponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
}
