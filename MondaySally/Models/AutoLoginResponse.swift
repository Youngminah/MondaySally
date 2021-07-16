//
//  AutoLoginInfo.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//

struct AutoLoginResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
}
