//
//  LocalRecordsVC.swift
//  LightsOut_V2
//
//  Created by Murat Baykor on 25.05.2022.
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
            }
        }
    }
    
    @IBOutlet var collectionView: UICollectionView!
    
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
    
        
        super.viewDidLoad()
        navigationItem.title = "Local Records"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        collectionView.collectionViewLayout = UIHelper.createLocalRecordVCLayout()
        collectionView.register(UINib(nibName: "LOLocalRecordCell", bundle: nil), forCellWithReuseIdentifier: LOLocalRecordCell.reuseID)
        collectionView.register(UINib(nibName: "LOLocalRecordsHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LOLocalRecordsHeaderView.reuseId)

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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LOLocalRecordCell.reuseID, for: indexPath) as! LOLocalRecordCell
            cell.set(record: record, rankValue: indexPath.item + 1)
            cell.actionDelegate = self
            return cell
        }
        
        
        dataSource.supplementaryViewProvider = {collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
        
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LOLocalRecordsHeaderView.reuseId, for: indexPath) as? LOLocalRecordsHeaderView
        
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

        performSegue(withIdentifier: "goToAddName", sender: cell)
        

        
        
       //performSegue(withIdentifier: "goToAddName", sender: self)
        
//        let ac = UIAlertController(title: "Save Online" , message: "Save your" + "\(localRecords[indexPath.row].reactionTime)" + "\n Limit 12 characters bla bla bla", preferredStyle: .alert)
//        ac.addTextField { (textfield) in
//            textfield.placeholder = "Enter a name"
//            textfield.delegate = self
//        }
//
//
//        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
//            guard let textField = ac.textFields?[0] else { return }
//            guard let name = textField.text else { return }
//
//            if name.isEmpty {
//                print("DEBUG: name empty")
//                return
//            } else if name.count > 12 {
//                return
//            } else {
//                self.localRecords[indexPath.row].name = name
//                self.localRecords[indexPath.row].isSaved = true
//            }
//
//            self.showLoadingView()
//            DatabaseManager.shared.updateRecord(record: self.localRecords[indexPath.row]) { error in
//                if let error = error {
//                    print("DEBUG: Error: \(error)")
//                } else {
//                    print("DEBUG: Successfully updated with no error")
//                    FirebaseManager.shared.saveRecordToFirebase(record: self.localRecords[indexPath.row]) { error in
//                        self.dismissLoadingView()
//                        guard let error = error else { return }
//                        print("DEBUG: Error with save to firebase - \(error)")
//                    }
//                }
//            }
 //       }
//
//        ac.addAction(saveAction)
//        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
//
//        present(ac, animated: true)
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
