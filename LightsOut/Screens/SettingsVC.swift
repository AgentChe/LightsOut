//
//  SettingsVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit
import StoreKit


class SettingsVC: UITableViewController {
    
    var isPro = UserDefaults.standard.bool(forKey: Keys.getPro)
    var isSoundEffect = UserDefaults.standard.bool(forKey: Keys.soundSettings)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.backgroundColor = UIColor.systemBackground
        tableView.isScrollEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        UIHelper.configureSectionsTitle(section)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.globalPadding
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.sectionCount
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        UIHelper.configureNumberOfRowsInSection(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UIHelper.configureCells(tableView: tableView, indexPath: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToStatistics"{
              let secondView = segue.destination as! StatisticsVC
            secondView.title = "Statistics"
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == [0,1] {
            performSegue(withIdentifier: "goToStatistics", sender: self)
        } else if indexPath == [0,0] {
            if !UserDefaults.standard.bool(forKey: Keys.getPro) {
                performSegue(withIdentifier: "goToGetPro", sender: self)
            }
        } else if indexPath == [1,0] {
            isSoundEffect.toggle()
            print("DEBUG: sound effect status: \(isSoundEffect)")
            UserDefaults.standard.set(isSoundEffect, forKey: Keys.soundSettings)
            tableView.reloadRows(at: [indexPath], with: .none)
            
        } else if indexPath == [2,1] {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        } else if indexPath == [2,2] {
            performSegue(withIdentifier: "goToContact", sender: self)
        }
    }
    
    
}
