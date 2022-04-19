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
    var walletsList: [Wallet] { get set }
    var didChangeContent: (() -> Void)? { get set }
    var totalAmount: Double { get }
    func updateTotalAmount()
    func loadWalletsEntities()
    func deleteWallet(indexPath: IndexPath) -> UISwipeActionsConfiguration?
}


class StashViewModel: NSObject, StashViewModelProtocol, NSFetchedResultsControllerDelegate {
    
    var walletsEntity: [WalletEntity] = [] {
        didSet {
            convertWalletsEntitiesToModel()
        }
    }
    lazy var fetchResultContoller = NSFetchedResultsController<WalletEntity>()
    
    var walletsList: [Wallet] = [] {
        didSet {
            calcTotalAmount()
            didChangeContent?()
        }
    }
    
    var totalAmount: Double = 0
    var didChangeContent: (() -> Void)?
    func updateTotalAmount() {
        calcTotalAmount()
    }
    
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
    
    func loadWalletsEntities() {
        setupFetchResultController()
        try? fetchResultContoller.performFetch()
        
        if let result = fetchResultContoller.fetchedObjects {
            walletsEntity = result
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        loadWalletsEntities()
    }
    
    private func convertWalletsEntitiesToModel() {
        var tempArray: [Wallet] = []
        walletsEntity.forEach { entity in
        let wallet = Wallet(entity: entity)
            tempArray.append(wallet)
        }
        walletsList = tempArray
    }
    
    func deleteWallet(indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let del = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            let modelToDelete = self.walletsList[indexPath.row]
            let request = WalletEntity.fetchRequest()
            request.predicate = NSPredicate(format: "walletName = %@", modelToDelete.name)
            if let result = try? CoreDataService.shared.managedObjectContext.fetch(request),
               let entityToDelete = result.first {
                CoreDataService.shared.managedObjectContext.delete(entityToDelete)
                CoreDataService.shared.saveContext()
            }
        }
        return UISwipeActionsConfiguration(actions: [del])
    }
    
    private func calcTotalAmount() {
        var tempSumm = 0.0
        walletsList.forEach { tempSumm += ($0.amount / $0.rate).myRound() }
        totalAmount = tempSumm
    }
    
}
