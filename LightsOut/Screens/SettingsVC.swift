//
//  SettingsVC.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 27.05.2022.
//

import UIKit



class SettingsVC: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.backgroundColor = UIColor.systemBackground
        tableView.isScrollEnabled = false
        
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
            performSegue(withIdentifier: "goToGetPro", sender: self)
        } else if indexPath == [1,0] {
            print("DEBUG: Sound effects on/off")
        } else if indexPath == [1,1] {
            print("DEBUG: Tutorial on/off")
        }
    }
    
    
}
