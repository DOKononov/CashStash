//
//  ViewController.swift
//  CashStash
//
//  Created by Dmitry Kononov on 1.04.22.
//

import UIKit

class StashVC: UIViewController {

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
    }

    private func registerStashCell() {
        let cellNib = UINib(nibName: "\(StashTableViewCell.self)", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "\(StashTableViewCell.self)")
    }
    
    private func bind() {
        viewModel.didChangeContent = {
            self.tableView.reloadData()
            self.totalAmountLabel.text = self.viewModel.totalAmount.myRound().formatNumber() + " USD"
        }
    }
    
    private func openWalletePage(wallet: Wallet?) {
        let currencyPage = CurrencyPageVC(nibName: "\(CurrencyPageVC.self)", bundle: nil)
        currencyPage.viewModel.selectedWallet = wallet
        present(currencyPage, animated: true)
    }

}


extension StashVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.walletsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(StashTableViewCell.self)", for: indexPath) as? StashTableViewCell
        cell?.setup(wallet: viewModel.walletsList[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        openWalletePage(wallet: viewModel.walletsList[indexPath.row])
    }
    
    //MARK: -delete entity
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    viewModel.deleteWallet(indexPath: indexPath)
    }
}

// MARK: - BarButton
extension StashVC {
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(addNewWallet))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(refreshTotal))
    }
    
    @objc private func addNewWallet() {
        //TODO: -add new wallet
        openWalletePage(wallet: nil)
    }
    
    @objc private func refreshTotal() {
        viewModel.updateTotalAmount()
    }
}
