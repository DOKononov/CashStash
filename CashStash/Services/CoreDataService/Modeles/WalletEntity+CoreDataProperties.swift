//
//  WalletEntity+CoreDataProperties.swift
//  CashStash
//
//  Created by Dmitry Kononov on 21.04.22.
//
//

import Foundation
import CoreData


extension WalletEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WalletEntity> {
        return NSFetchRequest<WalletEntity>(entityName: "WalletEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var currency: String?
    @NSManaged public var rate: Double
    @NSManaged public var walletName: String?
    @NSManaged public var transaction: NSSet?

}

// MARK: Generated accessors for transaction
extension WalletEntity {

    @objc(addTransactionObject:)
    @NSManaged public func addToTransaction(_ value: TransactionEntity)

    @objc(removeTransactionObject:)
    @NSManaged public func removeFromTransaction(_ value: TransactionEntity)

    @objc(addTransaction:)
    @NSManaged public func addToTransaction(_ values: NSSet)

    @objc(removeTransaction:)
    @NSManaged public func removeFromTransaction(_ values: NSSet)

}

extension WalletEntity : Identifiable {

}
