//
//  ExcangeModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 1.04.22.
//

import Foundation


class ExcangeModel: Codable {
    let baseCurrencyCode: String
    let baseCurrencyName: String
    let amount: String
    let updatedDate: String
    let rates: [String: Rate]
    let status: String

    enum CodingKeys: String, CodingKey {
        case baseCurrencyCode = "base_currency_code"
        case baseCurrencyName = "base_currency_name"
        case amount
        case updatedDate = "updated_date"
        case rates
        case status
    }
}


class Rate: Codable {
    let currencyName: String
    let rate: String
    let rateForAmount: String

    enum CodingKeys: String, CodingKey {
        case currencyName = "currency_name"
        case rate
        case rateForAmount = "rate_for_amount"
    }
}
