//
//  LOAddNameVC.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

protocol LOAddNameVCDelegate: AnyObject {
    func didTapSaveButton(index: Int?, name: String)
}

class LOAddNameVC: LODataLoadingVC {

    var record: RecordModel?
    var index: Int?
    var isNameOk = false
    weak var delegate: LOAddNameVCDelegate?
    
    @IBOutlet var boxView: UIView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        boxView.layer.cornerRadius = 10
        nameTextField.delegate = self
        nameTextField.becomeFirstResponder()

    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        guard var record = record else {
            return
        }
        record.name = nameTextField.text
        record.isSaved = true
        showLoadingView()
        DatabaseManager.shared.updateRecord(record: record) { error in
            if let error = error {
                self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
            } else {
                FirebaseManager.shared.saveRecordToFirebase(record: record) { [weak self] error in
                    guard let self = self else { return }
                    self.dismissLoadingView()
                    self.delegate?.didTapSaveButton(index: self.index , name: self.nameTextField.text!)
                    self.dismiss(animated: true)
                    guard let error = error else { return }
                    self.presentAlertWithOk(title: LocalizedErrorMessages.somethingWentWrong, message: error.localizedDescription)
                }
            }
        }
    }
}

extension LOAddNameVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true}
        let newLength = text.count + string.count - range.length
        return newLength <= 12
    }
    
    func checkValidation(textIn textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.count < 4 || text.count > 12 {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.systemRed.cgColor
            saveButton.isEnabled = false
        } else {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            saveButton.isEnabled = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkValidation(textIn: textField)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkValidation(textIn: textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
        textField.layer.borderWidth = 0
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
