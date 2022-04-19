//
//  StashTableViewCell.swift
//  CashStash
//
//  Created by Dmitry Kononov on 3.04.22.
//

import UIKit

class StashTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var amountUSDLabel: UILabel!
    
    func setup(wallet: Wallet) {
        rateLabel.text = "rate: " + wallet.rate.string()
        walletNameLabel.text = wallet.name
        amountLabel.text = wallet.amount.formatNumber()
        currencyLabel.text = wallet.currency
        amountUSDLabel.text = wallet.amountUSD.formatNumber()
    }
}
