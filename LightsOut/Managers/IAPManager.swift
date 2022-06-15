//
//  IAPManager.swift
//  LightsOut
//
//  Created by Murat Baykor on 2.05.2021.
//  Copyright © 2021 Murat Baykor. All rights reserved.
//

import Foundation
import StoreKit

protocol IAPManagerDelegate: AnyObject {
    func restoreDidSucceed()
    func purchaseDidSucceed()
    func didReceiveError(_ errorType: PaymentErrors)
}

class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = IAPManager()
    
    private var products = [SKProduct]()
    private var productBeingPurchased: SKProduct?
    
    weak var delegate: IAPManagerDelegate?
    
    var product: SKProduct?
    //Fetch Product From Apple
    public func fetchProduct() {
        let request = SKProductsRequest(productIdentifiers: ["com.foytingo.pro"])
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        
        guard let product = products.first else {
            return
        }
        self.product = product
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        guard request is SKProductsRequest else {
            return
        }
        DispatchQueue.main.async {
            self.delegate?.didReceiveError(.loadError)
        }
    }
    
    public func buyAdsFree() {
        guard let product = product else { return }
        purchase(product: product)
    }
    
    public func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    //Promt a product payment transaction
    
    private func purchase(product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            DispatchQueue.main.async {
                self.delegate?.didReceiveError(.cantMakePayment)
            }
            return
        }
        
        productBeingPurchased = product
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    //Observe the transaction State
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach({ transaction in
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                handlePurchase(transaction)
                break
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.delegate?.didReceiveError(.paymentError)
                }
                break
            case .restored:
                handleRestore(transaction)
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        })
    }
    
    private func handlePurchase(_ transaction: SKPaymentTransaction) {
        guard let productBeingPurchasedID = productBeingPurchased?.productIdentifier else {
            DispatchQueue.main.async {
                self.delegate?.didReceiveError(.paymentError)
            }
            return
        }
        if transaction.payment.productIdentifier == productBeingPurchasedID {
            UserDefaults.standard.set(true, forKey: Constants.Keys.getPro)
            
            DispatchQueue.main.async {
                self.delegate?.purchaseDidSucceed()
            }
        } else {
            DispatchQueue.main.async {
                self.delegate?.didReceiveError(.paymentError)
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func handleRestore(_ transaction: SKPaymentTransaction) {
        UserDefaults.standard.set(true, forKey: Constants.Keys.getPro)
        SKPaymentQueue.default().finishTransaction(transaction)
        DispatchQueue.main.async {
            self.delegate?.restoreDidSucceed()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        DispatchQueue.main.async {
            self.delegate?.didReceiveError(.restoreError)
        }
    }
}
