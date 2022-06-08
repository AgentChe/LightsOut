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
    @IBOutlet var descriptionLabel: UITextView!
    
    @IBOutlet var buyButton: UIButton!
    @IBOutlet var restoreButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        IAPManager.shared.delegate = self
        logoImageView.layer.cornerRadius = 10
        descriptionLabel.text = "Add-free experience\nUnlimited life\nAccess Friend Leagues"
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
            print("DEBUG: cantmakepayment")
        case .loadError:
         print("DEBUG: Cant load product")
        case .paymentError:
            print("DEBUG: payment error")
        case .restoreError:
          print("DEBUG: restore error")
        }
    
    }
}
