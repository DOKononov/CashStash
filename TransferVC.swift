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

final class TransferVC: UIViewController, TransferWalletsListProtocol {
    
    var viewModel: TransferViewModelProtocol = TransferViewModel()
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
        bind()
    }
    
    //actions
    @IBAction func saveDidTapped(_ sender: UIButton) {
    }
    
    //funcs
    private func bind() {
        viewModel.bufferNumberDidChanged = {
            self.reculcForNewWallets()
        }
    }
    
    private func reculcForNewWallets() {
        if let topTFEditing = self.viewModel.topTFEditing {
            topTFEditing ?
            self.viewModel.updateUIAfterEditingTF(textfield: self.botAmountTF) :
            self.viewModel.updateUIAfterEditingTF(textfield: self.topAmmountTF)
            self.tableView.reloadData()
        }
    }
    
    private func setupVC() {
        topCurrencyLabel.text = viewModel.wallets[0].currency
        botCurrencyLabel.text = viewModel.wallets[1].currency
    }
    
    //delegate
    func chooseNewWallet(direction: TransferDirection, index: Int) {
        switch direction {
        case .from:  viewModel.wallets.swapAt(0, index)
        case .to: viewModel.wallets.swapAt(1, index)
        }
        setupVC()
        reculcForNewWallets()
        tableView.reloadData()
    }
    
}

//tableView
extension TransferVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.wallets.count > 1 else {return 0}
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(TransferTableViewCell.self)", for: indexPath) as? TransferTableViewCell
        let transferDirection = TransferDirection(rawValue: indexPath.row)
        switch transferDirection {
        case .from: cell?.setupCell(wallet: viewModel.walletsModels[indexPath.row], transferDirection: "From: ")
            return cell ?? UITableViewCell()
        case .to: cell?.setupCell(wallet: viewModel.walletsModels[indexPath.row], transferDirection: "To: ")
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
        nextVC.setupVC(wallets: viewModel.wallets, transferDirection: transferDirection, delegate: self)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

//TextFieldDelegate
extension TransferVC: UISearchTextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        viewModel.setupTextField(textField: textField, string: string)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case topAmmountTF : viewModel.topTFEditing = true
        case botAmountTF : viewModel.topTFEditing = false
        default : break
        }
    }
    
    
}
