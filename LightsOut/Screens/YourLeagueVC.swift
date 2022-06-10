//
//  YourLeagueVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//
import UIKit

class YourLeagueVC: LODataLoadingVC {
    
    let deleteActionInfo = Notification.Name(rawValue: Constants.NotificationKeys.deleteActionInfo)
    
    @IBOutlet var collectionView: UICollectionView!
    
    enum Section { case main }
    
    var league: LeagueModel?
    var userUid: String?
    
    var leagueDeleteActionWorks = false {
        didSet {
            loadRecords()
            leagueDeleteActionWorks = false
            
        }
    }
    
    var records: [RecordModel] = [] {
        didSet {
            updateData(on: records)
            if records.isEmpty {
                collectionView.backgroundView = LOEmptyStateView(message: LocalizedStrings.emptyStateInLeague)
                deleteRecords.isEnabled = false
            } else {
                collectionView.backgroundView = nil
                deleteRecords.isEnabled = true
            }
        }
    }
    
    @IBOutlet var deleteRecords: UIBarButtonItem!
    
    private lazy var dataSource = makeDataSource()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = league?.leagueName
        collectionView.collectionViewLayout = UIHelper.createOnlineRecordVCLayout(isHeaderOn: true)
        collectionView.register(UINib(nibName: Constants.CellReuseID.onlineRecordCell, bundle: nil), forCellWithReuseIdentifier: Constants.CellReuseID.onlineRecordCell)
        collectionView.register(UINib(nibName: Constants.HeaderReuseID.yourLeagueHeader, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.HeaderReuseID.yourLeagueHeader)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteRecordsWorks), name: deleteActionInfo, object: nil)
        
    }
    
    @objc func deleteRecordsWorks() {
        leagueDeleteActionWorks = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecords()
    }
    
    func loadRecords() {
        self.showLoadingView()
        guard let leagueId = league?.leagueId else { return }
        FirebaseManager.shared.getrecordsInLeague(leagueId: leagueId) { records, error in
            self.dismissLoadingView()
            if let error = error {
                self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
            } else {
                var recordsInFriends = [RecordModel]()
                for record in records! {
                    let newRecord = RecordModel(id: 0, userUid: record.userUid, timeStamp: record.timeStamp, recordTime: record.recordTime, name: record.name, recordUid: record.recordUid, isSaved: false, isOnline: false)
                    if newRecord.recordUid != "placeHolderRecord" {
                        recordsInFriends.append(newRecord)
                    }
                    
                    
                }
                
                self.records = recordsInFriends.sorted(by: {$0.recordTime < $1.recordTime })
            }
            
        }
    }
    
    func updateData(on records: [RecordModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RecordModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(records, toSection: .main)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot)
        }
    }
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section,RecordModel> {
        let dataSource = UICollectionViewDiffableDataSource<Section,RecordModel>(collectionView: collectionView) { collectionView, indexPath, record in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseID.onlineRecordCell, for: indexPath) as! LOOnlineRecordCell
            cell.set(record: record, rankValue: indexPath.row + 1)
            return cell
        }
        
        dataSource.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
        
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.HeaderReuseID.yourLeagueHeader, for: indexPath) as? YourLeagueHeaderView
            
            view?.headerViewDelegate = self
            return view
        }
        return dataSource
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.goToAddRecordsToLeague {
            let secondView = segue.destination as! AddRecordsVC
            secondView.leagueNumber = league?.leagueId
        }
    }
    
    @IBAction func addRecordButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.Segues.goToAddRecordsToLeague, sender: self)
        
    }

    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        guard let league = league else {
            return
        }
        guard let userUid = userUid else {
            return
        }

        if userUid == league.creatorUid {
            presentQuitAndDeleteAlert(userUid: userUid, leagueNumber: league.leagueId)
        } else {
            
        }
    }
    
    @IBAction func deleteAction(_ sender: UIBarButtonItem) {
        
        if userUid == league?.creatorUid {
           presentDeleteRecordsForOwner(userUid: userUid, league: league)
        } else {
            presentDeleteRecordsForMember(userUid: userUid, league: league)
        }
    }
}

extension YourLeagueVC: YourLeagueHeaderViewDelegate {
    func didTapAction() {
        print("DEBUG: handletap Your elague")
        let destVC = UIStoryboard(name: "LOCreateLagueStoryboard", bundle: nil).instantiateViewController(withIdentifier: "LOCreatLeagueConfirmation") as! LOCreatLeagueConfirmationVC
        destVC.modalPresentationStyle = .overFullScreen
        destVC.modalTransitionStyle = .crossDissolve
        destVC.leagueID = league?.leagueId
        destVC.password = league?.leaguePassword
        self.present(destVC, animated: true)
    }
    
    
}
