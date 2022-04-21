//
//  walletHistoryVC.swift
//  CashStash
//
//  Created by Dmitry Kononov on 19.04.22.
//

import UIKit

final class WalletHistoryVC: UIViewController {

    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: WalletHistoryProtocol = WalletHistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWalletInfo()
        setupNavigationItem()
    }
    
    private func setupWalletInfo() {
        walletNameLabel.text = viewModel.wallet?.name
        guard let currency = viewModel.wallet?.currency,
        let amount = viewModel.wallet?.amount.formatNumber() else {return}
        amountLabel.text = amount + " " + currency
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addNewTransaction))
    }
    
    @objc func addNewTransaction() {
        
    }

}
