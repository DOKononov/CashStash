//
//  Transaction.swift
//  CashStash
//
//  Created by Dmitry Kononov on 21.04.22.
//

import Foundation

final class Transaction {
    var transactionName: String
    var date: Date
    var amount: Double
    var income: Bool
    
    init(transactionName: String, date: Date = Date(), amount: Double = 0, income: Bool = false) {
        self.transactionName = transactionName
        self.date = date
        self.amount = amount
        self.income = income
    }
}

