//
//  Constant.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import Alamofire

struct Constant {
    static let BASE_URL = "https://test.mondaysally.com"
    static var HEADERS: HTTPHeaders = ["x-access-token" : JwtToken.jwt]
}


