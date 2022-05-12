//
//  TransferWalletsListTableViewCell.swift
//  CashStash
//
//  Created by Dmitry Kononov on 8.05.22.
//

import UIKit

class TransferWalletsListTableViewCell: UITableViewCell {

    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var walletAmountLabel: UILabel!
    @IBOutlet weak var walletCurrencyLabel: UILabel!
    
    func setupCell(wallet: WalletEntity) {
        walletNameLabel.text = wallet.walletName
        walletAmountLabel.text = wallet.amount.string()
        walletCurrencyLabel.text = wallet.currency
    }
    
}
