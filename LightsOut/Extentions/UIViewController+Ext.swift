//
//  UIViewController+Ext.swift
//  LightsOut
//
//  Created by Murat Baykor on 10.06.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func presentAlertWithOk(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.ok, style: .default))
        present(ac, animated: true)
    }
    
    
    func goTo(with identifier: String) {
        let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    func checkUserProStatusAndPresentAlert(status: Bool?, userUid: String) {
        if status == true {
            presentLeagueAlert(userUid: userUid)
        } else {
            presentGetProAlert(userUid: userUid)
        }
    }
    
    
    func presentLeagueAlert(userUid: String) {
        let ac = UIAlertController(title: LocalizedStrings.addLeague, message: LocalizedStrings.addLeagueDesc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.create, style: .default, handler: { action in
            if userUid != "" {
                self.performSegue(withIdentifier: Constants.Segues.goToCreateLeague, sender: self)
            }
        }))
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.join, style: .default,handler: { action in
            if userUid != "" {
                self.performSegue(withIdentifier: Constants.Segues.goToJoinLeague, sender: self)
            }
        }))
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.cancel, style: .cancel))
        present(ac, animated: true)
    }
    
    func presentGetProAlert(userUid: String) {
        let ac = UIAlertController(title: LocalizedAlertboxStrings.getPro, message: LocalizedAlertboxStrings.getProDesc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.getPro, style: .default, handler: { action in
            if userUid != "" {
                self.performSegue(withIdentifier: Constants.Segues.goToGetPro, sender: self)
            }
        }))
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.cancel, style: .cancel))
        present(ac, animated: true)
    }

    func presentQuitAndDeleteAlert(userUid: String, leagueNumber: Int) {
        let ac = UIAlertController(title: LocalizedAlertboxStrings.quitLeague, message: LocalizedAlertboxStrings.quitAndDeleteDesc , preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.quitAndDelete , style: .destructive, handler: { [weak self] action in
            FirebaseManager.shared.exitLeague(userUid: userUid, leagueNumber: leagueNumber, owner: true) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    let leagueWasDeleted = Notification.Name(rawValue: Constants.NotificationKeys.updateLeagueInfo)
                    NotificationCenter.default.post(name: leagueWasDeleted, object: nil)
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)

            }
        }))
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.cancel, style: .cancel))
        present(ac, animated: true)
    }

    func presentQuitAlert(userUid: String, leagueNumber: Int, participantCount: Int) {
        let ac = UIAlertController(title: LocalizedAlertboxStrings.quitLeague, message: LocalizedAlertboxStrings.justQuitDesc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.quit, style: .destructive, handler: { [weak self] action in
            FirebaseManager.shared.exitLeague(userUid: userUid, leagueNumber: leagueNumber, owner: false, participantCount: participantCount) { [weak self] error in
                guard let self = self else { return }
                guard let error = error else {
                    let leagueWasDeleted = Notification.Name(rawValue: Constants.NotificationKeys.updateLeagueInfo)
                    NotificationCenter.default.post(name: leagueWasDeleted, object: nil)
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)

            }
        }))
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.cancel, style: .cancel))
        present(ac, animated: true)
    }

    func presentDeleteRecordsForOwner(userUid: String?, league: LeagueModel?) {
        let ac = UIAlertController(title: LocalizedAlertboxStrings.deleteRecords, message: LocalizedAlertboxStrings.deleteRecordsDescForOwner, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.deleteAll, style: .destructive, handler: { action in
            guard let userUid = userUid else {
                return
            }
            guard let league = league else {
                return
            }
            FirebaseManager.shared.deleteOwnRecordInFriendsLeague(userUid: userUid, leagueNumber: league.leagueId) { [weak self ]error in
                guard let self = self else { return }
                let leagueWasDeleted = Notification.Name(rawValue: Constants.NotificationKeys.deleteActionInfo)
                NotificationCenter.default.post(name: leagueWasDeleted, object: nil)
                if let error = error {
                    self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
                }
            }
        }))
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.deleteOwns, style: .destructive, handler: { [weak self] action in
            guard let self = self else { return }
            guard let league = league else { return }
            FirebaseManager.shared.deleteAllRecordsInFriendsLeague(leagueNumber: league.leagueId) { [weak self] error in
                guard let self = self else { return }
                let leagueWasDeleted = Notification.Name(rawValue: Constants.NotificationKeys.deleteActionInfo)
                NotificationCenter.default.post(name: leagueWasDeleted, object: nil)
                if let error = error {
                    self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
                }
            }
        }))
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.cancel, style: .cancel))
        present(ac, animated: true)
    }
    
    func presentDeleteRecordsForMember(userUid: String?, league: LeagueModel?) {
        let ac = UIAlertController(title: LocalizedAlertboxStrings.deleteRecords, message: LocalizedAlertboxStrings.deleteRecordsDesc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.delete, style: .destructive, handler: { [weak self] action in
            guard let self = self else { return }
            guard let userUid = userUid else { return }
            guard let league = league else { return }
            FirebaseManager.shared.deleteOwnRecordInFriendsLeague(userUid: userUid, leagueNumber: league.leagueId) { [weak self] error in
                guard let self = self else { return }
                let leagueWasDeleted = Notification.Name(rawValue: Constants.NotificationKeys.deleteActionInfo)
                NotificationCenter.default.post(name: leagueWasDeleted, object: nil)
                if let error = error {
                    self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
                }
            }
        }))
        ac.addAction(UIAlertAction(title: LocalizedAlertboxStrings.cancel, style: .cancel))
        present(ac, animated: true)
    }
}


