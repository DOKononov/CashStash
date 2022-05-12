//
//  TransferWalletsList.swift
//  CashStash
//
//  Created by Dmitry Kononov on 8.05.22.
//

import UIKit



class TransferWalletsList: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    var viewModel: TransferWalletsListViewModelProtocol = TransferWalletsListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }

}


extension TransferWalletsList: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TransferWalletsListTableViewCell.self)", for: indexPath) as? TransferWalletsListTableViewCell
        cell?.setupCell(wallet: viewModel.wallets[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    private func registerCell() {
        let cellNib = UINib(nibName: "\(TransferWalletsListTableViewCell.self)", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "\(TransferWalletsListTableViewCell.self)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let  direction = viewModel.transferDirection else {return}
        viewModel.delegate?.chooseNewWallet(direction: direction, index: indexPath.row)
        navigationController?.popViewController(animated: true)
    }
}
