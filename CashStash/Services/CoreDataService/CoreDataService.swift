//
//  CoreDataService.swift
//  CashStash
//
//  Created by Dmitry Kononov on 11.04.22.
//

import Foundation
import CoreData

final class CoreDataService {
    
    static let shared = CoreDataService()
    
    private init() {}
    
    var managedObjectContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "CashStash")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()


    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func ifTransactionExist(components: TransactionComponents, wallet: WalletEntity) -> Bool {
        let request = transactionRequest(components: components, wallet: wallet)
        if let result = try? CoreDataService.shared.managedObjectContext.fetch(request) {
            return result.count > 0
        } else {
            return false
        }
    }
    
    func getTransaction(components: TransactionComponents, wallet: WalletEntity) -> TransactionEntity? {
        let request = transactionRequest(components: components, wallet: wallet)
        if let result = try? CoreDataService.shared.managedObjectContext.fetch(request) {
            guard let transaction = result.first else {return nil}
            return transaction
        }
        return nil
    }
    
    private func transactionRequest(components: TransactionComponents, wallet: WalletEntity) -> NSFetchRequest<TransactionEntity> {
        let request = TransactionEntity.fetchRequest()
       let amountPredicate = NSPredicate(format: "amount == %f", components.amount)
        let datePredicate = NSPredicate(format: "date == %@", components.date as NSDate)
        let incomePredicate = NSPredicate(format: "income == %d", components.income)
        let descriptionPredicate = NSPredicate(format: "tDescription == %@", components.description)
        let walletPredicate  = NSPredicate(format: "wallet == %@", wallet)
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [amountPredicate,
                                                                            datePredicate,
                                                                            incomePredicate,
                                                                            datePredicate,
                                                                            descriptionPredicate,
                                                                            walletPredicate])
        return request
    }
}


