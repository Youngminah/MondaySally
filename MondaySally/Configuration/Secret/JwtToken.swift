//
//  JwtToken.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit
struct JwtToken {
    static var jwt: String = UserDefaults.standard.string(forKey: "JwtToken") ?? ""
}
