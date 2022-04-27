//
//  AddTransactionVC.swift
//  CashStash
//
//  Created by Dmitry Kononov on 21.04.22.
//

import UIKit


enum TransactionType: String, CaseIterable {
    case income = "Income"
    case expance = "Expance"
    
    var bool : Bool {
        switch self {
        case .income: return true
        case .expance: return false
        }
    }
}


final class AddTransactionVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var amountTF: UITextField! {  didSet { amountTF.delegate = self } }
    @IBOutlet weak var tTypeTF: UITextField!
    
    var date: Date?
    var income: Bool?
    
    var viewModel: AddTransactionProtocol = AddTransactionViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTypePicker()
        setupDatePicker()
        setupVC()
    }
    
    @IBAction private func saveDidTapped(_ sender: UIButton) {
        guard dateTF.hasText, descriptionTF.hasText, amountTF.hasText, tTypeTF.hasText else {return}
        guard let amount = amountTF.text, let description = descriptionTF.text, let date = date, let income = income else {return}
        
        let components = TransactionComponents(income: income,
                                               amount: amount.double(),
                                               date: date,
                                               description: description)
        
        viewModel.saveDidTaped(components: components)
        
        viewModel.delegate?.updateWalletInfo()
        closeVC()
    }
    
    private func setupDatePicker() {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        dateTF.inputView = picker
        picker.preferredDatePickerStyle = .wheels
        picker.addTarget(self, action: #selector(datePickerChangedValue), for: .valueChanged)
    }
    
    @objc private func datePickerChangedValue(sender: UIDatePicker) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        dateTF.text = dateFormater.string(from: sender.date)
        date = sender.date
    }
    
    private func setupTypePicker() {
        let picker = UIPickerView()
        tTypeTF.inputView = picker
        picker.delegate = self
        picker.dataSource = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupVC() {
        guard let transaction = viewModel.myTransaction  else {return}
        titleLabel.text = ""
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        dateTF.text = dateFormater.string(from: transaction.date ?? Date() )
        
        descriptionTF.text = transaction.tDescription
        amountTF.text = transaction.amount.formatNumber()
        transaction.income ?
        (tTypeTF.text = TransactionType.income.rawValue) :
        (tTypeTF.text = TransactionType.expance.rawValue)
    }
    
    private func closeVC() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
}


extension AddTransactionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TransactionType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TransactionType.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tTypeTF.text = TransactionType.allCases[row].rawValue
        income = TransactionType.allCases[row].bool
        view.endEditing(true)
    }
}


extension AddTransactionVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == amountTF, string == "," {
            if let text = textField.text {
                textField.text = text + "."
                return false
            }
        }
        return true
    }
    
}
