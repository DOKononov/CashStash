//
//  WalletHistoryViewModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 19.04.22.
//

import UIKit
import CoreData

protocol WalletHistoryProtocol {
    var wallet: WalletEntity? { get set }
    var transactions: [TransactionEntity] { get set }
    var contentDidChanged: (() -> Void)?  { get set }
    func loadTransactions()
    func loadWallet()
    func deleteTransaction(indexPath: IndexPath, complition: () -> Void)
    func settingsButtonDidTapped(viewController: UIViewController, complition: @escaping () -> Void) 
}

final class WalletHistoryViewModel: NSObject, WalletHistoryProtocol, NSFetchedResultsControllerDelegate {
    var walletDidChanged: (() -> Void)?
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
        let walletNamePredicare = NSPredicate(format: "walletName == %@", walletName)
        let currencyPredicate = NSPredicate(format: "currency == %@", currency)
        request.predicate = NSCompoundPredicate(type: .and, subpredicates: [walletNamePredicare, currencyPredicate])
        if let result = try? CoreDataService.shared.managedObjectContext.fetch(request) {
            if let wallet = result.first {
                self.wallet = wallet
            }
        }
    }
    
    func settingsButtonDidTapped(viewController: UIViewController, complition: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let wipeButton = UIAlertAction(title: "WipeWallet", style: .destructive) { _ in
            self.wipeWallet(complition: complition)
        }
        let editeButton = UIAlertAction(title: "Edite wallet", style: .default) { _ in
            self.editeWallet(viewController: viewController)
        }
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            viewController.dismiss(animated: true)
        }
        alert.addAction(wipeButton)
        alert.addAction(editeButton)
        alert.addAction(cancelButton)
        viewController.present(alert, animated: true)
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
    
    private func wipeWallet(complition: () -> Void) {
        guard let wallet = wallet else { return }
        let request = TransactionEntity.fetchRequest()
        let predecate = NSPredicate(format: "wallet == %@", wallet)
        request.predicate = predecate
        if let result = try? CoreDataService.shared.managedObjectContext.fetch(request) {
            result.forEach { transaction in
                wallet.deleteTransaction(transaction)
                CoreDataService.shared.managedObjectContext.delete(transaction)
            }
            wallet.amount = 0
            CoreDataService.shared.saveContext()
            complition()
        }
    }
    
    private func editeWallet(viewController: UIViewController) {
        let edditeWalletVC = AddWalletVC(nibName: "\(AddWalletVC.self)", bundle: nil)
        edditeWalletVC.viewModel.wallet = wallet
        viewController.navigationController?.pushViewController(edditeWalletVC, animated: true)
    }
    
}
