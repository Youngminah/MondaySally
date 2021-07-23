//
//  AppVersionInfo.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//

struct AppVersionResponse: Decodable{
    var isSuccess: Bool
    var code: Int
    var message: String
    var result: AppVersion
}

struct AppVersion: Decodable {
    let version: String
    
    enum CodingKeys:  String, CodingKey {
        case version = "version"
    }
}
