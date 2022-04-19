//
//  AddNewCurrencyViewModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 18.04.22.
//

import Foundation

protocol AddNewWalletViewModelProtocol {
    func saveDidTapped(walletName: String, amount: String, currency: String)
}

class AddNewWalletViewModel: AddNewWalletViewModelProtocol {
    private lazy var networkService = NetworkService()
    
    func saveDidTapped(walletName: String, amount: String, currency: String) {
            let newWalletEntity = WalletEntity(context: CoreDataService.shared.managedObjectContext)
        newWalletEntity.walletName = walletName
        newWalletEntity.amount = amount.double().myRound()
        newWalletEntity.currency = currency
        networkService.getRateToUSD(to: currency) { rate in
            newWalletEntity.rate = rate
        }
        CoreDataService.shared.saveContext()
        
    }
    
}
