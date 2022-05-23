//
//  TransactionComponents.swift
//  CashStash
//
//  Created by Dmitry Kononov on 27.04.22.
//

import Foundation

final class TransactionComponents {
    var income: Bool
    var amount: Double
    var date: Date
    var description: String
    
    init (income: Bool, amount: Double, date: Date, description: String) {
        self.income = income
        self.amount = amount
        self.date = date
        self.description = description
    }
}
