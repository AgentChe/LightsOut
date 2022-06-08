//
//  LOJoinLeagueConfirmationVC.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 6.06.2022.
//

import UIKit

class LOJoinLeagueConfirmationVC: UIViewController {
    
    @IBOutlet var boxView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boxView.layer.cornerRadius = 10
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
    }
    
    @IBAction func goLeagueButtonAction(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: {
            let goLeagueName = Notification.Name(rawValue: Constants.goLeagueNotificationKey)
            NotificationCenter.default.post(name: goLeagueName, object: nil)
            let joinLeagueName = Notification.Name(rawValue: Constants.joinLeagueNotificationKey)
            NotificationCenter.default.post(name: joinLeagueName, object: nil)
            
        })
    }
    
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        let name = Notification.Name(rawValue: Constants.joinLeagueNotificationKey)
        NotificationCenter.default.post(name: name, object: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }

    

}
