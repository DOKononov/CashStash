//
//  Wallet.swift
//  CashStash
//
//  Created by Dmitry Kononov on 7.04.22.
//

import Foundation

final class Wallet {
    var name: String
    var currency: String
    var amount: Double
    var amountUSD: Double {
        return (amount / rate).myRound()
    }
    var rate: Double
    
    init(name: String, currency: String, amount: Double = 0, rate: Double) {
        self.name = name
        self.currency = currency
        self.amount = amount
        self.rate = rate
    }
    
    
    init(entity: WalletEntity) {
        self.name = entity.walletName ?? "init error"
        self.currency = entity.currency ?? "init error"
        self.amount = entity.amount
        self.rate = entity.rate
    }
    
}
