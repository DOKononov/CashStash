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
        let request = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "amount == %f", components.amount)
        request.predicate = NSPredicate(format: "date == %@", components.date as NSDate)
        request.predicate = NSPredicate(format: "income == %d", components.income)
        request.predicate = NSPredicate(format: "tDescription == %@", components.description)
        if let result = try? CoreDataService.shared.managedObjectContext.fetch(request) {
            return result.count > 0
        } else {
            return false
        }
    }
}


