//
//  Sting+Double.swift
//  CashStash
//
//  Created by Dmitry Kononov on 11.04.22.
//

import Foundation

extension String {
    func double() -> Double {
        let str = self.filter { $0 != " " }
        return Double(str) ?? 0
    }
}
