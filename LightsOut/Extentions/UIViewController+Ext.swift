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
    
}
