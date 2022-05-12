//
//  Double+String.swift
//  CashStash
//
//  Created by Dmitry Kononov on 11.04.22.
//

import Foundation

extension Double {
    
    func string() -> String {
        return String(self)
    }
    
     func formatNumber() -> String {
        let formater = NumberFormatter()
        formater.numberStyle = .decimal
        formater.decimalSeparator = "."
        formater.groupingSeparator = " "
        guard let str = formater.string(from: self as NSNumber) else {return "error"}
        return str
    }
    
    func myRound() -> Double {
        return (self * 100).rounded() / 100.0
    }
}
