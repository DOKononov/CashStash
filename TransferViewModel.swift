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
    var bufferNumber: Double { get set }
    var conversionRate: Double { get set }
    var bufferNumberDidChanged: (() -> Void)? { get set }
    func updateUIAfterEditingTF(textfield: UITextField)
    func setupTextField(textField: UITextField, string: String) -> Bool
}

final class TransferViewModel: TransferViewModelProtocol {
 
    var topTFEditing: Bool?
    var conversionRate = 0.0

    private var decimalFlag = false
    private var decimalCounter = 0.0
    
    var bufferNumberDidChanged: (() -> Void)?
    var bufferNumber = 0.0 { didSet { bufferNumberDidChanged?() } }
    var wallets: [WalletEntity] = [] {
        didSet {
            getRateForWallets()
            convertEntityToModel()
        }
    }
    var walletsModels: [WalletModel] = []
    
    private var topWalletDefaultAmount = 0.0 
    private var botWalletDefaultAmount = 0.0
    
    
    //funcs
    func updateUIAfterEditingTF(textfield: UITextField) {
        guard let topTFEditing = topTFEditing else {return}
        if topTFEditing {
            textfield.text = (bufferNumber * conversionRate).formatNumber()
            walletsModels[0].amount = topWalletDefaultAmount - bufferNumber
            walletsModels[1].amount = botWalletDefaultAmount + bufferNumber * conversionRate
        } else {
            textfield.text = (bufferNumber / conversionRate).formatNumber()
            walletsModels[0].amount = topWalletDefaultAmount - bufferNumber
            walletsModels[1].amount = botWalletDefaultAmount + bufferNumber * conversionRate
        }
    }
    
    private func setNumber(textField: UITextField) {
        if let number = textField.text?.double() {
            bufferNumber = number
        }
    }
    
    private func getRateForWallets() {
        if let topCurrency = wallets[0].currency, let botCurrency = wallets[1].currency {
            NetworkService().getRate(topCurrency, to: botCurrency) { rate in
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
        //only one dot
        if let text = textField.text {
            if text.contains(".") && string == "." {
                return false
            }
        }
        //text -= string
        if string.isEmpty, var text = textField.text, text != "0" {
            print("text -= string")
            text.removeLast()
            if decimalFlag && decimalCounter > 0 {
                decimalCounter -= 1
            }
            if text.last == "." {
                decimalFlag = true
                textField.text = text.double().formatNumber() + "."
                setNumber(textField: textField)
                return false
            } else {
                if decimalCounter == 0 {
                    decimalFlag = false
                }
                textField.text = text.double().formatNumber()
                setNumber(textField: textField)
                return false
            }
        }
        guard decimalCounter < 2 else {return false}
        if let text = textField.text {
            //max chars
            if text.count > 13  && !string.isEmpty {
                print("max chars")
                return false
            }
            //change comma for dot
            if string == "," || string == "."{
                print("change comma for dot")
                decimalFlag = true
                textField.text = text + "."
                setNumber(textField: textField)
                return false
            }
            //text += string
            if Double(string) != nil && decimalCounter < 2{
                print("text += string")
                if decimalFlag {
                    decimalCounter += 1
                }
                textField.text =  (text + string).double().formatNumber()
                setNumber(textField: textField)
                return false
            }
        }
        return true
    }
}
