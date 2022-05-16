//
//  TransactionCell.swift
//  CashStash
//
//  Created by Dmitry Kononov on 23.04.22.
//

import UIKit

class TransactionCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    

    func setup(transaction: TransactionEntity) {
        if  transaction.income {
            amountLabel.text = "+" + transaction.amount.formatNumber()
            amountLabel.textColor = .green
            currencyLabel.textColor = .green
        } else {
            amountLabel.text = "-" + transaction.amount.formatNumber()
            amountLabel.textColor = .red
            currencyLabel.textColor = .red
        }
        currencyLabel.text = transaction.wallet?.currency
        descriptionLabel.text = transaction.tDescription
        if let date = transaction.date {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd.MM.yyyy"
            dateLabel.text = dateFormater.string(from: date)
        }

    }
}
