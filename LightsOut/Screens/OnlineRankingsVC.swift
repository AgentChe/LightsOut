//
//  OnlineRankingsVC.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 30.05.2022.
//

import UIKit

class OnlineRankingsVC: LODataLoadingVC {

    @IBOutlet var collectionView: UICollectionView!
    enum Section { case main }
    private lazy var dataSource = makeDataSource()
    var onlineRecords: [RecordModel] = []
    {
        didSet {
            print("DEBUG: Online record was change")
            updateData(on: onlineRecords)

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Online Rankings"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        collectionView.collectionViewLayout = UIHelper.createOnlineRecordVCLayout()
        collectionView.register(UINib(nibName: "LOOnlineRecordCell", bundle: nil), forCellWithReuseIdentifier: LOOnlineRecordCell.reuseID)
        
        loadRecords()
    }
    
    func loadRecords() {
        print("DEBUG: Online load records work")
        self.showLoadingView()
        FirebaseManager.shared.getAllRecordsFromFirestore { records, error in
            guard let error = error else {
                self.dismissLoadingView()
                self.onlineRecords = records

                return
            }
            print("DEBUG: Error with load records \(error)")
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

}
