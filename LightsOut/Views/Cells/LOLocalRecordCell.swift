//
//  LOLocalRecordCell.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

protocol LOLocalRecordCellActionDelegate: AnyObject {
    func didTapSaveAction(_ cell: LOLocalRecordCell)
    func didTapDeleteAction(_ cell: LOLocalRecordCell)
}

class LOLocalRecordCell: UICollectionViewCell {
    
    var record: RecordModel?
    
    @IBOutlet weak var numberImageView: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var selectImageView: UIImageView!
    weak var actionDelegate: LOLocalRecordCellActionDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
    }
        
    func set(record: RecordModel, rankValue: Int) {
        numberImageView.image = UIImage(systemName: "\(rankValue).circle")
        topLabel.text = "\(record.recordTime) " + "s" + " - \(record.name!)"
        bottomLabel.text = Date(timeIntervalSince1970: record.timeStamp).convertToStringWithFormat()
        self.record = record
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        if let parentViewController = self.parentViewController{
            showActionSheetToEdit(vc: parentViewController, record: record!)
        }
    }
    
    
    func showActionSheetToEdit(vc: UIViewController, record: RecordModel) {
        let actionMenu = UIAlertController(title: nil, message: "Choose Action", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            self.actionDelegate?.didTapDeleteAction(self)
        }
        let saveAction = UIAlertAction(title: "Save to Online Rankings", style: .default) { action in
            self.actionDelegate?.didTapSaveAction(self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        if record.isSaved == false {
            actionMenu.addAction(saveAction)
        }
        
        actionMenu.addAction(deleteAction)
        actionMenu.addAction(cancelAction)
        
        vc.present(actionMenu, animated: true, completion: nil)
    }

    
    
}
