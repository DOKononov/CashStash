//
//  CurrencyPageViewModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 18.04.22.
//

import Foundation

protocol CurrencyPageViewModelProtocol {
    func saveDidTapped(walletName: String, amount: String, currency: String)
    var selectedWallet: Wallet? { get set }
}

class CurrencyPageViewModel: CurrencyPageViewModelProtocol {
    var selectedWallet: Wallet?
    private lazy var networkService = NetworkService()
    
    func saveDidTapped(walletName: String, amount: String, currency: String) {
        //if no entity
        if !entityIsExist() {
            let newWalletEntity = WalletEntity(context: CoreDataService.shared.managedObjectContext)
            saveNewEntity(newWalletEntity, walletName: walletName, amount: amount, currency: currency)
        } else {
            //else change existing wallet
            guard let entityToChange = getEntityFromCD() else {return}
            saveNewEntity(entityToChange, walletName: walletName, amount: amount, currency: currency)
        }
    }
    
    private func saveNewEntity(_ newWalletEntity: WalletEntity, walletName: String, amount: String, currency: String) {
        newWalletEntity.walletName = walletName
        newWalletEntity.amount = amount.double().myRound()
        newWalletEntity.currency = currency
        networkService.getRateToUSD(to: currency) { rate in
            newWalletEntity.rate = rate
        }
        CoreDataService.shared.saveContext()
    }
    
    private func entityIsExist() -> Bool {
        
        if let selectedWallet = selectedWallet,
           getEntityFromCD()?.walletName == selectedWallet.name {
            return true
        }  else {
            return false
        }
    }
    
    private func getEntityFromCD() -> WalletEntity? {
        guard let selectedWallet = selectedWallet else {return nil}
        let request = WalletEntity.fetchRequest()
        request.predicate = NSPredicate(format: "walletName = %@", selectedWallet.name)
        if  let result = try? CoreDataService.shared.managedObjectContext.fetch(request) {
            if let entity =  result.first {
                return entity
            }
        }
        return nil
    }
    
}
