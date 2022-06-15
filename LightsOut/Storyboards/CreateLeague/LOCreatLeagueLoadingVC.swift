//
//  LOCreatLeagueLoadingVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class LOCreatLeagueLoadingVC: UIViewController {
    
    var leagueName: String?
    var leaguePassword: String?
    var leagueOwnerUid: String?
    var leagueId: Int?
    
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createLeague()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondView = segue.destination as! LOCreatLeagueConfirmationVC
        guard let leaguePassword = leaguePassword else { return }
        secondView.password = Int(leaguePassword)
        secondView.leagueID = leagueId
    }
    
    func createLeague() {
        guard let leagueName = leagueName else { return }
        guard let leaguePassword = leaguePassword else { return }
        guard let leagueOwnerUid = leagueOwnerUid else { return }
        guard let leagueId = leagueId else { return }
        let passwordInt = Int(leaguePassword) ?? 1111
        
        
        let placeHolderRecord = OnlineRecordModel(userUid: leagueOwnerUid, timeStamp: 0.0, recordTime: "", recordUid: "placeHolderRecord")
        let recordsInLeague = [placeHolderRecord]
        let newLeague = LeagueModel(leagueId: leagueId, leagueName: leagueName, leaguePassword: passwordInt, creatorUid: leagueOwnerUid, participantCount: 1, participantsUids: [leagueOwnerUid], recordsInLeagues: recordsInLeague)
        
        FirebaseManager.shared.createLeagueToFirebase(league: newLeague) { result in
            let destVC = UIStoryboard(name: "LOCreateLagueStoryboard", bundle: nil).instantiateViewController(withIdentifier: "LOCreatLeagueConfirmation") as! LOCreatLeagueConfirmationVC
            destVC.modalPresentationStyle = .overFullScreen
            destVC.modalTransitionStyle = .crossDissolve
            
            switch result {
                
            case .success(let leagueDetails):
                destVC.leagueID = leagueDetails.leagueId
                destVC.password = leagueDetails.leaguePassword
                self.present(destVC, animated: true)
            case .failure(let error):
                self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
            }
        }

    }
    
    
}
