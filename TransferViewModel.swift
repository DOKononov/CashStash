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
    var topWallet: WalletEntity? { get set }
    var botWallet: WalletEntity? { get set }
    func setupTextField(textField: UITextField, string: String) -> Bool
}

final class TransferViewModel: TransferViewModelProtocol {
    
    var wallets: [WalletEntity] = [] {
        didSet {
            topWallet = wallets[0]
            botWallet = wallets[1]
        }
    }
    
    var topWallet: WalletEntity?
    var botWallet: WalletEntity?
    
    private var decimalFlag = false
    private var decimalCounter = 0
    var bufferNumber = 0.0
    
    func setupTextField(textField: UITextField, string: String) -> Bool {
        if let text = textField.text {
            //only one dot
            let countDots = text.components(separatedBy: ".").count - 1
            if countDots > 0 && string == "." {
                print("only one dot")
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
                
                //setNumber
                setNumber(textField: textField)
                
                return false
            } else {
                if decimalCounter == 0 {
                    decimalFlag = false
                }
                textField.text = text.double().formatNumber()
                
                //setNumber
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
                
                //setNumber
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
                
                //setNumber
                setNumber(textField: textField)
                
                return false
            }
        }
        
        return true
    }
    
    private func setNumber(textField: UITextField) {
        if let number = textField.text?.double() {
            bufferNumber = number
        }
    }
}
