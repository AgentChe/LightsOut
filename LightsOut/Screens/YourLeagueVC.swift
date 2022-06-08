//
//  YourLeagueVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//
import UIKit

class YourLeagueVC: LODataLoadingVC {
    
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
                collectionView.backgroundView = LOEmptyStateView(message: "No Records?\n Add records with add button")
                deleteRecords.isEnabled = false
            } else {
                collectionView.backgroundView = nil
                deleteRecords.isEnabled = true
            }
        }
    }
    
    
    @IBOutlet var deleteRecords: UIBarButtonItem!
    
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = league?.leagueName
        collectionView.collectionViewLayout = UIHelper.createOnlineRecordVCLayout()
        collectionView.register(UINib(nibName: "LOOnlineRecordCell", bundle: nil), forCellWithReuseIdentifier: LOOnlineRecordCell.reuseID)
        
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
                print("DEBUG: \(error)")
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LOOnlineRecordCell.reuseID, for: indexPath) as! LOOnlineRecordCell
            cell.set(record: record, rankValue: indexPath.row + 1)
            return cell
        }
        return dataSource
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAddRecordsToLeague" {
            let secondView = segue.destination as! AddRecordsVC
            secondView.leagueNumber = league?.leagueId
        }
    }
    
    @IBAction func addRecordButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToAddRecordsToLeague", sender: self)
        
    }

    
    @IBAction func logOutButton(_ sender: UIBarButtonItem) {
        if userUid == league?.creatorUid {
            print("DEBUG: owener tapped quit alert")
        } else {
            print("DEBUG: It is not owner just quit alert")
        }
    }
    
    @IBAction func deleteAction(_ sender: UIBarButtonItem) {
        
        if userUid == league?.creatorUid {
            let ac = UIAlertController(title: "Delete Records", message: "You can delete all records in league or just your owns. ", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Delete All", style: .destructive, handler: { action in
                guard let userUid = self.userUid else {
                    return
                }
                guard let league = self.league else {
                    return
                }
                FirebaseManager.shared.deleteOwnRecordInFriendsLeague(userUid: userUid, leagueNumber: league.leagueId) { error in
                    self.leagueDeleteActionWorks = true
                    if let error = error {
                        print("DEBUG: \(error)")
                    }
                }
            }))
            ac.addAction(UIAlertAction(title: "Delete Owns", style: .destructive, handler: { action in
                guard let league = self.league else {
                    return
                }
                FirebaseManager.shared.deleteAllRecordsInFriendsLeague(leagueNumber: league.leagueId) { error in
                    self.leagueDeleteActionWorks = true
                    if let error = error {
                        print("DEBUG: \(error)")
                    }
                }
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Delete Records", message: "Your record will be deleted from league", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                guard let userUid = self.userUid else {
                    return
                }
                guard let league = self.league else {
                    return
                }
                FirebaseManager.shared.deleteOwnRecordInFriendsLeague(userUid: userUid, leagueNumber: league.leagueId) { error in
                    self.leagueDeleteActionWorks = true
                    if let error = error {
                        print("DEBUG: \(error)")
                    }
                }
            }))
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
        }
    }
}
