//
//  TransferVC.swift
//  CashStash
//
//  Created by Dmitry Kononov on 7.05.22.
//

import UIKit

protocol TransferWalletsListProtocol {
    func chooseNewWallet(direction: TransferDirection, index: Int)
}

enum TransferDirection: Int {
    case from
    case to
}

class TransferVC: UIViewController, TransferWalletsListProtocol {
    
    func chooseNewWallet(direction: TransferDirection, index: Int) {
        switch direction {
        case .from:  viewModel.wallets.swapAt(0, index)
        case .to: viewModel.wallets.swapAt(1, index)
        }
        setupVC()
        tableView.reloadData()
    }
    
    @IBOutlet weak var topAmmountTF: UITextField!
    @IBOutlet weak var botAmountTF: UITextField!
    @IBOutlet weak var topCurrencyLabel: UILabel!
    @IBOutlet weak var botCurrencyLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setupVC()
        topAmmountTF.delegate = self
        botAmountTF.delegate = self
        
    }
    
    var viewModel: TransferViewModelProtocol = TransferViewModel()
    
    private func setupVC() {
        //    TODO: byn, usd... wallets amount
        topCurrencyLabel.text = viewModel.topWallet?.currency
        botCurrencyLabel.text = viewModel.botWallet?.currency
        
    }
    
    @IBAction func saveDidTapped(_ sender: UIButton) {
    }
}

//MARK: tableView
extension TransferVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.wallets.count > 1 {
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TransferTableViewCell.self)", for: indexPath) as? TransferTableViewCell
        
        let transferDirection = TransferDirection(rawValue: indexPath.row)
        switch transferDirection {
        case .from:
            cell?.setupCell(wallet: viewModel.wallets[indexPath.row], transferDirection: "From: ")
            return cell ?? UITableViewCell()
        case .to:
            cell?.setupCell(wallet: viewModel.wallets[indexPath.row], transferDirection: "To: ")
            return cell ?? UITableViewCell()
        case .none:
            return UITableViewCell()
        }
    }
    
    private func registerCell() {
        let cellNib = UINib(nibName: "\(TransferTableViewCell.self)", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "\(TransferTableViewCell.self)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TransferTableViewCell().cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let transferDirection = TransferDirection(rawValue: indexPath.row)
        let nextVC = TransferWalletsList(nibName: "\(TransferWalletsList.self)", bundle: nil)
        nextVC.viewModel.wallets = viewModel.wallets
        nextVC.viewModel.transferDirection = transferDirection
        nextVC.viewModel.delegate = self
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension TransferVC: UISearchTextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == topAmmountTF {
            viewModel.setupTextField(textField: textField, string: string)
        }
        if textField == botAmountTF {
            viewModel.setupTextField(textField: textField, string: string)
        }
       return false
    }
    
    
}
