//
//  AddTransactionViewModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 21.04.22.
//

import Foundation



protocol AddTransactionProtocol {
    var delegate: WalletHistoryDelegate? { get set }
    var wallet: WalletEntity? { get set }
    var myTransaction: TransactionEntity? { get set }
    func saveDidTaped(components: TransactionComponents)
}

final class AddTransactionViewModel: AddTransactionProtocol {
    var delegate: WalletHistoryDelegate?
    var wallet: WalletEntity?
    var myTransaction: TransactionEntity?

    
    //TODO: if exist - edite else save
    func saveDidTaped(components: TransactionComponents) {
        guard let wallet = wallet else { return }

        //edite transaction
        if CoreDataService.shared.ifTransactionExist(components: components, wallet: wallet) {
            
            //create new transaction
        } else {
            let newTransaction = createTransaction(components)
            self.updateWalletAmount(transaction: newTransaction)
            CoreDataService.shared.saveContext()
        }
    }
    
    private func updateWalletAmount(transaction: TransactionEntity) {
        if  transaction.income {
            wallet?.amount += transaction.amount
        } else {
            wallet?.amount -= transaction.amount
        }
    }
    
    private func createTransaction(_ components: TransactionComponents) -> TransactionEntity {
        let newTransaction = TransactionEntity(context: CoreDataService.shared.managedObjectContext)
        newTransaction.income = components.income
        newTransaction.amount = components.amount
        newTransaction.date = components.date
        newTransaction.tDescription = components.description
        newTransaction.wallet = wallet
        return newTransaction
    }
    
}
