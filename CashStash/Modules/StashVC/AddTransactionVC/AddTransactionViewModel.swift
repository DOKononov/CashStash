//
//  AddTransactionViewModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 21.04.22.
//

import Foundation
import CoreData

protocol AddTransactionProtocol {
    var delegate: WalletHistoryDelegate? { get set }
    var wallet: WalletEntity? { get set }
    var date: Date? { get set }
    var income: Bool? { get set }
    var myTransaction: TransactionEntity? { get set }
    func saveDidTaped(components: TransactionComponents)
}

final class AddTransactionViewModel: AddTransactionProtocol {
    var delegate: WalletHistoryDelegate?
    var wallet: WalletEntity?
    var myTransaction: TransactionEntity?
    var date: Date?
    var income: Bool?

    
    //TODO: if exist - edite else save
    func saveDidTaped(components: TransactionComponents) {
        //edite transaction
        if let editedTransaction = myTransaction {
            
            wallet?.deleteTransaction(editedTransaction)
            editeExisting(transaction: editedTransaction, with: components)
            wallet?.addTransaction(editedTransaction)
            
        } else {
            let newTransaction = createTransaction(from: components)
            wallet?.addTransaction(newTransaction)
        }
        CoreDataService.shared.saveContext()
    }
    
    
    private func createTransaction(from components: TransactionComponents) -> TransactionEntity {
        let newTransaction = TransactionEntity(context: CoreDataService.shared.managedObjectContext)
        newTransaction.income = components.income
        newTransaction.amount = components.amount
        newTransaction.date = components.date
        newTransaction.tDescription = components.description
        newTransaction.wallet = wallet
        return newTransaction
    }
    
    private func editeExisting(transaction: TransactionEntity, with components: TransactionComponents) {
        transaction.tDescription = components.description
        transaction.income = components.income
        transaction.date = components.date
        transaction.amount = components.amount
    }
    
}
