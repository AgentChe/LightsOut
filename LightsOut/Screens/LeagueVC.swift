//
//  LeagueVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit
import Network

class LeagueVC: LODataLoadingVC {
    
    let monitor = NWPathMonitor()
    
    @IBOutlet var collectionView: UICollectionView!
    
    let getCreatedLeagueInfo = Notification.Name(rawValue: Constants.createLeagueNotificationKey)
    let getJoinedLeagueInfo = Notification.Name(rawValue: Constants.joinLeagueNotificationKey)
    let goLeagueInfo = Notification.Name(rawValue: Constants.goLeagueNotificationKey)
    let goDeletedInfo = Notification.Name(rawValue: Constants.leagueWasDeletedNotificationKey)
    let cellId = "cellId"
    
    var friendsLeague: [LeagueModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var userUid = "" {
        didSet {
            loadFirendsLeaguesFromFirebase()
        }
    }
    
    var isPro: Bool? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        
        print("DEBUG: LEagueVC viewdidlload")
        navigationItem.title = "League"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.collectionViewLayout = UIHelper.createLeagueVCLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId) //This will be turned ad cell.
        collectionView.register(UINib(nibName: "LOFullSizeCell", bundle: nil), forCellWithReuseIdentifier: LOFullSizeCell.reuseID)
        collectionView.register(UINib(nibName: "LOSquareCell", bundle: nil), forCellWithReuseIdentifier: LOSquareCell.reuseID)
        
        collectionView.register(UINib(nibName: "LOLeaguesHeaderView", bundle: nil), forSupplementaryViewOfKind: LOLeaguesHeaderView.categoryHeaderId, withReuseIdentifier: LOLeaguesHeaderView.reuseId)
        checkConnectionAndShowAlert(withMessage: .unableToGetAllRecords)
        authIfUserNotLogin()
        createObservers()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isPro = isPurchased()
        
    }
    
    func checkConnectionAndShowAlert(withMessage message: LOError) {
        if monitor.currentPath.status == .unsatisfied {
            print("DEBUG: Internet yok error")
        }
    }
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: Keys.getPro)
        return purchaseStatus ? true : false
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLeagueSection), name: getCreatedLeagueInfo, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLeagueSection), name: getJoinedLeagueInfo , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLeagueSection), name: goDeletedInfo , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goLeague), name: goLeagueInfo, object: nil)
    }
    
    @objc func updateLeagueSection() {
        loadFirendsLeaguesFromFirebase()
    }
    
    @objc func goLeague() {
        let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YourLeagueVC")
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    
    
    func loadFirendsLeaguesFromFirebase() {
        showLoadingView()
        FirebaseManager.shared.getYourLeagues(userUid: userUid) { leagues, error in
            guard let error = error else {
                self.dismissLoadingView()
                self.friendsLeague = leagues
                print(self.friendsLeague)
                return
            }
            print("DEBUG: Error with load records \(error)")
        }
    }
    
    
    func authIfUserNotLogin() {
        if let currentUserUid = FirebaseManager.shared.getCurrentUser() {
            print("current user uid: \(currentUserUid)")
            userUid = currentUserUid
            
        } else {
            FirebaseManager.shared.authAnonymous { currentUserUid, error in
                guard let error = error else {
                    self.userUid = currentUserUid
                    return
                }
                print("DEBUG: \(error)")
            }
            
        }
    }
    
}

extension LeagueVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            if isPro == true {
                return 0
            } else {
                return 1
            }
        } else {
            if friendsLeague.isEmpty { return 1 }
            else {
                return friendsLeague.count
            }
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LOFullSizeCell.reuseID, for: indexPath) as! LOFullSizeCell
            if indexPath.row == 0 {
                cell.setLabel(with: "Your Records")
            } else {
                cell.setLabel(with: "Online Rankings")
            }
            return cell
        } else if indexPath.section == 1 {
            //This is ad cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            cell.backgroundColor = .systemRed
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LOSquareCell.reuseID, for: indexPath) as! LOSquareCell
            if friendsLeague.isEmpty {
                cell.set(with: "Add a league", leagueId: "")
            } else {
                cell.set(with: friendsLeague[indexPath.row].leagueName, leagueId: "#\(friendsLeague[indexPath.row].leagueId)")
            }
            
            return cell
        }
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LOLeaguesHeaderView.reuseId, for: indexPath) as! LOLeaguesHeaderView
        header.delegate = self
        return header
    }
    
    
}

extension LeagueVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocalRecordVC")
                self.navigationController?.pushViewController(destVC, animated: true)
            } else {
                let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnlineRankingsVC")
                self.navigationController?.pushViewController(destVC, animated: true)
            }
        } else if indexPath.section == 1 {
            print("DEBUG: REKLAM")
        } else {
            if self.friendsLeague.isEmpty {
                if isPro == true {
                    let ac = UIAlertController(title: "Add a league", message: "You can create a league or join a league", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
                        if self.userUid != "" {
                            self.performSegue(withIdentifier: "goToCreateLeague", sender: self)
                        }
                    }))
                    ac.addAction(UIAlertAction(title: "Join", style: .default,handler: { action in
                        if self.userUid != "" {
                            self.performSegue(withIdentifier: "goToJoinLeague", sender: self)
                        }
                    }))
                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    present(ac, animated: true)
                } else {
                    let ac = UIAlertController(title: "Get PRO", message: "You can access the friends league if you will be a PRO", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Get PRO", style: .default, handler: { action in
                        if self.userUid != "" {
                            self.performSegue(withIdentifier: "goToGetPro", sender: self)
                        }
                    }))
                    ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                    present(ac, animated: true)
                }
               
            } else {
                let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "YourLeagueVC") as! YourLeagueVC
                destVC.userUid = userUid
                destVC.league = friendsLeague[indexPath.row]
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            
        }
        
    }
}


extension LeagueVC: LOLeaguesHeaderViewDelegate {
        
    func didTapCreateButton() {
        
        if userUid != "" && isPro == true {
            performSegue(withIdentifier: "goToCreateLeague", sender: self)
            
        } else if isPro == false {
            let ac = UIAlertController(title: "Get PRO", message: "You can access the friends league if you will be a PRO", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Get PRO", style: .default, handler: { action in
                if self.userUid != "" {
                    self.performSegue(withIdentifier: "goToGetPro", sender: self)
                }
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToCreateLeague"{
            let secondView = segue.destination as! LOCreateLeagueVC
            secondView.userUid = userUid
            secondView.randomLeaagueID = Int.random(in: 10000...99999)
        } else if segue.identifier == "goToJoinLeague" {
            let secondView = segue.destination as! LOJoinLeagueVC
            secondView.userUid = userUid
        }
    }
    
    func didTapJoinButton() {
        if userUid != "" && isPro == true  {
            performSegue(withIdentifier: "goToJoinLeague", sender: self)
        } else if isPro == false {
            let ac = UIAlertController(title: "Get PRO", message: "You can access the friends league if you will be a PRO", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Get PRO", style: .default, handler: { action in
                if self.userUid != "" {
                    self.performSegue(withIdentifier: "goToGetPro", sender: self)
                }
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
    }
    
    
}
