//
//  WalletEntity+CoreDataProperties.swift
//  CashStash
//
//  Created by Dmitry Kononov on 11.04.22.
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

}

extension WalletEntity : Identifiable {

}
