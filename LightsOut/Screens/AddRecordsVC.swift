//
//  AddRecordsVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

class AddRecordsVC: LODataLoadingVC {


    enum Section { case main }
    
    var localRecords: [RecordModel] = [] {
        didSet {
            if localRecords.isEmpty {
                collectionView.backgroundView = LOEmptyStateView(message: "No Records?\n Go Lights Out screen and test your reaction time.")
            }
        }
    }
    var recordsWithEmptyName = [RecordModel]()
    var leagueNumber: Int?
    @IBOutlet var doneButton: UIBarButtonItem!
    var selectedRecords: [RecordModel] = [] {
        didSet {
            warningLabel.text = "You can add max 3 records at once. Remains: \(3 - selectedRecords.count)"
            if !selectedRecords.isEmpty {
                doneButton.isEnabled = true
            } else {
                doneButton.isEnabled = false
            }
            if selectedRecords.count < 3 {
                warningLabel.textColor = .secondaryLabel
            } else {
                warningLabel.textColor = .systemRed
            }
        }
    }
    
    @IBOutlet var warningLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    private lazy var dataSource = makeDataSource()
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false
        collectionView.collectionViewLayout = UIHelper.createLocalRecordVCLayout(isHeaderOn: false)
        collectionView.register(UINib(nibName: Constants.CellReuseID.localRecordCell, bundle: nil), forCellWithReuseIdentifier: Constants.CellReuseID.localRecordCell)
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecords()
    }
    @IBAction func cancelButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    @IBAction func doneButtonAction(_ sender: UIBarButtonItem) {
        let destVC = UIStoryboard(name: "LOAddNameForLeagueStoryboard", bundle: nil).instantiateViewController(withIdentifier: "LOAddNameForLeagueStoryboard") as! LOAddNameForLeagueVC
        destVC.delegate = self
        destVC.modalPresentationStyle = .overFullScreen
        destVC.modalTransitionStyle = .crossDissolve
        
        for record in selectedRecords {
            if record.name == "" {
                recordsWithEmptyName.append(record)
            }
        }
        
        if recordsWithEmptyName.count != 0 {
            self.present(destVC, animated: true)
        } else {
            showLoadingView()
            FirebaseManager.shared.saveRecordToFirendLeague(records: selectedRecords, leagueNumber: leagueNumber) { [weak self] error in
                guard let self = self else { return }
                self.dismissLoadingView()
                
                if let error = error {
                    self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    func loadRecords() {
        DatabaseManager.shared.getAllRecordsFromSqliteDb { result in
            switch result {
            case .success(let localRecords):
                self.localRecords = localRecords
                self.updateData(on: self.localRecords)
            case .failure(let error):
                self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
            }
        }
    }
    

    func updateData(on records: [RecordModel]) {
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
            cell.editButton.isHidden = true
            cell.selectImageView.isHidden = false
            return cell
        }

        return dataSource
    }
    
    
    func save(records: [RecordModel]) {
    }

    
}

extension AddRecordsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedRecords.count < 3 {
            let selectedRecord = localRecords[indexPath.row]
            let cell = collectionView.cellForItem(at: indexPath) as! LOLocalRecordCell
            cell.selectImageView.image = UIImage(systemName: "circle.fill")
            selectedRecords.append(selectedRecord)
            //warningLabel.textColor = .secondaryLabel
        } //else {
           // warningLabel.textColor = .systemRed
      //  }

        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let deselectedRecord = localRecords[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! LOLocalRecordCell
        
        if let index = selectedRecords.firstIndex(where: { $0.recordUid == deselectedRecord.recordUid}){
            selectedRecords.remove(at: index)
            cell.selectImageView.image = UIImage(systemName: "circle")
        }
        if let index = recordsWithEmptyName.firstIndex(where: {$0.recordUid == deselectedRecord.recordUid}) {
            recordsWithEmptyName.remove(at: index)
        }
 
        
    }
}

extension AddRecordsVC: LOAddNameForLeagueVCDelegate {
    func didTapSaveButton(name: String?) {
        showLoadingView()
        for var record in recordsWithEmptyName {
            if let index = selectedRecords.firstIndex(where: { $0.recordUid == record.recordUid}){
                selectedRecords.remove(at: index)
            }
            record.name = name

            DatabaseManager.shared.updateRecordForFriendLeague(record: record) { error in
                if let error = error {
                    self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
                }
            }
            selectedRecords.append(record)
            
        }
        
        FirebaseManager.shared.saveRecordToFirendLeague(records: selectedRecords, leagueNumber: leagueNumber) { [weak self] error in
            guard let self = self else { return }
            self.dismissLoadingView()
            if let error = error {
                self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
        
    }
    
    
}
