//
//  TextFieldService.swift
//  CashStash
//
//  Created by Dmitry Kononov on 19.05.22.
//

import UIKit

class TextFieldService {
    
    private var decimalFlag = false
    private var decimalCounter = 0.0
    private var bufferNumber = 0.0
    
    func setupTF(textField: UITextField, string: String) -> (shouldChangeCharactersIn: Bool, numberToReturn: Double?) {
        
        //only one dot
        if let text = textField.text {
            if text.contains(".") && string == "." {
                return (false, nil)
            }
        }
        //text -= string
        if string.isEmpty, var text = textField.text, text != "0" {
            text.removeLast()
            if decimalFlag && decimalCounter > 0 {
                decimalCounter -= 1
            }
            if text.last == "." {
                decimalFlag = true
                textField.text = text.double().formatNumber() + "."
                return (false, setNumber(textField: textField))
            } else {
                if decimalCounter == 0 {
                    decimalFlag = false
                }
                textField.text = text.double().formatNumber()
                return (false, setNumber(textField: textField))
            }
        }
        guard decimalCounter < 2 else {return (false, nil)}
        guard Double(string) != nil || string == "," || string == "." else {return (false, nil)}
        
        if let text = textField.text {
            //max chars
            if text.count > 13  && !string.isEmpty {
                return (false, nil)
            }
            //change comma for dot
            if string == "," || string == "."{
                decimalFlag = true
                textField.text = text + "."
                return (false, setNumber(textField: textField))
            }
            //text += string
            if Double(string) != nil && decimalCounter < 2{
                if decimalFlag {
                    decimalCounter += 1
                }
                textField.text =  (text + string).double().formatNumber()
                return (false, setNumber(textField: textField))
            }
        }
        return (true, nil)
    }
    
    private func setNumber(textField: UITextField) -> Double? {
        if let number = textField.text?.double() {
            return number
        }
        return nil
    }
}

