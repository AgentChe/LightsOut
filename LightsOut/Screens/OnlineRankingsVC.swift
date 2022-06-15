//
//  OnlineRankingsVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit


class OnlineRankingsVC: LODataLoadingVC {

    @IBOutlet var collectionView: UICollectionView!
    enum Section { case main }
    private lazy var dataSource = makeDataSource()
    var onlineRecords: [RecordModel] = []
    {
        didSet {
            updateData(on: onlineRecords)

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        collectionView.collectionViewLayout = UIHelper.createOnlineRecordVCLayout()
        collectionView.register(UINib(nibName: Constants.CellReuseID.onlineRecordCell, bundle: nil), forCellWithReuseIdentifier: Constants.CellReuseID.onlineRecordCell)
        
        loadRecords()
    }
    
    @IBAction func infoButtonAction(_ sender: UIBarButtonItem) {
        loadRankingRefreshMessage()
        
    }
    
    func loadRankingRefreshMessage() {
        FirebaseManager.shared.loadRankingRefreshMessage { (refreshMessage, error) in
            guard let error = error else {
                self.presentAlertWithOk(title: refreshMessage.title, message: refreshMessage.message)
                return
            }
            self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
        }
    }
    
    func loadRecords() {
        self.showLoadingView()
        FirebaseManager.shared.getAllRecordsFromFirestore { records, error in
            guard let error = error else {
                self.dismissLoadingView()
                self.onlineRecords = records

                return
            }
            self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: LocalizedErrorMessages.unableToComplete)
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
        return dataSource
    }

}
