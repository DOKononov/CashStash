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
        //if no entity
        if !entityIsExist() {
            saveNewEntity()
        } else {
            //else change existing wallet
            changeExistingEntity()
        }
        
        self.dismiss(animated: true)
    }
    
    
    private func saveNewEntity() {
        guard walletNameTF.hasText,
              amountTF.hasText,
              currencyTF.hasText else { return }
        
        guard let walletName = walletNameTF.text,
              let amount = amountTF.text,
              let currency = currencyTF.text else {return}
        
        let newWalletEntity = WalletEntity(context: CoreDataService.shared.managedObjectContext)
        newWalletEntity.walletName = walletName
        newWalletEntity.amount = amount.double()
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

    
    private func changeExistingEntity() {
        
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
