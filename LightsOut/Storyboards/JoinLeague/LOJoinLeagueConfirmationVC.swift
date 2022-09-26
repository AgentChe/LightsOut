//
//  LOJoinLeagueConfirmationVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class LOJoinLeagueConfirmationVC: UIViewController {
    
    @IBOutlet var boxView: UIView!
    var leagueNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boxView.layer.cornerRadius = 10
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
    }
    
    @IBAction func goLeagueButtonAction(_ sender: UIButton) {
        guard let leagueNumber = leagueNumber else { return }
        guard let leagueId = Int(leagueNumber) else { return }
        FirebaseManager.shared.getLeagueDetails(leagueId: leagueId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let league):
                self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                    let goLeagueName = Notification.Name(rawValue: Constants.NotificationKeys.goLeagueNotificationKey)
                    NotificationCenter.default.post(name: goLeagueName, object: league)
                    let joinLeagueName = Notification.Name(rawValue: Constants.NotificationKeys.updateLeagueInfo)
                    NotificationCenter.default.post(name: joinLeagueName, object: nil)

                })
            case .failure(_):
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }


    }
    
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        let name = Notification.Name(rawValue: Constants.NotificationKeys.updateLeagueInfo)
        NotificationCenter.default.post(name: name, object: nil)
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }

    

}
