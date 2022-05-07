//
//  StashViewModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 3.04.22.
//

import Foundation
import CoreData
import UIKit

protocol StashViewModelProtocol {
    var walletsEntity: [WalletEntity] { get set }
    var didChangeContent: (() -> Void)? { get set }
    var totalAmount: Double { get }
    func updateTotalAmount()
    func loadWalletsEntities()
    func deleteWallet(indexPath: IndexPath) -> UISwipeActionsConfiguration?
}


final class StashViewModel: NSObject, StashViewModelProtocol, NSFetchedResultsControllerDelegate {
    
    var walletsEntity: [WalletEntity] = [] {
        didSet {
            updateTotalAmount()
            didChangeContent?()
        }
    }
    lazy var fetchResultContoller = NSFetchedResultsController<WalletEntity>()
    
    var totalAmount: Double = 0
    var didChangeContent: (() -> Void)?
    
    func updateTotalAmount() {
        var tempSumm = 0.0
        walletsEntity.forEach { tempSumm += ($0.amount / $0.rate).myRound() }
        totalAmount = tempSumm
    }
    
    func loadWalletsEntities() {
        setupFetchResultController()
        try? fetchResultContoller.performFetch()
        
        if let result = fetchResultContoller.fetchedObjects {
            walletsEntity = result
        }
    }
    
    func deleteWallet(indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let del = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let modelToDelete = self.walletsEntity[indexPath.row]
            let request = WalletEntity.fetchRequest()
            guard let name = modelToDelete.walletName else { return }
            request.predicate = NSPredicate(format: "walletName = %@", name)
            if let result = try? CoreDataService.shared.managedObjectContext.fetch(request),
               let entityToDelete = result.first {
                CoreDataService.shared.managedObjectContext.delete(entityToDelete)
                CoreDataService.shared.saveContext()
            }
        }
        return UISwipeActionsConfiguration(actions: [del])
    }
    
    //MARK: FetchedResultsController
    private func setupFetchResultController() {
        let request = WalletEntity.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "walletName", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        fetchResultContoller = NSFetchedResultsController(fetchRequest: request,
                                                          managedObjectContext: CoreDataService.shared.managedObjectContext,
                                                          sectionNameKeyPath: nil,
                                                          cacheName: nil)
        fetchResultContoller.delegate = self
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        loadWalletsEntities()
    }

}
