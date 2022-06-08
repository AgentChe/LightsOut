//
//  YourLeagueVC.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 6.06.2022.
//

import UIKit

class YourLeagueVC: LODataLoadingVC {
    
    @IBOutlet var collectionView: UICollectionView!
    
    enum Section { case main }
    
    var league: LeagueModel?
    
    var records: [RecordModel] = [] {
        didSet {
            updateData(on: records)
            if records.isEmpty {
                collectionView.backgroundView = LOEmptyStateView(message: "No Records?\n Add records with add button")
            }
        }
    }
    
    
    
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
    @IBAction func leagueInfoButton(_ sender: UIBarButtonItem) {
    }
    
    
}
