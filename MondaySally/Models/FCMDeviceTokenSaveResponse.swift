//
//  FCMDeviceTokenSaveReponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/13.
//

struct FCMDeviceTokenSaveResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
}
