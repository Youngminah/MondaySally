//
//  String.swift
//  MondaySally
//
//  Created by meng on 2021/06/29.
//

import UIKit

extension String {
    // MARK: 자주 사용되는 기능들
    // ex. guard let email = emailTextField.text?.trim, email.isExists else { return }
    var isEmpty: Bool {
        return self.count == 0
    }
    var isExists: Bool {
        return self.count > 0
    }
    var trim: String? {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    // MARK: 다국어 지원 (localization)
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    func localized(with values: String...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), values)
    }
    
    
    // MARK: substring
    func substring(from: Int, to: Int) -> String {
        guard (to >= 0) && (from <= self.count) && (from <= to) else {
            return ""
        }
        let start = index(startIndex, offsetBy: max(from, 0))
        let end = index(start, offsetBy: min(to, self.count) - from)
        return String(self[start ..< end])
    }
    
    func substring(range: Range<Int>) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }
    
    
    // MARK: indexing
    func get(_ index: Int) -> String {
        return self.substring(range: index..<index)
    }
    
    
    // MARK: replace
    func replace(target: String, with withString: String) -> String{
        return self.replacingOccurrences(of: target, with: withString, options: .literal, range: nil)
    }
    
    
    // MARK: comma
    // ex. "1234567890".insertComma == "1,234,567,890"
    var insertComma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let _ = self.range(of: ".") {
            let numberArray = self.components(separatedBy: ".")
            if numberArray.count == 1 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                guard let doubleValue = Double(numberString)
                    else { return self }
                return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
            } else if numberArray.count == 2 {
                var numberString = numberArray[0]
                if numberString.isEmpty {
                    numberString = "0"
                }
                guard let doubleValue = Double(numberString)
                    else {
                        return self
                }
                return (numberFormatter.string(from: NSNumber(value: doubleValue)) ?? numberString) + ".\(numberArray[1])"
            }
        }
        else {
            guard let doubleValue = Double(self)
                else {
                    return self
            }
            return numberFormatter.string(from: NSNumber(value: doubleValue)) ?? self
        }
        return self
    }
    

    
    func isValidTeamcode() -> Bool {
          let teamRegEx = "^[A-Za-z0-9]{0,}$"
          let teamTest = NSPredicate(format:"SELF MATCHES %@", teamRegEx)
          return teamTest.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
          let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailTest.evaluate(with: self)
    }
    
    func isValidNumber() -> Bool {
        let stringRegEx = "^[0-9]{1,}$"
        let pred = NSPredicate(format:"SELF MATCHES %@", stringRegEx)
        return pred.evaluate(with: self)
    }
    
    func isValidNickname() -> Bool {
        let nicknameRegEx = "^[ㄱ-ㅎㅏ-ㅣ가-힣A-Za-z]{1,}$"
        let pred = NSPredicate(format:"SELF MATCHES %@", nicknameRegEx)
        return pred.evaluate(with: self)
    }
}


