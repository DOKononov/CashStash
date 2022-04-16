//
//  CurrencyPageVC.swift
//  CashStash
//
//  Created by Dmitry Kononov on 11.04.22.
//

import UIKit

final class CurrencyPageVC: UIViewController {
    
    @IBOutlet private weak var walletNameLabel: UILabel!
    @IBOutlet private weak var walletNameTF: UITextField!
    @IBOutlet private weak var amountTF: UITextField!
    @IBOutlet private weak var currencyTF: UITextField!
    var selectedWallet: Wallet?
    lazy var networkService = NetworkService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    private func setupVC() {
        walletNameLabel.text = selectedWallet?.name
        walletNameTF.text = selectedWallet?.name
        amountTF.text = selectedWallet?.amount.string()
        currencyTF.text = selectedWallet?.currency
        
    }
    
    
    @IBAction private func saveDidTapped(_ sender: UIButton) {
        guard walletNameTF.hasText, amountTF.hasText, currencyTF.hasText else { return }
        //if no entity
        if !entityIsExist() {
            let newWalletEntity = WalletEntity(context: CoreDataService.shared.managedObjectContext)
            saveNewEntity(newWalletEntity)
        } else {
            //else change existing wallet
            guard let entityToChange = getEntityFromCD() else {return}
            saveNewEntity(entityToChange)
        }
        
        self.dismiss(animated: true)
    }
    
    
    private func saveNewEntity(_ newWalletEntity: WalletEntity) {
        guard let walletName = walletNameTF.text,
              let amount = amountTF.text,
              let currency = currencyTF.text else {return}
        
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
