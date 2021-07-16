//
//  TeamCodeInfo.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//

struct TeamCodeResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: TeamCodeInfo?
}

struct TeamCodeInfo: Decodable{
    var jwt: String
}
