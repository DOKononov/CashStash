//
//  ViewController.swift
//  CashStash
//
//  Created by Dmitry Kononov on 1.04.22.
//

import UIKit

final class StashVC: UIViewController {

    @IBOutlet weak var totalAmountLabel: UILabel!
    private var viewModel: StashViewModelProtocol = StashViewModel()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerStashCell()
        bind()
        viewModel.loadWalletsEntities()
        setupNavigationItem()
        viewModel.updateTotalAmount()
        setTransferButtonStatus()
    }

    private func registerStashCell() {
        let cellNib = UINib(nibName: "\(StashTableViewCell.self)", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "\(StashTableViewCell.self)")
    }
    
    private func bind() {
        viewModel.didChangeContent = {
            self.tableView.reloadData()
            self.totalAmountLabel.text = self.viewModel.totalAmount.formatNumber() + " USD"
            self.setTransferButtonStatus()
        }
    }

    private func setTransferButtonStatus() {
        guard let transferButton = self.navigationItem.rightBarButtonItems?.last else {return}
        if self.viewModel.wallets.count > 1 {
            transferButton.isEnabled = true
        } else {
            transferButton.isEnabled = false
        }
    }
}


extension StashVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(StashTableViewCell.self)", for: indexPath) as? StashTableViewCell
        cell?.setup(wallet: viewModel.wallets[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let walleteHistoryVC = WalletHistoryVC(nibName: "\(WalletHistoryVC.self)", bundle: nil)
        walleteHistoryVC.viewModel.wallet = viewModel.wallets[indexPath.row]
        navigationController?.pushViewController(walleteHistoryVC, animated: true)
        
    }
    
    //MARK: -delete entity
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    viewModel.deleteWallet(indexPath: indexPath)
    }
}

// MARK: - BarButton
extension StashVC {
    private func setupNavigationItem() {
        let newWalletButton = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action:  #selector(addNewWallet))

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(refreshTotal))
        let transferButton = UIBarButtonItem(image: UIImage(systemName: "repeat"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(transferButtonDidPressed))
        
        navigationItem.rightBarButtonItems = [newWalletButton, transferButton]
    }
    
    @objc private func addNewWallet() {
        let currencyPage = AddWalletVC(nibName: "\(AddWalletVC.self)", bundle: nil)
        present(currencyPage, animated: true)
    }
    
    @objc private func refreshTotal() {
        viewModel.updateTotalAmount()
    }
    
    @objc private func transferButtonDidPressed() {
        let nextNC = TransferNC(nibName: "\(TransferNC.self)", bundle: nil)
        nextNC.wallets = viewModel.wallets
        present(nextNC, animated: true)
    }
}
