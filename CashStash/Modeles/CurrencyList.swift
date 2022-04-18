//
//  CurrencyList.swift
//  CashStash
//
//  Created by Dmitry Kononov on 3.04.22.
//

import Foundation

enum CurrencyList: String, CaseIterable {
    case EUR = "EUR"
    case USD = "USD"
    case BYN = "BYN"
    case RUB = "RUB"
}


//class Currency {
//    let name: String
//    let code: String
//    let country: String
//
//    init(code: String, name: String, country: String) {
//        self.name = name
//        self.code = code
//        self.country = country
//    }
//}
//
//struct CurrencyLists {
//    var list: [Currency] = [
//        Currency(code: "EUR", name: "Euro", country: "Europe"),
//        Currency(code: "USD", name: "United States dollar", country: "United States")),
//    ]
//}
