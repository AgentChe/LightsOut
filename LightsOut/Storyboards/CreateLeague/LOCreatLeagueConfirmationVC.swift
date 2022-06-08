//
//  LOCreatLeagueConfirmationVC.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 3.06.2022.
//

import UIKit

class LOCreatLeagueConfirmationVC: UIViewController {

    @IBOutlet var boxView: UIView!
    @IBOutlet var okButton: UIButton!
    @IBOutlet var idLabel: UILabel!
    
    @IBOutlet var passwordLabel: UILabel!
    var leagueID: Int?
    var password: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let leagueID = leagueID, let password = password {
            idLabel.text = String(leagueID)
            passwordLabel.text = "Password: \(password)"
        }
    
       
        boxView.layer.cornerRadius = 10
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        
    }
    
    @IBAction func okButtonAction(_ sender: UIButton) {
        let name = Notification.Name(rawValue: Constants.createLeagueNotificationKey)
        NotificationCenter.default.post(name: name, object: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
}
