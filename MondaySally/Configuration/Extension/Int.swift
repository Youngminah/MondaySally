//
//  Int.swift
//  MondaySally
//
//  Created by meng on 2021/07/17.
//

extension Int {
    var toCloverMoney: String {
        let money = Double(self) / Double(10000)
        return String(format: "%.1f", money)
    }
}
