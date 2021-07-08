//
//  AppVersion.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//

struct AppVersion: Decodable {
    let version: String
    
    enum CodingKeys:  String, CodingKey {
        case version = "Version"
    }
}
