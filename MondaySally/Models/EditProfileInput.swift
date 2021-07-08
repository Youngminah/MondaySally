//
//  EditProfileInput.swift
//  MondaySally
//
//  Created by meng on 2021/07/08.
//

struct EditProfileInput: Encodable {
    var nickname: String
    var imgUrl: String
    var phoneNumber: String
    var bankAccount: String
    var email: String
}
