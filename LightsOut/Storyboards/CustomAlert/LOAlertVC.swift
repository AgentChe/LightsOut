//
//  LOAlertVC.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 6.06.2022.
//

import UIKit

class LOAlertVC: UIViewController {

    var alertTitle: String?
    var alertMessage: String?
    
    @IBOutlet var boxView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var actionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        boxView.layer.cornerRadius = 10
        titleLabel.text = alertTitle
        messageLabel.text = alertMessage
    }
    
    
    @IBAction func actionButtonAction(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    

}
