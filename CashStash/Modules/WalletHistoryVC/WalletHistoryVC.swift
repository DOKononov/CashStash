//
//  walletHistoryVC.swift
//  CashStash
//
//  Created by Dmitry Kononov on 19.04.22.
//

import UIKit

protocol WalletHistoryDelegate {
    func updateWalletInfo()
}

final class WalletHistoryVC: UIViewController {
    
    @IBOutlet private weak var walletNameLabel: UILabel!
    @IBOutlet private weak var amountLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var viewModel: WalletHistoryProtocol = WalletHistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWalletInfo()
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
    
    private func registerCell() {
        let cellNib = UINib(nibName: "\(TransactionCell.self)", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "\(TransactionCell.self)")
    }
    
    //navigationItems/berButtons
    private func setupNavigationItem() {
        let addTransactionButtom = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addNewTransaction))
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gear"),
                                             style: .plain,
                                             target: self,
                                             action: #selector(settingsDidPressed))
        navigationItem.rightBarButtonItems = [addTransactionButtom, settingsButton]
    }
    
    @objc private func addNewTransaction() {
        let addTransactionsVC = AddTransactionVC(nibName: "\(AddTransactionVC.self)", bundle: nil)
        addTransactionsVC.viewModel.wallet = viewModel.wallet
        addTransactionsVC.viewModel.delegate = self
        present(addTransactionsVC, animated: true)
    }
    
    @objc private func settingsDidPressed() {
        viewModel.settingsButtonDidTapped(viewController: self) {
            self.updateWalletInfo()
        }
        updateWalletInfo()
    }
}

//MARK: tableView
extension WalletHistoryVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TransactionCell.self)", for: indexPath) as? TransactionCell
        cell?.setup(transaction: viewModel.transactions[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    //MARK: edite existing transaction
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let editeVC = AddTransactionVC(nibName: "\(AddTransactionVC.self)", bundle: nil)
        
        editeVC.viewModel.myTransaction = viewModel.transactions[indexPath.row]
        editeVC.viewModel.wallet = viewModel.wallet
        editeVC.viewModel.delegate = self
        self.navigationController?.pushViewController(editeVC, animated: true)
    }
    
    //MARK: delete transaction
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteTransaction = UIContextualAction(style: .destructive,
                                                   title: "Delete") { _, _, _ in
            self.viewModel.deleteTransaction(indexPath: indexPath) {
                self.updateWalletInfo()
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteTransaction])
    }
}

//MARK: delegate
extension WalletHistoryVC: WalletHistoryDelegate {
    func updateWalletInfo() {
        viewModel.loadWallet()
        walletNameLabel.text = viewModel.wallet?.walletName
        guard let currency = viewModel.wallet?.currency,
              let amount = viewModel.wallet?.amount.formatNumber() else {return}
        amountLabel.text = amount + " " + currency
    }
    
    
}
