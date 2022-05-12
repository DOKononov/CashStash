//
//  TransferNC.swift
//  CashStash
//
//  Created by Dmitry Kononov on 8.05.22.
//

import UIKit

class TransferNC: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transferVC = TransferVC(nibName: "\(TransferVC.self)", bundle: nil)
        transferVC.viewModel.wallets = wallets
        pushViewController(transferVC, animated: true)
        
    }
    var wallets: [WalletEntity] = []
    
    
}
