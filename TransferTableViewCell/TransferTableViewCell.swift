//
//  TransferTableViewCell.swift
//  CashStash
//
//  Created by Dmitry Kononov on 8.05.22.
//

import UIKit

class TransferTableViewCell: UITableViewCell {

    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    let cellHeight: CGFloat = 50
    
    func setupCell(wallet: WalletEntity, transferDirection: String) {
        guard let walletName = wallet.walletName else {return}
        walletNameLabel.text = transferDirection + walletName
        amountLabel.text = wallet.amount.formatNumber()
    }
    
}
