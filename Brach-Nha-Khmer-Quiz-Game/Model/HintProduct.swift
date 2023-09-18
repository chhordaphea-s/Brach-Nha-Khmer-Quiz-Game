//
//  HintProduct.swift
//  Brach-Nha-Khmer-Quiz-Game
//
//  Created by Aing Hongsin on 9/17/23.
//

import Foundation
import StoreKit


struct HintProduct {
    private let product: SKProduct
    private let title: String?
    private let hintType: HintType?
    private let amount: Int?
    private let price: Float?
    
    init(product: SKProduct, title: String? = nil, hintType: HintType? = nil, amount: Int? = nil, price: Float? = nil) {
        self.product = product
        self.title = title
        self.hintType = hintType
        self.amount = amount
        self.price = price
    }
    
    func getProduct() -> SKProduct {
        return self.product
    }
    
    func getHintType() -> HintType? {
        
        if Constant.product.productID.answerProductsID.contains(self.product.productIdentifier) {
            return .answer
        } else if Constant.product.productID.halfProductsID.contains(self.product.productIdentifier) {
            return .halfhalf
        }
        return nil
    }
    
    func getAmount() -> Int {
        switch self.product.productIdentifier {
        case Product.answerHint1x.rawValue:
            return 1
        case Product.answerHint3x.rawValue:
            return 3
        case Product.answerHint9x.rawValue:
            return 9
        case Product.answerHint20x.rawValue:
            return 20
        case Product.halfHint1x.rawValue:
            return 1
        case Product.halfHint3x.rawValue:
            return 3
        case Product.halfHint9x.rawValue:
            return 9
        case Product.halfHint20x.rawValue:
            return 20
        default:
            return 0
        }
        
    }
    
    func getTitle() -> String {
        let type = getHintType()
        return type?.rawValue ?? ""
    }
    
    func getPrice() -> Float {
        return Float(truncating: self.product.price)
    }
    
    func isFree() -> Bool {
        return Float(truncating: self.product.price) == 0
    }
    
    func getHintView() -> HintView {
        return HintView(hinType: self.getHintType() ?? .answer, number: self.getAmount())
    }
    
}
