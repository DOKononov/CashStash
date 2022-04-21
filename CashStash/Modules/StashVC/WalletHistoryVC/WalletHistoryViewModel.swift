//
//  WalletHistoryViewModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 19.04.22.
//

import Foundation

protocol WalletHistoryProtocol {
    var wallet: Wallet? { get set }
    var transactions: [Transaction] { get set }
}

final class WalletHistoryViewModel: WalletHistoryProtocol {
    var transactions: [Transaction] = []
    var wallet: Wallet?
    
}
