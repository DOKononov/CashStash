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
//    var textForTitle: String?
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
        guard walletNameTF.hasText,
              let walletName = walletNameTF.text,
              amountTF.hasText,
              let amount = amountTF.text,
              currencyTF.hasText,
              let currency = currencyTF.text else { return }
        
        let newWalletEntity = WalletEntity(context: CoreDataService.shared.managedObjectContext)
        newWalletEntity.walletName = walletName
        newWalletEntity.amount = amount.double()
        newWalletEntity.currency = currency
        
        networkService.getRateToUSD(to: currency) { rate in
            newWalletEntity.rate = rate
        }
        
        CoreDataService.shared.saveContext()
        self.dismiss(animated: true)
    }
    
}
