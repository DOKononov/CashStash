//
//  TransferViewModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 8.05.22.
//

import Foundation
import UIKit

protocol TransferViewModelProtocol {
    var wallets: [WalletEntity] { get set }
    var walletsModels: [WalletModel]  { get set }
    var topTFEditing: Bool? { get set }
    var conversionRate: Double { get set }
    var bufferNumberDidChanged: (() -> Void)? { get set }
    func saveButtonDidTapped()
    func updateUIAfterEditingTF(textfield: UITextField)
    func setupTextField(textField: UITextField, string: String) -> Bool
}

final class TransferViewModel: TransferViewModelProtocol {
 
    var topTFEditing: Bool?
    var conversionRate = 0.0
    lazy var textFieldService = TextFieldService()
    
    var bufferNumberDidChanged: (() -> Void)?
    private var bufferNumber = 0.0 { didSet { bufferNumberDidChanged?() } }
    var wallets: [WalletEntity] = [] {
        didSet {
            getRateForWallets()
            convertEntityToModel()
        }
    }
    var walletsModels: [WalletModel] = []
    private lazy var networkService = NetworkService()
    
    private var topWalletDefaultAmount = 0.0
    private var botWalletDefaultAmount = 0.0
    
    private var topTransferAmount = 0.0 {
        didSet {
            print("topTransferAmount ", topTransferAmount)
        }
    }
    private var botTransferAmount = 0.0
    
    
    //funcs
    func updateUIAfterEditingTF(textfield: UITextField) {
        guard let topTFEditing = topTFEditing else {return}
        if topTFEditing {
            topTransferAmount = bufferNumber
            botTransferAmount = bufferNumber * conversionRate
            textfield.text = botTransferAmount.formatNumber()
            walletsModels[0].amount = topWalletDefaultAmount - bufferNumber
            walletsModels[1].amount = botWalletDefaultAmount + bufferNumber * conversionRate
            
        } else {
            topTransferAmount = bufferNumber / conversionRate
            botTransferAmount = bufferNumber
            textfield.text = topTransferAmount.formatNumber()
            walletsModels[0].amount = topWalletDefaultAmount - bufferNumber
            walletsModels[1].amount = botWalletDefaultAmount + bufferNumber * conversionRate
        }
    }
    
    func saveButtonDidTapped() {
        
        createNewTransaction(fromWallet: wallets[0],
                             forTop: true,
                             otherWallet: wallets[1])
        
        createNewTransaction(fromWallet: wallets[1],
                             forTop: false,
                             otherWallet: wallets[0])
    }
    
    private func createNewTransaction(fromWallet: WalletEntity, forTop: Bool, otherWallet: WalletEntity) {
        guard let topTFEditing = topTFEditing else { return }

        guard let otherWallet = otherWallet.walletName else { return }
        let newTransaction = TransactionEntity(context: CoreDataService.shared.managedObjectContext)
        newTransaction.date = Date()
        newTransaction.income = !forTop
        
        topTFEditing ?
        (newTransaction.amount = topTransferAmount) :
        (newTransaction.amount = botTransferAmount)
        
        newTransaction.tDescription = "transfer with " + otherWallet
        newTransaction.wallet = fromWallet
        fromWallet.addTransaction(newTransaction)
        CoreDataService.shared.saveContext()
    }
    
    private func getRateForWallets() {
        if let topCurrency = wallets[0].currency, let botCurrency = wallets[1].currency {
            networkService.getRate(topCurrency, to: botCurrency) { rate in
                self.conversionRate = rate
            }
        }
    }
    
    private func convertEntityToModel() {
        var tempArray: [WalletModel] = []
        wallets.forEach { tempArray.append(WalletModel(walletEntity: $0)) }
        walletsModels = tempArray
        topWalletDefaultAmount = walletsModels[0].amount
        botWalletDefaultAmount = walletsModels[1].amount
    }
}

//setupTextField
extension TransferViewModel {
    func setupTextField(textField: UITextField, string: String) -> Bool {
        
       let result =  textFieldService.setupTF(textField: textField, string: string)
        
        if let responceNumber = result.numberToReturn {
            bufferNumber = responceNumber
        }
        return result.shouldChangeCharactersIn
    }
}
