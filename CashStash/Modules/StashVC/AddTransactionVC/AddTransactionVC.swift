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

class AddTransactionVC: UIViewController {
    
    
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var descriptionTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var tTypeTF: UITextField!
    
    var viewModel: AddTransactionProtocol = AddTransactionViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTypePicker()
        setupDatePicker()
    }
    
    @IBAction func saveDidTapped(_ sender: UIButton) {
        
        guard dateTF.hasText, descriptionTF.hasText, amountTF.hasText, tTypeTF.hasText else {return}
        
        guard let amount = amountTF.text,
              let description = descriptionTF.text else {return}
        
        viewModel.transactionComponents.amount = amount.double()
        viewModel.transactionComponents.tDescription = description
        viewModel.saveDidTaped()
        
        viewModel.delegate?.updateWalleteAmount()
        self.dismiss(animated: true)
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
        viewModel.transactionComponents.date = sender.date
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
        viewModel.transactionComponents.income = TransactionType.allCases[row].bool
        view.endEditing(true)
    }
}
