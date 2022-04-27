//
//  WalletEntity+CoreDataClass.swift
//  CashStash
//
//  Created by Dmitry Kononov on 21.04.22.
//
//

import Foundation
import CoreData

@objc(WalletEntity)
public class WalletEntity: NSManagedObject {

    func calc(transaction: TransactionEntity) {
        if transaction.income {
            self.amount += transaction.amount
        } else {
            self.amount -= transaction.amount
        }
    }
}
