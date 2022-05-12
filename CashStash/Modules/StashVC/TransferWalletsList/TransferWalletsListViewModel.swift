//
//  TransferWalletsListViewModel.swift
//  CashStash
//
//  Created by Dmitry Kononov on 8.05.22.
//

import Foundation

protocol TransferWalletsListViewModelProtocol {
    var wallets: [WalletEntity] { get set }
    var transferDirection: TransferDirection? { get set }
    var delegate: TransferWalletsListProtocol? { get set }
}

final class TransferWalletsListViewModel: TransferWalletsListViewModelProtocol {
    
    var wallets: [WalletEntity] = []
    var transferDirection: TransferDirection?
    var delegate: TransferWalletsListProtocol?
}
