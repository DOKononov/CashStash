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

    var viewModel: CurrencyPageViewModelProtocol = CurrencyPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        walletNameTF.becomeFirstResponder()
    }
    
    private func setupVC() {
        viewModel.selectedWallet == nil ?
        (walletNameLabel.text = "New Wallet") :
        (walletNameLabel.text = viewModel.selectedWallet?.name)
        
        amountTF.text = viewModel.selectedWallet?.amount.string()
        currencyTF.text = viewModel.selectedWallet?.currency
    }
    
    @IBAction private func saveDidTapped(_ sender: UIButton) {
        guard walletNameTF.hasText, amountTF.hasText, currencyTF.hasText else { return }
        
        guard let walletName = walletNameTF.text,
              let amount = amountTF.text,
              let currency = currencyTF.text else {return}
        
        viewModel.saveDidTapped(walletName: walletName, amount: amount, currency: currency)
        self.dismiss(animated: true)
    }
}
