//
//  LocalRecordsVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit
import SQLite

class LocalRecordsVC: LODataLoadingVC {
    static let statisticsHeaderId = "statisticsHeaderId"
    
    
    enum Section { case main }
    var userUid: String?
    var localRecords: [RecordModel] = [] {
        didSet {
            print("DEBUG: Local record was change")
            updateData(on: localRecords)
            
        }
    }
    var avarageReactionTime = 0.0 {
        didSet {
            if avarageReactionTime.isNaN {
                collectionView.backgroundView = LOEmptyStateView(message: "No Records?\n Go Lights Out screen and test your reaction time.")
                collectionView.isScrollEnabled = false
            } else {
                collectionView.backgroundView = nil
                collectionView.isScrollEnabled = true
                UserDefaults.standard.set(avarageReactionTime, forKey: Constants.Keys.avarageReactionTime)
            }
        }
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        collectionView.collectionViewLayout = UIHelper.createLocalRecordVCLayout()
        collectionView.register(UINib(nibName: Constants.CellReuseID.localRecordCell, bundle: nil), forCellWithReuseIdentifier: Constants.CellReuseID.localRecordCell)
        collectionView.register(UINib(nibName: Constants.HeaderReuseID.localRecordsHeader, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.HeaderReuseID.localRecordsHeader)

        //DatabaseManager.shared.addCustomRecord()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecords()
    }
    
    
    
    func loadRecords() {
        print("DEBUG: Load records work")
        DatabaseManager.shared.getAllRecordsFromSqliteDb { result in
            switch result {
            case .success(let localRecords):
                self.localRecords = localRecords
            case .failure(let error):
                print("DEBUG: Load records error with error: \(error)")
            }
        }
    }
    
    
    func updateData(on records: [RecordModel]) {
        self.avarageReactionTime = calculateAvarageReactionTime(with: records)
        var snapshot = NSDiffableDataSourceSnapshot<Section, RecordModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(records, toSection: .main)
        DispatchQueue.main.async {
            self.dataSource.applySnapshotUsingReloadData(snapshot)
        }
    }
    
    
    func makeDataSource() -> UICollectionViewDiffableDataSource<Section, RecordModel> {
        let dataSource = UICollectionViewDiffableDataSource<Section, RecordModel>(collectionView: collectionView) { collectionView, indexPath, record in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellReuseID.localRecordCell, for: indexPath) as! LOLocalRecordCell
            cell.set(record: record, rankValue: indexPath.item + 1)
            cell.actionDelegate = self
            return cell
        }
        
        
        dataSource.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
        
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.HeaderReuseID.localRecordsHeader, for: indexPath) as? LOLocalRecordsHeaderView
        
            view?.setAvarageReactionTime(with: self.avarageReactionTime)
            view?.headerViewDelegate = self
            return view
        }
        
        return dataSource
    }
    
    func calculateAvarageReactionTime(with localRecords: [RecordModel]) -> Double {
        var sumOfReactionTimes = 0.0
        for localRecord in localRecords {
            guard let recordTime = Double(localRecord.recordTime) else { return 0.0}
            sumOfReactionTimes += recordTime
        }
        return sumOfReactionTimes / Double(localRecords.count)
    }
    
}

extension LocalRecordsVC: LOLocalRecordsHeaderViewDelegate {
    func didTapAction() {
        let destVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StatisticsVC") as! StatisticsVC
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    

}

//extension LocalRecordsVC: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else { return true }
//        let newLength = text.count + string.count - range.length
//        return newLength <= 12
//    }
//}

extension LocalRecordsVC: LOLocalRecordCellActionDelegate {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondView = segue.destination as! LOAddNameVC
        secondView.delegate = self
        let cell = sender as! LOLocalRecordCell
        let indexPath = collectionView.indexPath(for: cell)!
        secondView.index = indexPath.row
        secondView.record = localRecords[indexPath.row]
    }

    func didTapSaveAction(_ cell: LOLocalRecordCell) {

        performSegue(withIdentifier: Constants.Segues.goToAddName, sender: cell)
        
    }
    
    func didTapDeleteAction(_ cell: LOLocalRecordCell) {
        let indexPath = collectionView.indexPath(for: cell)!
        let selectedRecord = localRecords[indexPath.row]
        DatabaseManager.shared.deleteSingleRecordFromSqliteDb(record: selectedRecord) { error in
            guard let error = error else {
                self.localRecords.remove(at: indexPath.row)
                self.updateData(on: self.localRecords)
                return
            }
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
}

extension LocalRecordsVC: LOAddNameVCDelegate {
    func didTapSaveButton(index: Int?, name: String) {
        guard let index = index else {
            return
        }
        self.localRecords[index].name = name
        self.localRecords[index].isSaved = true
    }
    
    
}
