//
//  WalletHistoryViewModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 19.04.22.
//

import Foundation
import CoreData

protocol WalletHistoryProtocol {
    var wallet: WalletEntity? { get set }
    var transactions: [TransactionEntity] { get set }
    var contentDidChanged : (() -> Void)?  { get set }
    func loadTransactions()
    func loadWallet()
    func deleteTransaction(indexPath: IndexPath, complition: () -> Void)
}

final class WalletHistoryViewModel: NSObject, WalletHistoryProtocol, NSFetchedResultsControllerDelegate {
    var contentDidChanged: (() -> Void)?
    var wallet: WalletEntity?
    
    lazy var fetchResultController = NSFetchedResultsController<TransactionEntity>()
        
    var transactions: [TransactionEntity] = [] {
        didSet{
            contentDidChanged?()
        }
    }
   
    private func setupFetchResultController() {
        let request = TransactionEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        guard let wallet = wallet else { return }
        let predicate = NSPredicate(format: "wallet == %@", wallet)
        request.predicate = predicate
        
        fetchResultController = NSFetchedResultsController(fetchRequest: request,
                                                           managedObjectContext: CoreDataService.shared.managedObjectContext,
                                                           sectionNameKeyPath: nil,
                                                           cacheName: nil)
        fetchResultController.delegate = self
    }
    
    func loadTransactions() {
        setupFetchResultController()
        try? fetchResultController.performFetch()
        if let result = fetchResultController.fetchedObjects {
            transactions = result
        }
    }
    
    func loadWallet() {
        let request = WalletEntity.fetchRequest()
        guard let walletName = wallet?.walletName, let currency = wallet?.currency else {return}
        request.predicate = NSPredicate(format: "walletName == %@", walletName)
        request.predicate = NSPredicate(format: "currency == %@", currency)
        
        if let result = try? CoreDataService.shared.managedObjectContext.fetch(request) {
            if let wallet = result.first {
                self.wallet = wallet
            }
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            loadTransactions()
    }
    
    func deleteTransaction(indexPath: IndexPath, complition: () -> Void) {
        let transactionToDel = transactions[indexPath.row]
        wallet?.deleteTransaction(transactionToDel)
        complition()
        CoreDataService.shared.managedObjectContext.delete(transactionToDel)
        CoreDataService.shared.saveContext()
    }
    
}
