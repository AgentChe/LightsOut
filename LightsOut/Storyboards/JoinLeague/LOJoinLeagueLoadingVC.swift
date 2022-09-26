//
//  LOJoinLeagueLoadingVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class LOJoinLeagueLoadingVC: UIViewController {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var userUid: String?
    var leagueNumber: String?
    var leaguePassword: String?
    
    var alertMessage = ""
    var alertTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        joinLeague()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
    }
    
    func joinLeague() {
        guard let leagueNumber = leagueNumber else {
            return
        }
        guard let leaguePassword = leaguePassword else {
            return
        }
        guard let userUid = userUid else {
            return
        }

        FirebaseManager.shared.joinLeague(leagueNumber: leagueNumber, leaguePassword: leaguePassword, userUid: userUid) { [weak self] error in
            guard let self = self else { return }
            if error != nil {
                self.alertTitle = LocalizedErrorMessages.somethingWentWrong
                self.alertMessage = LocalizedErrorMessages.cantJoinLeague
                self.performSegue(withIdentifier: Constants.Segues.goToAlert, sender: self)
            } else {
                self.performSegue(withIdentifier: Constants.Segues.goToConfirmation, sender: self)
                
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.goToAlert{
              let secondView = segue.destination as! LOAlertVC
            secondView.alertTitle = alertTitle
            secondView.alertMessage = alertMessage
        } else if segue.identifier == Constants.Segues.goToConfirmation {
            let secondView = segue.destination as! LOJoinLeagueConfirmationVC
            secondView.leagueNumber = leagueNumber
        }
    }
    


}
