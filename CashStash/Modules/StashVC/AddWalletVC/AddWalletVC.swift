//
//  AddWalletVC.swift
//  CashStash
//
//  Created by Dmitry Kononov on 11.04.22.
//

import UIKit

final class AddWalletVC: UIViewController {
    
    @IBOutlet private weak var walletNameLabel: UILabel!
    @IBOutlet private weak var walletNameTF: UITextField!
    @IBOutlet private weak var amountTF: UITextField!
    @IBOutlet private weak var currencyTF: UITextField!
    
    var viewModel: AddWalletViewModelProtocol = AddWalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletNameLabel.text = "New Wallet"
        walletNameTF.becomeFirstResponder()
        callPickerForCurrency()
    }
    
    @IBAction private func saveDidTapped(_ sender: UIButton) {
        guard walletNameTF.hasText, amountTF.hasText, currencyTF.hasText else { return }
        
        guard let walletName = walletNameTF.text,
              let amount = amountTF.text,
              let currency = currencyTF.text else {return}
        
        viewModel.saveDidTapped(walletName: walletName, amount: amount, currency: currency)
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    

}


extension AddWalletVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func callPickerForCurrency() {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        currencyTF.inputView = picker
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CurrencyList.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return CurrencyList.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyTF.text = CurrencyList.allCases[row].rawValue
    }
}
