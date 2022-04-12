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
    
    func roundStr() -> String {
        return String(Int(self))
    }
}
