//
//  LeagueVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit
import Network
import GoogleMobileAds

class LeagueVC: LODataLoadingVC {
    
    let monitor = NWPathMonitor()
    
    @IBOutlet var collectionView: UICollectionView!

    let goLeagueInfo = Notification.Name(rawValue: Constants.NotificationKeys.goLeagueNotificationKey)
    let updateLeagueInfo = Notification.Name(rawValue: Constants.NotificationKeys.updateLeagueInfo)
    
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
    
    var bannerIsLoad = true {
        didSet {
            collectionView.reloadData()
        }
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.collectionViewLayout = UIHelper.createLeagueVCLayout()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        
        collectionView.register(UINib(nibName: Constants.CellReuseID.bannerCell, bundle: nil), forCellWithReuseIdentifier: Constants.CellReuseID.bannerCell)
        collectionView.register(UINib(nibName: Constants.CellReuseID.fullSizeCell, bundle: nil), forCellWithReuseIdentifier: Constants.CellReuseID.fullSizeCell)
        collectionView.register(UINib(nibName: Constants.CellReuseID.squareCell, bundle: nil), forCellWithReuseIdentifier: Constants.CellReuseID.squareCell)
        
        collectionView.register(UINib(nibName: Constants.HeaderReuseID.leaguesHeader, bundle: nil), forSupplementaryViewOfKind: Constants.HeaderReuseID.leagueCategoryHeader, withReuseIdentifier: Constants.HeaderReuseID.leaguesHeader)
        
        authIfUserNotLogin()
        createObservers()
        
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isPro = isPurchased()
        
    }
    
    
    func isPurchased() -> Bool {
        let purchaseStatus = UserDefaults.standard.bool(forKey: Constants.Keys.getPro)
        return purchaseStatus ? true : false
    }
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateLeagueSection), name: updateLeagueInfo, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(goLeague), name: goLeagueInfo, object: nil)
    }
    
    @objc func updateLeagueSection() {
        loadFirendsLeaguesFromFirebase()
    }
    
    @objc func goLeague() {
        goTo(with: Constants.Screens.yourLeagueVC)
    }
    
    func loadFirendsLeaguesFromFirebase() {
        showLoadingView()
        FirebaseManager.shared.getYourLeagues(userUid: userUid) { leagues, error in
            guard let error = error else {
                self.dismissLoadingView()
                self.friendsLeague = leagues
                return
            }
            self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
        }
    }
    
    func authIfUserNotLogin() {
        if let currentUserUid = FirebaseManager.shared.getCurrentUser() {
            userUid = currentUserUid
        } else {
            FirebaseManager.shared.authAnonymous { currentUserUid, error in
                guard let error = error else {
                    self.userUid = currentUserUid
                    return
                }
                self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.goToCreateLeague{
            let secondView = segue.destination as! LOCreateLeagueVC
            secondView.userUid = userUid
            secondView.randomLeaagueID = Int.random(in: 10000...99999)
        } else if segue.identifier == Constants.Segues.goToJoinLeague {
            let secondView = segue.destination as! LOJoinLeagueVC
            secondView.userUid = userUid
        } else if segue.identifier == Constants.Segues.goToYourLeague {
            guard let selectedIndexPath = sender as? NSIndexPath else { return }
            let secondView = segue.destination as! YourLeagueVC
            secondView.userUid = userUid
            secondView.league = friendsLeague[selectedIndexPath.row]
        }
    }
    
    func checkConnectionAndShowAlertAndReturn(withMessage message: LOError) {
        if monitor.currentPath.status == .unsatisfied {
            presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: message.localizedDescription)
        }
    }
    
}

extension LeagueVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return Constants.ItemCounts.leagueVCSection0
        } else if section == 1 {
            return bannerIsLoad ? Constants.ItemCounts.leagueVCSection1 : 0
        } else {
            return friendsLeague.isEmpty ? 1 : friendsLeague.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseID.fullSizeCell, for: indexPath) as! LOFullSizeCell
            indexPath.row == 0 ? cell.setLabel(with: LocalizedStrings.yourRecords) : cell.setLabel(with: LocalizedStrings.onlineRankings)
            return cell
        } else if indexPath.section == 1 {
            //This is ad cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseID.bannerCell, for: indexPath) as! LOBannerCell
            cell.adView.delegate = self
            cell.adView.rootViewController = self
            cell.adView.load(GADRequest())
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseID.squareCell, for: indexPath) as! LOSquareCell
            friendsLeague.isEmpty ? cell.set(with: LocalizedStrings.addLeague, leagueId: "") : cell.set(with: friendsLeague[indexPath.row].leagueName, leagueId: "#\(friendsLeague[indexPath.row].leagueId)")
            return cell
        }
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.SectionCounts.leagueVC
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.HeaderReuseID.leaguesHeader, for: indexPath) as! LOLeaguesHeaderView
        header.delegate = self
        return header
    }
}

extension LeagueVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                goTo(with: Constants.Screens.localRecordsVC)
            } else {
                checkConnectionAndShowAlertAndReturn(withMessage: .checkYourInternet)
                goTo(with: Constants.Screens.onlineRecordsVC)
            }
        } else if indexPath.section == 2 {
            checkConnectionAndShowAlertAndReturn(withMessage: .checkYourInternet)
            if self.friendsLeague.isEmpty {
                checkUserProStatusAndPresentAlert(status: isPro, userUid: userUid)
            } else {
                performSegue(withIdentifier: Constants.Segues.goToYourLeague, sender: indexPath)
            }
        }
    }
}

extension LeagueVC: LOLeaguesHeaderViewDelegate {
    func didTapCreateButton() {
        checkConnectionAndShowAlertAndReturn(withMessage: .checkYourInternet)
        
        if userUid != "" && isPro == true {
            performSegue(withIdentifier: Constants.Segues.goToCreateLeague, sender: self)
        } else if isPro == false {
            presentGetProAlert(userUid: userUid)
        }
    }

    func didTapJoinButton() {
        checkConnectionAndShowAlertAndReturn(withMessage: .checkYourInternet)
        
        if userUid != "" && isPro == true  {
            performSegue(withIdentifier: Constants.Segues.goToJoinLeague, sender: self)
        } else if isPro == false {
            presentGetProAlert(userUid: userUid)
        }
    }
  
}

extension LeagueVC: GADBannerViewDelegate {
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        bannerIsLoad = false
    }

}
