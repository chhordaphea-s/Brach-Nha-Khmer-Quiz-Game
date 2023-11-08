//
//  StoreKitHelper.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/28/23.
//

import Foundation
import StoreKit

protocol StoreKitHelperDelegate: NSObjectProtocol {
    func productRequest(response: SKProductsResponse)
    func paymentTransactionObserver(transaction: SKPaymentTransaction, transactionState: SKPaymentTransactionState)
    
}

class StoreKitHelper: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    static let shared = StoreKitHelper()
    
    weak var delegate: StoreKitHelperDelegate?
    
    var products = [SKProduct]()
        

    func fetchProduct() {
        SKPaymentQueue.default().add(self)

        let request = SKProductsRequest(productIdentifiers: Set(Product.allCases.compactMap({ $0.rawValue })))
        request.delegate = self
        request.start()
    }

    // MARK: Delegate
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.sync {
            self.products = response.products
            delegate?.productRequest(response: response)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({
            delegate?.paymentTransactionObserver(transaction: $0, transactionState: $0.transactionState)
            
        })
    }
}
