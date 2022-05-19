//
//  AddNewCurrencyViewModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 18.04.22.
//

import Foundation

protocol AddWalletViewModelProtocol {
    func saveDidTapped(walletName: String, amount: String, currency: String)
    var wallet: WalletEntity? { get set }
    func editeWallete(walletName: String, amount: String, currency: String)
}

final class AddWalletViewModel: AddWalletViewModelProtocol {
    private lazy var networkService = NetworkService()
    var wallet: WalletEntity?
    
    func saveDidTapped(walletName: String, amount: String, currency: String) {
            let newWalletEntity = WalletEntity(context: CoreDataService.shared.managedObjectContext)
        newWalletEntity.walletName = walletName
        newWalletEntity.amount = amount.double()
        newWalletEntity.currency = currency
        networkService.getRateToUSD(to: currency) { rate in
            newWalletEntity.rate = rate
        }
        CoreDataService.shared.saveContext()
    }
    
    func editeWallete(walletName: String, amount: String, currency: String) {
        wallet?.walletName = walletName
        wallet?.amount = amount.double()
        wallet?.currency = currency
        CoreDataService.shared.saveContext()
    }
    
}
