//
//  walletHistoryVC.swift
//  CashStash
//
//  Created by Dmitry Kononov on 19.04.22.
//

import UIKit



final class WalletHistoryVC: UIViewController, WalletHistoryDelegate {
    func updateWalleteAmount() {
        setupWalletInfo()
    }
    

    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    
    var viewModel: WalletHistoryProtocol = WalletHistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWalletInfo()
        setupNavigationItem()
        bind()
        viewModel.loadTransactions()
        registerCell()
    }
    
    
    private func bind() {
        viewModel.contentDidChanged = {
            self.tableView.reloadData()
        }
    }
    
    private func setupWalletInfo() {
        walletNameLabel.text = viewModel.wallet?.walletName
        guard let currency = viewModel.wallet?.currency,
        let amount = viewModel.wallet?.amount.formatNumber() else {return}
        amountLabel.text = amount + " " + currency
    }
    
    private func registerCell() {
        let cellNib = UINib(nibName: "\(TransactionCell.self)", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "\(TransactionCell.self)")
    }
    
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addNewTransaction))
    }
    
    @objc func addNewTransaction() {
        let addTransactionsVC = AddTransactionVC(nibName: "\(AddTransactionVC.self)", bundle: nil)
        addTransactionsVC.viewModel.wallet = viewModel.wallet
        addTransactionsVC.viewModel.delegate = self
        present(addTransactionsVC, animated: true)
    }

}


extension WalletHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TransactionCell.self)", for: indexPath) as? TransactionCell
        cell?.setup(transaction: viewModel.transactions[indexPath.row])
        return cell ?? UITableViewCell()
    }
}
