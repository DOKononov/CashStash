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
    private lazy var textFieldService = TextFieldService()
    
    var viewModel: AddTransactionProtocol = AddTransactionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTypePicker()
        setupDatePicker()
        setupVC()
        setVCDefaultValue()
    }
    
    @IBAction private func saveDidTapped(_ sender: UIButton) {
        guard dateTF.hasText, descriptionTF.hasText, amountTF.hasText, tTypeTF.hasText else {return}
        guard let amount = amountTF.text,
              let description = descriptionTF.text,
              let date = viewModel.date,
              let income = viewModel.income else {return}
        
        let components = TransactionComponents(income: income, amount: amount.double(), date: date,
                                               description: description)
        
        viewModel.saveDidTaped(components: components)
        //TODO: ????
        viewModel.delegate?.updateWalletInfo()
        closeVC()
    }
    
    private func setupDatePicker() {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        dateTF.inputView = picker
        picker.preferredDatePickerStyle = .inline
        picker.addTarget(self, action: #selector(datePickerChangedValue), for: .valueChanged)
    }
    
    @objc private func datePickerChangedValue(sender: UIDatePicker) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        dateTF.text = dateFormater.string(from: sender.date)
        viewModel.date = sender.date
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
        descriptionTF.text = transaction.tDescription
        amountTF.text = transaction.amount.formatNumber()
    }
    
    private func closeVC() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
    
    private func setVCDefaultValue() {
        let date = Date()
        viewModel.date = date
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "dd.MM.yyyy"
        dateTF.text = dateFormater.string(from: date)
        
        viewModel.income = TransactionType.income.bool
        tTypeTF.text = TransactionType.income.rawValue
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
        viewModel.income = TransactionType.allCases[row].bool
        view.endEditing(true)
    }
}


extension AddTransactionVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let setup = textFieldService.setupTF(textField: textField, string: string)
        return setup.shouldChangeCharactersIn
    }
}
