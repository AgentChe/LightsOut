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

        FirebaseManager.shared.joinLeague(leagueNumber: leagueNumber, leaguePassword: leaguePassword, userUid: userUid) { error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                self.alertTitle = "Error"
                self.alertMessage = error.localizedDescription
                self.performSegue(withIdentifier: "goToAlert", sender: self)
            } else {
                print("DEBUG: Successfully joined")
                self.performSegue(withIdentifier: "goToConfirmationJoin", sender: self)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAlert"{
              let secondView = segue.destination as! LOAlertVC
            secondView.alertTitle = alertTitle
            secondView.alertMessage = alertMessage
        }
    }
    


}
