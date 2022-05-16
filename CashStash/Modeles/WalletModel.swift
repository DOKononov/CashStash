//
//  WalletModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 14.05.22.
//

import Foundation

final class WalletModel {
    var amount: Double
    var currency: String?
    var rate: Double
    var walletName: String?
    var transaction: NSSet?
    
    init (amount: Double, currency: String?, rate: Double, walletName: String?, transaction: NSSet?) {
        self.amount = amount
        self.currency = currency
        self.rate = rate
        self.walletName = walletName
        self.transaction = transaction
    }
    
    init (walletEntity: WalletEntity) {
        self.amount = walletEntity.amount
        self.currency = walletEntity.currency
        self.rate = walletEntity.rate
        self.walletName = walletEntity.walletName
        self.transaction = walletEntity.transaction
    }
}

