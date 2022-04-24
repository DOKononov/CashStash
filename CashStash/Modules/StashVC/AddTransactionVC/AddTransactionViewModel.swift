//
//  AddTransactionViewModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 21.04.22.
//

import Foundation

protocol WalletHistoryDelegate {
    func updateWalleteAmount()
}

protocol AddTransactionProtocol {
    var delegate: WalletHistoryDelegate? { get set }
    var wallet: WalletEntity? { get set }
    var transactionComponents: Transaction { get set }
    func saveDidTaped()
}

final class AddTransactionViewModel: AddTransactionProtocol {
    
    var delegate: WalletHistoryDelegate?
    var wallet: WalletEntity?
    var transactionComponents = Transaction()
    
    func saveDidTaped() {
        let newTransaction = TransactionEntity(context: CoreDataService.shared.managedObjectContext)

        newTransaction.income = transactionComponents.income
        newTransaction.amount = transactionComponents.amount
        newTransaction.wallet = wallet
        newTransaction.date = transactionComponents.date
        newTransaction.tDescription = transactionComponents.tDescription
        
        if  newTransaction.income {
            wallet?.amount += newTransaction.amount
        } else {
            wallet?.amount -= newTransaction.amount
        }
        
        CoreDataService.shared.saveContext()
    }
}
