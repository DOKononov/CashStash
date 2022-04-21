//
//  TransactionEntity+CoreDataProperties.swift
//  CashStash
//
//  Created by Dmitry Kononov on 21.04.22.
//
//

import Foundation
import CoreData


extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: Date?
    @NSManaged public var tDescription: String?
    @NSManaged public var income: Bool
    @NSManaged public var wallet: WalletEntity?

}

extension TransactionEntity : Identifiable {

}
