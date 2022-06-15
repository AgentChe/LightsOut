//
//  GetProVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class GetProVC: UIViewController {

    @IBOutlet var closeButton: UIButton!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var restoreButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPManager.shared.delegate = self
        configureViewElements()
    }
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func buyButton(_ sender: UIButton) {
        IAPManager.shared.buyAdsFree()
    }
    
    @IBAction func restoreButton(_ sender: UIButton) {
        IAPManager.shared.restore()
    }
    
    func configureViewElements() {
        guard let product = IAPManager.shared.product else {
            presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: LocalizedErrorMessages.unableToComplete)
            return
        }
        
        let price = "\(product.priceLocale.currencySymbol!) \(product.price)"
        buyButton.layer.cornerRadius = 10
        buyButton.setTitle(price, for: .normal)
        logoImageView.layer.cornerRadius = 15
        
    }
}

extension GetProVC: IAPManagerDelegate {
    func restoreDidSucceed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func purchaseDidSucceed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didReceiveError(_ errorType: PaymentErrors) {
        switch errorType {
        case .cantMakePayment:
            presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: LocalizedErrorMessages.cantMakePayment)
        case .loadError:
            presentAlertWithOk(title:
            LocalizedErrorMessages.somethingWentWrong, message: LocalizedErrorMessages.cantLoadProduct)
        case .paymentError:
            presentAlertWithOk(title:
            LocalizedErrorMessages.somethingWentWrong, message: LocalizedErrorMessages.cantBuyAdsFree)
        case .restoreError:
            presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: LocalizedErrorMessages.cantRestore)
        }
    
    }
}
