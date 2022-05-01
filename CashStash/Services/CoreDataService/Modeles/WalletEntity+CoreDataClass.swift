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

    func deleteTransaction(_ transaction: TransactionEntity) {
        if transaction.income {
            self.amount -= transaction.amount
        } else {
            self.amount += transaction.amount
        }
    }
    
    func addTransaction(_ transaction: TransactionEntity) {
        if transaction.income {
            self.amount += transaction.amount
        } else {
            self.amount -= transaction.amount
        }
    }
}
