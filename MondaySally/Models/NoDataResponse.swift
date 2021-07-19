//
//  NoDataResponse.swift
//  MondaySally
//
//  Created by meng on 2021/07/19.
//

struct NoDataResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
}
